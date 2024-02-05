pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {Addresses} from "@forge-proposal-simulator/addresses/Addresses.sol";
import {IERC20} from "@forge-proposal-simulator/lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import {PostProposalCheck} from "@tests/integration/PostProposalCheck.t.sol";

import {IWell} from "@protocol/Interfaces/IWell.sol";
import {IMToken} from "@protocol/Interfaces/IMToken.sol";
import {IComptroller} from "@protocol/Interfaces/IComptroller.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";
import {IInterestRateModel} from "@protocol/Interfaces/IInterestRateModel.sol";
import {IMErc20DelegateFixer} from "@protocol/Interfaces/IMErc20DelegateFixer.sol";

/// @title MIP-M17 integration tests
/// @dev to run:
/// `forge test \
///     --match-contract MIPM17IntegrationTest \
///     --fork-url {rpc-url}`
contract MIPM17IntegrationTest is PostProposalCheck {
    /// @dev contracts
    IMErc20Delegator fraxDelegator;
    IMErc20Delegator nomadUSDCDelegator;
    IMErc20Delegator nomadETHDelegator;
    IMErc20Delegator nomadBTCDelegator;
    IERC20 token;
    IComptroller comptroller;

    /// @dev values prior to calling parent setup
    uint256 fraxTotalBorrows;
    uint256 fraxTotalReserves;
    uint256 fraxExchangeRate;
    uint256 fraxTotalSupply;
    uint256 fraxBorrowIndex;
    uint256 fraxSupplyRewardSpeeds;
    uint256 fraxAccrualBlockTimestampPrior;
    uint256 fraxBorrowRateMantissa;
    uint256 nomadUSDCBalance;
    uint256 nomadETHBalance;
    uint256 nomadBTCBalance;
    uint256 multisigUSDCBalance;
    uint256 multisigETHBalance;
    uint256 multisigBTCBalance;

    /// @dev addresses
    address multisig;

    function setUp() public override {
        /// @dev necessary to obtain borrows/reserves/ex.rate/supply before calling the parent setup
        Addresses _addresses = new Addresses("./addresses/addresses.json");

        fraxDelegator = IMErc20Delegator(payable(_addresses.getAddress("MOONWELL_mFRAX")));

        multisig = _addresses.getAddress("NOMAD_REALLOCATION_MULTISIG");

        /// @dev nomad remediation of USDC
        address mUSDC = _addresses.getAddress("MOONWELL_mUSDC");
        address madUSDC = _addresses.getAddress("madUSDC");
        nomadUSDCDelegator = IMErc20Delegator(mUSDC);
        nomadUSDCBalance = IERC20(madUSDC).balanceOf(mUSDC);
        multisigUSDCBalance = IERC20(madUSDC).balanceOf(multisig);

        /// @dev nomad remediation of ETH
        address mETH = _addresses.getAddress("MOONWELL_mETH");
        address madWETH = _addresses.getAddress("madWETH");
        nomadETHDelegator = IMErc20Delegator(mETH);
        nomadETHBalance = IERC20(madWETH).balanceOf(mETH);
        multisigETHBalance = IERC20(madWETH).balanceOf(multisig);

        /// @dev nomad remediation of BTC
        address mwBTC = _addresses.getAddress("MOONWELL_mwBTC");
        address madWBTC = _addresses.getAddress("madWBTC");
        nomadBTCDelegator = IMErc20Delegator(mwBTC);
        nomadBTCBalance = IERC20(madWBTC).balanceOf(mwBTC);
        multisigBTCBalance = IERC20(madWBTC).balanceOf(multisig);

        token = IERC20(_addresses.getAddress("FRAX"));
        comptroller = IComptroller(_addresses.getAddress("UNITROLLER"));

        /// @dev reserves, borrows, exchange rate and supply prior to running the prop
        fraxTotalBorrows = fraxDelegator.totalBorrows();
        fraxTotalReserves = fraxDelegator.totalReserves();
        fraxExchangeRate = fraxDelegator.exchangeRateStored();
        fraxTotalSupply = fraxDelegator.totalSupply();
        fraxBorrowIndex = fraxDelegator.borrowIndex();
        fraxSupplyRewardSpeeds = comptroller.supplyRewardSpeeds(0, address(fraxDelegator));
        fraxAccrualBlockTimestampPrior = fraxDelegator.accrualBlockTimestamp();

        IInterestRateModel interestRateModel = fraxDelegator.interestRateModel();
        uint256 fraxCashPrior = token.balanceOf(_addresses.getAddress("MOONWELL_mFRAX"));
        fraxBorrowRateMantissa = interestRateModel.getBorrowRate(fraxCashPrior, fraxTotalBorrows, fraxTotalReserves);

        /// @dev accrueInterest() will be run when the prop is executed
        super.setUp();
    }

    function testSetUp() public {
        /// @dev check that the borrows, reserves and index calculations match
        (, uint256 blockDelta) = subUInt(block.timestamp, fraxAccrualBlockTimestampPrior);
        (, Exp memory simpleInterestFactor) = mulScalar(Exp({mantissa: fraxBorrowRateMantissa}), blockDelta);
        (, uint256 interestAccumulated) = mulScalarTruncate(simpleInterestFactor, fraxTotalBorrows);
        (, uint256 _fraxTotalBorrows) = addUInt(interestAccumulated, fraxTotalBorrows - fraxDelegator.badDebt());
        (, uint256 _fraxTotalReserves) = mulScalarTruncateAddUInt(
            Exp({mantissa: fraxDelegator.reserveFactorMantissa()}), interestAccumulated, fraxTotalReserves
        );
        (, uint256 _fraxBorrowIndex) = mulScalarTruncateAddUInt(simpleInterestFactor, fraxBorrowIndex, fraxBorrowIndex);

        assertEq(fraxDelegator.totalBorrows(), _fraxTotalBorrows);
        assertEq(fraxDelegator.totalReserves(), _fraxTotalReserves);
        assertEq(fraxDelegator.borrowIndex(), _fraxBorrowIndex);

        uint256 _fraxCashPrior = token.balanceOf(addresses.getAddress("MOONWELL_mFRAX")) + fraxDelegator.badDebt();
        (, uint256 cashPlusBorrowsMinusReserves) = addThenSubUInt(_fraxCashPrior, _fraxTotalBorrows, _fraxTotalReserves);
        (, Exp memory _fraxExchangeRate) = getExp(cashPlusBorrowsMinusReserves, fraxTotalSupply);

        assertEq(fraxDelegator.exchangeRateStored(), _fraxExchangeRate.mantissa);
        assertEq(fraxDelegator.totalSupply(), fraxTotalSupply);
        assertEq(comptroller.supplyRewardSpeeds(0, address(fraxDelegator)), fraxSupplyRewardSpeeds);

        assertEq(nomadUSDCDelegator.balance(), 0);
        assertEq(nomadETHDelegator.balance(), 0);
        assertEq(nomadBTCDelegator.balance(), 0);

        assertEq(nomadUSDCDelegator.balanceOf(multisig), (multisigUSDCBalance + nomadUSDCBalance));
        assertEq(nomadETHDelegator.balanceOf(multisig), (multisigETHBalance + nomadETHBalance));
        assertEq(nomadBTCDelegator.balanceOf(multisig), (multisigBTCBalance + nomadBTCBalance));
    }

    function testMarketPaused() public {
        assertTrue(comptroller.borrowGuardianPaused(addresses.getAddress("MOONWELL_mFRAX")));
    }

    function testAccrueInterest() public {
        assertEq(fraxDelegator.accrueInterest(), 0);
    }

    function testAccrueInterestBlockTimestamp() public {
        assertEq(fraxDelegator.accrueInterest(), 0);
        assertEq(fraxDelegator.accrualBlockTimestamp(), block.timestamp);
    }

    function testMint() public {
        address minter = address(this);
        uint256 mintAmount = 10e8;

        uint256 startingTokenBalance = token.balanceOf(address(fraxDelegator));

        deal(address(token), minter, mintAmount);
        token.approve(address(fraxDelegator), mintAmount);

        assertEq(fraxDelegator.mint(mintAmount), 0);
        (, uint256 mintedAmount) =
            divScalarByExpTruncate(mintAmount, Exp({mantissa: fraxDelegator.exchangeRateStored()}));
        assertEq(fraxDelegator.balanceOf(minter), mintedAmount);
        assertEq(token.balanceOf(address(fraxDelegator)) - startingTokenBalance, mintAmount);
    }

    function testMintMoreThanUserBalance() public {
        address minter = address(this);
        uint256 dealAmount = 10e8;
        uint256 mintAmount = 100e8;

        deal(address(token), minter, dealAmount);
        token.approve(address(fraxDelegator), mintAmount);

        vm.expectRevert("ERC20: transfer amount exceeds balance");
        fraxDelegator.mint(mintAmount);
    }

    function testLiquidityShortfall() public {
        (uint256 err,, uint256 shortfall) = comptroller.getAccountLiquidity(address(this));

        assertEq(err, 0);
        assertEq(shortfall, 0);
    }

    function testUnpauseMarket() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        comptroller._setBorrowPaused(IMToken(address(fraxDelegator)), false);
        vm.stopPrank();
    }

    function testEnterMarket() public {
        address[] memory mTokens = new address[](1);
        mTokens[0] = address(fraxDelegator);

        comptroller.enterMarkets(mTokens);

        assertTrue(comptroller.checkMembership(address(this), IMToken(addresses.getAddress("MOONWELL_mFRAX"))));
    }

    function testMintEnterMarket() public {
        testMint();
        testEnterMarket();
    }

    function testEnterExitMarket() public {
        testMintEnterMarket();

        comptroller.exitMarket(address(fraxDelegator));
        assertFalse(comptroller.checkMembership(address(this), IMToken(addresses.getAddress("MOONWELL_mFRAX"))));
    }

    function testExitMarketNotEntered() public {
        assertEq(comptroller.exitMarket(address(fraxDelegator)), 0);
    }

    function testExitMarketWithActiveBorrow() public {
        testMintEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        address borrower = address(this);
        uint256 borrowAmount = 50e6;
        uint256 _totalFRAXBorrows = fraxDelegator.totalBorrows();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(fraxDelegator.totalBorrows(), (_totalFRAXBorrows + borrowAmount));
        assertEq(token.balanceOf(borrower), borrowAmount);

        /// @dev Error.NONZERO_BORROW_BALANCE
        assertEq(comptroller.exitMarket(address(fraxDelegator)), 12);
    }

    function testMintNoLiquidityShortfall() public {
        testMintEnterMarket();
        testLiquidityShortfall();
    }

    function testMintBorrow() public {
        testMintEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        address borrower = address(this);
        uint256 borrowAmount = 50e6;
        uint256 _totalFRAXBorrows = fraxDelegator.totalBorrows();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(fraxDelegator.totalBorrows(), (_totalFRAXBorrows + borrowAmount));
        assertEq(token.balanceOf(borrower), borrowAmount);

        testBorrowRewardSpeeds();
    }

    function testMintBorrowPaused() public {
        testMintEnterMarket();

        uint256 borrowAmount = 50e6;

        vm.expectRevert("borrow is paused");
        fraxDelegator.borrow(borrowAmount);
    }

    function testMintBorrowLiquidityShortfall() public {
        testMintEnterMarket();
        testUnpauseMarket();

        address borrower = address(this);
        uint256 borrowAmount = 11e18;

        /// @dev Error.INSUFFICIENT_LIQUIDITY
        assertEq(fraxDelegator.borrow(borrowAmount), 3);
        assertEq(token.balanceOf(borrower), 0);

        testBorrowRewardSpeeds();
    }

    function testMintBorrowMaxAmount() public {
        address borrower = address(this);
        uint256 mintAmount = 100_000_000e18;
        uint256 startingTokenBalance = token.balanceOf(address(fraxDelegator));

        deal(address(token), borrower, mintAmount);

        token.approve(address(fraxDelegator), mintAmount);
        assertEq(fraxDelegator.mint(mintAmount), 0);

        (, uint256 mintedAmount) =
            divScalarByExpTruncate(mintAmount, Exp({mantissa: fraxDelegator.exchangeRateStored()}));
        assertEq(fraxDelegator.balanceOf(borrower), mintedAmount);
        assertEq(token.balanceOf(address(fraxDelegator)) - startingTokenBalance, mintAmount);

        testEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        uint256 borrowCap = comptroller.borrowCaps(addresses.getAddress("MOONWELL_mFRAX"));
        uint256 _totalFRAXBorrows = fraxDelegator.totalBorrows();
        uint256 borrowAmount = borrowCap - _totalFRAXBorrows - 1;

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);
        assertEq(fraxDelegator.totalBorrows(), (_totalFRAXBorrows + borrowAmount));
    }

    function testMintBorrowCapReached() public {
        address borrower = address(this);
        uint256 mintAmount = 100_000_000e18;
        uint256 startingTokenBalance = token.balanceOf(address(fraxDelegator));

        deal(address(token), borrower, mintAmount);

        token.approve(address(fraxDelegator), mintAmount);
        assertEq(fraxDelegator.mint(mintAmount), 0);

        (, uint256 mintedAmount) =
            divScalarByExpTruncate(mintAmount, Exp({mantissa: fraxDelegator.exchangeRateStored()}));
        assertEq(fraxDelegator.balanceOf(borrower), mintedAmount);
        assertEq(token.balanceOf(address(fraxDelegator)) - startingTokenBalance, mintAmount);

        testEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        uint256 borrowCap = comptroller.borrowCaps(addresses.getAddress("MOONWELL_mFRAX"));
        uint256 _totalFRAXBorrows = fraxDelegator.totalBorrows();
        uint256 borrowAmount = borrowCap - _totalFRAXBorrows;

        vm.expectRevert("market borrow cap reached");
        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(fraxDelegator.totalBorrows(), _totalFRAXBorrows);
    }

    function testMintBorrowRepay() public {
        testMintEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        address borrower = address(this);
        uint256 borrowAmount = 50e6;
        uint256 _totalFRAXBorrows = fraxDelegator.totalBorrows();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(fraxDelegator.totalBorrows(), (_totalFRAXBorrows + borrowAmount));
        assertEq(token.balanceOf(borrower), borrowAmount);

        token.approve(address(fraxDelegator), borrowAmount);
        assertEq(fraxDelegator.repayBorrow(borrowAmount), 0);
        assertEq(fraxDelegator.totalBorrows(), _totalFRAXBorrows);
        assertEq(token.balanceOf(borrower), 0);
    }

    function testMintBorrowRepayOnBehalf() public {
        testMintEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;
        uint256 _totalFRAXBorrows = fraxDelegator.totalBorrows();
        uint256 balance = fraxDelegator.balanceOf(address(this));

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(fraxDelegator.totalBorrows(), (_totalFRAXBorrows + borrowAmount));
        assertEq(token.balanceOf(borrower), borrowAmount);

        address payer = vm.addr(1);

        vm.startPrank(payer);
        deal(address(token), payer, mintAmount);
        token.approve(address(fraxDelegator), borrowAmount);
        assertEq(fraxDelegator.repayBorrowBehalf(address(this), borrowAmount), 0);
        vm.stopPrank();

        assertEq(fraxDelegator.totalBorrows(), _totalFRAXBorrows);
        assertEq(fraxDelegator.balanceOf(address(this)), balance);
    }

    function testMintBorrowRepayMorethanBorrowed() public {
        testMintEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;
        uint256 _totalFRAXBorrows = fraxDelegator.totalBorrows();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(fraxDelegator.totalBorrows(), (_totalFRAXBorrows + borrowAmount));
        assertEq(token.balanceOf(borrower), borrowAmount);

        address payer = vm.addr(1);

        vm.startPrank(payer);
        deal(address(token), payer, mintAmount);
        token.approve(address(fraxDelegator), borrowAmount + 1_000e6);
        vm.expectRevert("REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED");
        fraxDelegator.repayBorrowBehalf(address(this), borrowAmount + 1_000e6);
        vm.stopPrank();
    }

    function testBorrowRewardSpeeds() public {
        assertEq(comptroller.borrowRewardSpeeds(0, address(fraxDelegator)), 1);
    }

    function testMintRedeem() public {
        testMint();

        uint256 balance = fraxDelegator.balanceOf(address(this));
        uint256 _fraxTotalSupply = fraxDelegator.totalSupply();

        assertEq(fraxDelegator.redeem(balance), 0);

        (, uint256 redeemed) = mulScalarTruncate(Exp({mantissa: fraxDelegator.exchangeRateStored()}), balance);
        assertEq(token.balanceOf(address(this)), redeemed);
        assertEq(fraxDelegator.totalSupply(), (_fraxTotalSupply - balance));
    }

    function testMintRedeemZeroTokens() public {
        testMint();

        uint256 balance = fraxDelegator.balanceOf(address(this));
        uint256 _fraxTotalSupply = fraxDelegator.totalSupply();

        assertEq(fraxDelegator.redeem(0), 0);
        assertEq(fraxDelegator.balanceOf(address(this)), balance);
        assertEq(fraxDelegator.totalSupply(), _fraxTotalSupply);
    }

    function testMintRedeemMoreTokens() public {
        testMint();

        uint256 balance = fraxDelegator.balanceOf(address(this));
        assertEq(fraxDelegator.redeem(balance + 1_000e6), 9);
    }

    function testMintClaimRewardsSupplier() public {
        testMintEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        address supplier = address(this);
        uint256 mintAmount = 10e18;

        deal(address(token), supplier, mintAmount);
        token.approve(address(fraxDelegator), mintAmount);

        assertEq(fraxDelegator.mint(mintAmount), 0);

        IWell well = IWell(addresses.getAddress("WELL"));
        assertEq(well.balanceOf(supplier), 0);

        vm.warp(block.timestamp + 10);
        comptroller.claimReward(0, payable(supplier));
        /// TODO correctly calculate the rewards distributed
        assertTrue(well.balanceOf(supplier) > 0);
    }

    function testMintClaimInvalidRewardType() public {
        testMintEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        address claimant = address(this);
        uint256 mintAmount = 10e18;

        deal(address(token), claimant, mintAmount);
        token.approve(address(fraxDelegator), mintAmount);

        assertEq(fraxDelegator.mint(mintAmount), 0);

        vm.roll(block.number + 100);
        vm.expectRevert("rewardType is invalid");
        comptroller.claimReward(2, payable(claimant));
    }

    /// TODO
    function testLiquidateBorrow() public {}
}
