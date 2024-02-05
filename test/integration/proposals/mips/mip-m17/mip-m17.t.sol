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
import {IMErc20DelegateFixer} from "@protocol/Interfaces/IMErc20DelegateFixer.sol";

/// @title MIP-M17 integration tests
/// @dev to run:
/// `forge test \
///     --match-contract MIPM17IntegrationTest \
///     --fork-url {rpc-url} \
///     --fork-block-number 5453110`
contract MIPM17IntegrationTest is PostProposalCheck {
    /// @dev contracts
    IMErc20Delegator fraxDelegator;
    IMErc20Delegator nomadUSDCDelegator;
    IMErc20Delegator nomadETHDelegator;
    IMErc20Delegator nomadBTCDelegator;
    IERC20 token;
    IComptroller comptroller;

    /// @dev values prior to calling parent setup
    uint256 totalFRAXReserves;
    uint256 totalFRAXBorrows;
    uint256 fraxExchangeRate;
    uint256 fraxTotalSupply;
    uint256 fraxSupplyRewardSpeeds;
    uint256 nomadUSDCBalance;
    uint256 nomadETHBalance;
    uint256 nomadBTCBalance;
    uint256 multisigUSDCBalance;
    uint256 multisigETHBalance;
    uint256 multisigBTCBalance;

    /// @dev addresses
    address multisig;

    function setUp() override public {
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

        fraxDelegator.accrueInterest();

        /// @dev reserves, borrows, exchange rate and supply prior to running the prop
        totalFRAXReserves = fraxDelegator.totalReserves();
        totalFRAXBorrows = fraxDelegator.totalBorrows();
        fraxExchangeRate = fraxDelegator.exchangeRateStored();
        fraxTotalSupply = fraxDelegator.totalSupply();
        fraxSupplyRewardSpeeds = comptroller.supplyRewardSpeeds(0, address(fraxDelegator));

        super.setUp();
    }

    function testSetUp() public {
        /// @dev constants as of block 5453110
        assertEq(totalFRAXReserves, 192088687826830391504748);
        assertEq(totalFRAXBorrows, 3238083326555520628961815);
        assertEq(fraxExchangeRate, 229247873259888279522173114);

        assertEq(fraxDelegator.totalReserves(), 192145283329395620002646);
        assertEq(fraxDelegator.totalBorrows(), 2880378125492784178717951);
        assertEq(fraxDelegator.exchangeRateStored(), 229272010396607327821609962);
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
        assertTrue(fraxDelegator.balanceOf(minter) > 0);
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

    function testliquidityShortfall() public {
        (uint256 err,, uint256 shortfall) = comptroller.getAccountLiquidity(address(this));

        assertEq(err, 0);
        assertEq(shortfall, 0);
    }

    function testUnpauseMarket() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        comptroller._setBorrowPaused(IMToken(address(fraxDelegator)), false);
        vm.stopPrank();
    }

    function testMintEnterMarket() public {
        testMint();

        address[] memory mTokens = new address[](1);
        mTokens[0] = address(fraxDelegator);

        comptroller.enterMarkets(mTokens);

        assertTrue(comptroller.checkMembership(address(this), IMToken(addresses.getAddress("MOONWELL_mFRAX"))));
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
        address borrower = address(this);
        uint256 borrowAmount = 50e6;

        testMintEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        /// @dev Error.NONZERO_BORROW_BALANCE
        assertEq(comptroller.exitMarket(address(fraxDelegator)), 12);
    }

    function testMintNoLiquidityShortfall() public {
        testMintEnterMarket();
        testliquidityShortfall();
    }

    function testMintBorrow() public {
        address borrower = address(this);
        uint256 borrowAmount = 50e6;

        testMintEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        testBorrowRewardSpeeds();
    }

    function testMintBorrowPaused() public {
        address borrower = address(this);
        uint256 borrowAmount = 50e6;

        testMintEnterMarket();

        vm.expectRevert("borrow is paused");
        fraxDelegator.borrow(borrowAmount);
    }

    function testMintBorrowLiquidityShortfall() public {
        address borrower = address(this);
        uint256 borrowAmount = 11e18;

        testMintEnterMarket();
        testUnpauseMarket();

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

        assertTrue(fraxDelegator.balanceOf(borrower) > 0);
        assertEq(token.balanceOf(address(fraxDelegator)) - startingTokenBalance, mintAmount);

        testMintEnterMarket();

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        testliquidityShortfall();
        testUnpauseMarket();

        uint256 borrowCap = comptroller.borrowCaps(addresses.getAddress("MOONWELL_mFRAX"));
        uint256 _totalBorrows = fraxDelegator.totalBorrows();
        uint256 borrowAmount = borrowCap - _totalBorrows - 1;

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);
    }

    function testMintBorrowCapReached() public {
        address borrower = address(this);
        uint256 mintAmount = 100_000_000e18;

        uint256 startingTokenBalance = token.balanceOf(address(fraxDelegator));

        deal(address(token), borrower, mintAmount);

        token.approve(address(fraxDelegator), mintAmount);
        assertEq(fraxDelegator.mint(mintAmount), 0);

        assertTrue(fraxDelegator.balanceOf(borrower) > 0);
        assertEq(token.balanceOf(address(fraxDelegator)) - startingTokenBalance, mintAmount);

        testMintEnterMarket();

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        testliquidityShortfall();
        testUnpauseMarket();

        uint256 borrowCap = comptroller.borrowCaps(addresses.getAddress("MOONWELL_mFRAX"));
        uint256 _totalBorrows = fraxDelegator.totalBorrows();
        uint256 borrowAmount = borrowCap - _totalBorrows;

        vm.expectRevert("market borrow cap reached");
        assertEq(fraxDelegator.borrow(borrowAmount), 0);
    }

    function testMintBorrowRepay() public {
        address borrower = address(this);
        uint256 borrowAmount = 50e6;

        testMintEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        token.approve(address(fraxDelegator), borrowAmount);
        assertEq(fraxDelegator.repayBorrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), 0);
    }

    function testMintBorrowRepayOnBehalf() public {
        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;

        testMintEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        address payer = vm.addr(1);

        vm.startPrank(payer);
        deal(address(token), payer, mintAmount);
        token.approve(address(fraxDelegator), borrowAmount);
        assertEq(fraxDelegator.repayBorrowBehalf(address(this), borrowAmount), 0);
        vm.stopPrank();
    }

    function testMintBorrowRepayMorethanBorrowed() public {
        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;

        testMintEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
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

    function testMintRedeem() private {
        testMint();

        uint256 balance = fraxDelegator.balanceOf(address(this));
        assertEq(fraxDelegator.redeem(balance), 0);
    }

    function testMintRedeemZeroTokens() private {
        testMint();
        assertEq(fraxDelegator.redeem(0), 0);
    }

     function testMintRedeemMoreTokens() private {
        testMint();

        uint256 balance = fraxDelegator.balanceOf(address(this));
        assertEq(fraxDelegator.redeem(balance + 1_000e6), 9);
    }

    function testMintClaimWELLRewardsSupplier() public {
        address supplier = address(this);
        uint256 mintAmount = 10e18;

        testMintEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        deal(address(token), supplier, mintAmount);
        token.approve(address(fraxDelegator), mintAmount);

        assertEq(fraxDelegator.mint(mintAmount), 0);

        IWell well = IWell(addresses.getAddress("WELL"));
        assertEq(well.balanceOf(supplier), 0);

        vm.warp(block.timestamp + 10);
        comptroller.claimReward(0, payable(supplier));
        assertTrue(well.balanceOf(supplier) > 0);
    }

    function testMintClaimWELLRewardsBorrower() public {}

    function testMintClaimInvalidRewardType() private {
        address claimant = address(this);
        uint256 mintAmount = 10e18;

        testMintEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        deal(address(token), claimant, mintAmount);
        token.approve(address(fraxDelegator), mintAmount);

        assertEq(fraxDelegator.mint(mintAmount), 0);

        vm.roll(block.number + 100);
        vm.expectRevert("rewardType is invalid");
        comptroller.claimReward(2, payable(claimant));
    }

    function testLiquidateBorrow() public {}
}
