pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {Addresses} from "@forge-proposal-simulator/addresses/Addresses.sol";
import {IERC20} from "@forge-proposal-simulator/lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@forge-proposal-simulator/lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

import {IWell} from "@protocol/Interfaces/IWell.sol";
import {IMToken} from "@protocol/Interfaces/IMToken.sol";
import {MockxcDOT} from "@tests/mock/MockxcDOT.sol";
import {MockxcUSDT} from "@tests/mock/MockxcUSDT.sol";
import {IComptroller} from "@protocol/Interfaces/IComptroller.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";
import {PostProposalCheck} from "@tests/integration/PostProposalCheck.sol";
import {IInterestRateModel} from "@protocol/Interfaces/IInterestRateModel.sol";
import {IMErc20DelegateFixer} from "@protocol/Interfaces/IMErc20DelegateFixer.sol";

/// @title MIP-M17 integration tests
/// @dev to run:
/// `forge test \
///     --match-contract MIPM17IntegrationTest \
///     --fork-url {rpc-url}`
contract MIPM17IntegrationTest is PostProposalCheck {
    event BadDebtRepayed(uint256);

    /// @dev contracts
    IMErc20Delegator mxcDotDelegator;
    IMErc20Delegator fraxDelegator;
    IMErc20Delegator nomadUSDCDelegator;
    IMErc20Delegator nomadETHDelegator;
    IMErc20Delegator nomadBTCDelegator;
    IERC20 fraxToken;
    IComptroller comptroller;

    /// @dev values prior to calling parent setup
    uint256 public fraxTotalBorrows;
    uint256 public fraxTotalReserves;
    uint256 public fraxTotalSupply;
    uint256 public fraxBorrowIndex;
    uint256 public fraxSupplyRewardSpeeds;
    uint256 public fraxAccrualBlockTimestampPrior;
    uint256 public fraxBorrowRateMantissa;
    uint256 public nomadUSDCBalance;
    uint256 public nomadETHBalance;
    uint256 public nomadBTCBalance;
    uint256 public multisigUSDCBalance;
    uint256 public multisigETHBalance;
    uint256 public multisigBTCBalance;

    /// @notice current balance of the mxcDOT token in the mxcDOT market
    /// on 2/12/24 to allow setting the balance in the mock contract
    uint256 public constant xcDotMtokenBalance = 3414954090440141;

    /// @dev addresses
    address multisig;

    function setUp() public override {
        /// @dev necessary to obtain borrows/reserves/ex.rate/supply before calling the parent setup
        Addresses _addresses = new Addresses("./addresses/addresses.json");

        {
            MockxcUSDT mockUSDT = new MockxcUSDT();
            address mockUSDTAddress = address(mockUSDT);
            uint256 codeSize;
            assembly {
                codeSize := extcodesize(mockUSDTAddress)
            }

            bytes memory runtimeBytecode = new bytes(codeSize);

            assembly {
                extcodecopy(
                    mockUSDTAddress,
                    add(runtimeBytecode, 0x20),
                    0,
                    codeSize
                )
            }

            vm.etch(_addresses.getAddress("xcUSDT"), runtimeBytecode);
        }

        {
            MockxcDOT mockDot = new MockxcDOT();
            address mockDotAddress = address(mockDot);
            uint256 codeSize;
            assembly {
                codeSize := extcodesize(mockDotAddress)
            }

            bytes memory runtimeBytecode = new bytes(codeSize);

            assembly {
                extcodecopy(
                    mockDotAddress,
                    add(runtimeBytecode, 0x20),
                    0,
                    codeSize
                )
            }

            // console.log(
            //     "xcDot symbol before upgrade: ",
            //     ERC20(_addresses.getAddress("xcDOT")).symbol()
            // );
            vm.etch(_addresses.getAddress("xcDOT"), runtimeBytecode);
            console.log(
                "xcDot symbol after upgrade: ",
                ERC20(_addresses.getAddress("xcDOT")).symbol()
            );
            console.log(
                "xcDot name after upgrade: ",
                ERC20(_addresses.getAddress("xcDOT")).name()
            );

            deal(
                _addresses.getAddress("xcDOT"),
                _addresses.getAddress("MOONWELL_mxcDOT"),
                xcDotMtokenBalance,
                true
            );

            mockDot = MockxcDOT(_addresses.getAddress("xcDOT"));
            mockDot.balanceOf(address(this));
            assertEq(
                mockDot.balanceOf(_addresses.getAddress("MOONWELL_mxcDOT")),
                xcDotMtokenBalance,
                "incorrect xcDOT balance"
            );
            assertEq(
                mockDot.totalSupply(),
                xcDotMtokenBalance,
                "incorrect xcDOT total supply"
            );
        }

        fraxDelegator = IMErc20Delegator(
            payable(_addresses.getAddress("MOONWELL_mFRAX"))
        );

        mxcDotDelegator = IMErc20Delegator(
            payable(_addresses.getAddress("MOONWELL_mxcDOT"))
        );

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

        fraxToken = IERC20(_addresses.getAddress("FRAX"));
        comptroller = IComptroller(_addresses.getAddress("UNITROLLER"));

        /// @dev borrows, reserves, supply and friends - prior to running the prop
        fraxTotalBorrows = fraxDelegator.totalBorrows();
        fraxTotalReserves = fraxDelegator.totalReserves();
        fraxTotalSupply = fraxDelegator.totalSupply();
        fraxBorrowIndex = fraxDelegator.borrowIndex();
        fraxSupplyRewardSpeeds = comptroller.supplyRewardSpeeds(
            0,
            address(fraxDelegator)
        );
        fraxAccrualBlockTimestampPrior = fraxDelegator.accrualBlockTimestamp();

        IInterestRateModel interestRateModel = fraxDelegator
            .interestRateModel();
        uint256 fraxCashPrior = fraxToken.balanceOf(
            _addresses.getAddress("MOONWELL_mFRAX")
        );
        fraxBorrowRateMantissa = interestRateModel.getBorrowRate(
            fraxCashPrior,
            fraxTotalBorrows,
            fraxTotalReserves
        );

        /// @dev accrueInterest() will be run when the prop is executed
        super.setUp();
    }

    function testSetUp() public {
        /// TODO add tests for xcDOT borrows, reserves, indexes

        /// @dev check that the borrows, reserves and index calculations match
        (, uint256 blockDelta) = subUInt(
            block.timestamp,
            fraxAccrualBlockTimestampPrior
        );
        (, Exp memory simpleInterestFactor) = mulScalar(
            Exp({mantissa: fraxBorrowRateMantissa}),
            blockDelta
        );
        (, uint256 interestAccumulated) = mulScalarTruncate(
            simpleInterestFactor,
            fraxTotalBorrows
        );
        (, uint256 _fraxTotalBorrows) = addUInt(
            interestAccumulated,
            fraxTotalBorrows - fraxDelegator.badDebt()
        );
        (, uint256 _fraxTotalReserves) = mulScalarTruncateAddUInt(
            Exp({mantissa: fraxDelegator.reserveFactorMantissa()}),
            interestAccumulated,
            fraxTotalReserves
        );
        (, uint256 _fraxBorrowIndex) = mulScalarTruncateAddUInt(
            simpleInterestFactor,
            fraxBorrowIndex,
            fraxBorrowIndex
        );

        assertEq(fraxDelegator.totalBorrows(), _fraxTotalBorrows);
        assertEq(fraxDelegator.totalReserves(), _fraxTotalReserves);
        assertEq(fraxDelegator.borrowIndex(), _fraxBorrowIndex);

        uint256 _fraxCashPrior = fraxToken.balanceOf(
            addresses.getAddress("MOONWELL_mFRAX")
        ) + fraxDelegator.badDebt();
        (, uint256 cashPlusBorrowsMinusReserves) = addThenSubUInt(
            _fraxCashPrior,
            _fraxTotalBorrows,
            _fraxTotalReserves
        );
        (, Exp memory _fraxExchangeRate) = getExp(
            cashPlusBorrowsMinusReserves,
            fraxTotalSupply
        );

        assertEq(
            fraxDelegator.exchangeRateStored(),
            _fraxExchangeRate.mantissa
        );
        assertEq(fraxDelegator.totalSupply(), fraxTotalSupply);
        assertEq(
            comptroller.supplyRewardSpeeds(0, address(fraxDelegator)),
            fraxSupplyRewardSpeeds
        );

        assertEq(nomadUSDCDelegator.balance(), 0);
        assertEq(nomadETHDelegator.balance(), 0);
        assertEq(nomadBTCDelegator.balance(), 0);

        assertEq(
            nomadUSDCDelegator.balanceOf(multisig),
            (multisigUSDCBalance + nomadUSDCBalance)
        );
        assertEq(
            nomadETHDelegator.balanceOf(multisig),
            (multisigETHBalance + nomadETHBalance)
        );
        assertEq(
            nomadBTCDelegator.balanceOf(multisig),
            (multisigBTCBalance + nomadBTCBalance)
        );

        assertEq(
            fraxDelegator.implementation(),
            addresses.getAddress("MERC20_BAD_DEBT_DELEGATE_FIXER_LOGIC")
        );
        assertEq(
            mxcDotDelegator.implementation(),
            addresses.getAddress("MERC20_BAD_DEBT_DELEGATE_FIXER_LOGIC")
        );

        /// nomad
        assertEq(
            nomadBTCDelegator.implementation(),
            addresses.getAddress("MERC20_DELEGATE_FIXER_NOMAD_LOGIC")
        );
        assertEq(
            nomadETHDelegator.implementation(),
            addresses.getAddress("MERC20_DELEGATE_FIXER_NOMAD_LOGIC")
        );
        assertEq(
            nomadUSDCDelegator.implementation(),
            addresses.getAddress("MERC20_DELEGATE_FIXER_NOMAD_LOGIC")
        );
    }

    function testMarketPaused() public {
        assertTrue(
            comptroller.borrowGuardianPaused(
                addresses.getAddress("MOONWELL_mFRAX")
            )
        );
    }

    function testNonAdminCannotFixUser() public {
        vm.expectRevert("only the admin may call fixUser");
        IMErc20DelegateFixer(address(fraxDelegator)).fixUser(
            address(this),
            address(this)
        );
    }

    function testAccrueInterest() public {
        assertEq(fraxDelegator.accrueInterest(), 0);
    }

    function testAccrueInterestBlockTimestamp() public {
        assertEq(fraxDelegator.accrueInterest(), 0);
        assertEq(fraxDelegator.accrualBlockTimestamp(), block.timestamp);
    }

    function testRepayBadDebtFailsAmountExceedsBadDebt() public {
        uint256 existingBadDebt = fraxDelegator.badDebt();

        vm.expectRevert("amount exceeds bad debt");
        IMErc20DelegateFixer(address(fraxDelegator)).repayBadDebt(
            existingBadDebt + 1
        );
    }

    function testRepayBadDebtSucceeds(uint256 repayAmount) public {
        uint256 startingExchangeRate = fraxDelegator.exchangeRateStored();
        uint256 existingBadDebt = fraxDelegator.badDebt();

        repayAmount = _bound(repayAmount, 1, existingBadDebt);
        deal(address(fraxDelegator.underlying()), address(this), repayAmount);
        fraxToken.approve(address(fraxDelegator), repayAmount);

        vm.expectEmit(true, true, true, true, address(fraxDelegator));
        emit BadDebtRepayed(repayAmount);
        IMErc20DelegateFixer(address(fraxDelegator)).repayBadDebt(repayAmount);

        assertEq(
            fraxDelegator.badDebt(),
            existingBadDebt - repayAmount,
            "bad debt incorrect updated"
        );
        assertEq(
            fraxDelegator.exchangeRateStored(),
            startingExchangeRate,
            "exchange rate should not change on bad debt repayment"
        );
    }

    function testMint() public {
        fraxDelegator.accrueInterest();

        address minter = address(this);
        uint256 mintAmount = 100e18;

        uint256 startingTokenBalance = fraxToken.balanceOf(
            address(fraxDelegator)
        );

        deal(address(fraxToken), minter, mintAmount);
        fraxToken.approve(address(fraxDelegator), mintAmount);

        uint256 startingFraxTotalSupply = fraxDelegator.totalSupply();
        uint256 currentExchangeRate = fraxDelegator.exchangeRateStored();

        assertEq(fraxDelegator.mint(mintAmount), 0, "mfrax mint error");
        (, uint256 mintedAmount) = divScalarByExpTruncate(
            mintAmount,
            Exp({mantissa: fraxDelegator.exchangeRateStored()})
        );
        assertEq(
            fraxDelegator.balanceOf(minter),
            mintedAmount,
            "frax minter balance incorrect"
        );
        assertEq(
            fraxToken.balanceOf(address(fraxDelegator)) - startingTokenBalance,
            mintAmount,
            "frax balance of mfrax did not increase correctly"
        );
        assertEq(
            fraxDelegator.totalSupply(),
            startingFraxTotalSupply +
                ((mintAmount * 1e18) / currentExchangeRate),
            "delegator total"
        );
    }

    function testMintMoreThanUserBalance() public {
        address minter = address(this);
        uint256 dealAmount = 10e8;
        uint256 mintAmount = 100e8;

        deal(address(fraxToken), minter, dealAmount);
        fraxToken.approve(address(fraxDelegator), mintAmount);

        vm.expectRevert("ERC20: transfer amount exceeds balance");
        fraxDelegator.mint(mintAmount);
    }

    function testLiquidityShortfall() public {
        (uint256 err, , uint256 shortfall) = comptroller.getAccountLiquidity(
            address(this)
        );

        assertEq(err, 0);
        assertEq(shortfall, 0);
    }

    function testUnpauseMarket() public {
        assertTrue(
            comptroller.borrowGuardianPaused(
                addresses.getAddress("MOONWELL_mFRAX")
            ),
            "borrow guardian not paused"
        );

        vm.prank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        comptroller._setBorrowPaused(IMToken(address(fraxDelegator)), false);

        assertFalse(
            comptroller.borrowGuardianPaused(
                addresses.getAddress("MOONWELL_mFRAX")
            ),
            "borrow guardian not paused"
        );
    }

    function testEnterMarket() public {
        address[] memory mTokens = new address[](1);
        mTokens[0] = address(fraxDelegator);
        assertFalse(
            comptroller.checkMembership(
                address(this),
                IMToken(addresses.getAddress("MOONWELL_mFRAX"))
            )
        );

        comptroller.enterMarkets(mTokens);

        assertTrue(
            comptroller.checkMembership(
                address(this),
                IMToken(addresses.getAddress("MOONWELL_mFRAX"))
            )
        );
    }

    function testMintEnterMarket() public {
        testMint();
        testEnterMarket();
    }

    function testEnterExitMarket() public {
        testMintEnterMarket();

        comptroller.exitMarket(address(fraxDelegator));
        assertFalse(
            comptroller.checkMembership(
                address(this),
                IMToken(addresses.getAddress("MOONWELL_mFRAX"))
            )
        );
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
        uint256 _fraxTotalBorrows = fraxDelegator.totalBorrows();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(
            fraxDelegator.totalBorrows(),
            (_fraxTotalBorrows + borrowAmount)
        );
        assertEq(fraxToken.balanceOf(borrower), borrowAmount);

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
        uint256 _fraxTotalBorrows = fraxDelegator.totalBorrows();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(
            fraxDelegator.totalBorrows(),
            (_fraxTotalBorrows + borrowAmount)
        );
        assertEq(fraxToken.balanceOf(borrower), borrowAmount);

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

        address[] memory mTokens = new address[](1);
        mTokens[0] = address(fraxDelegator);

        uint256[] memory borrowCaps = new uint256[](1);
        borrowCaps[0] = type(uint256).max;

        vm.prank(comptroller.admin());
        comptroller._setMarketBorrowCaps(mTokens, borrowCaps);

        address borrower = address(this);
        uint256 borrowAmount = 1000e18;

        /// @dev Error.INSUFFICIENT_LIQUIDITY
        assertEq(
            fraxDelegator.borrow(borrowAmount),
            3,
            "incorrect borrow error"
        );
        assertEq(
            fraxToken.balanceOf(borrower),
            0,
            "incorrect frax token balance"
        );

        testBorrowRewardSpeeds();
    }

    function testMintBorrowMaxAmount() public {
        address borrower = address(this);
        uint256 mintAmount = 100_000_000e18;
        uint256 startingTokenBalance = fraxToken.balanceOf(
            address(fraxDelegator)
        );

        deal(address(fraxToken), borrower, mintAmount);

        fraxToken.approve(address(fraxDelegator), mintAmount);
        assertEq(fraxDelegator.mint(mintAmount), 0);

        (, uint256 mintedAmount) = divScalarByExpTruncate(
            mintAmount,
            Exp({mantissa: fraxDelegator.exchangeRateStored()})
        );
        assertEq(fraxDelegator.balanceOf(borrower), mintedAmount);
        assertEq(
            fraxToken.balanceOf(address(fraxDelegator)) - startingTokenBalance,
            mintAmount
        );

        testEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        uint256 borrowCap = comptroller.borrowCaps(
            addresses.getAddress("MOONWELL_mFRAX")
        );
        uint256 _fraxTotalBorrows = fraxDelegator.totalBorrows();
        uint256 borrowAmount = borrowCap - _fraxTotalBorrows - 1;

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(fraxToken.balanceOf(borrower), borrowAmount);
        assertEq(
            fraxDelegator.totalBorrows(),
            (_fraxTotalBorrows + borrowAmount)
        );
    }

    function testMintBorrowCapReached() public {
        address borrower = address(this);
        uint256 mintAmount = 100_000_000e18;
        uint256 startingTokenBalance = fraxToken.balanceOf(
            address(fraxDelegator)
        );

        deal(address(fraxToken), borrower, mintAmount);

        fraxToken.approve(address(fraxDelegator), mintAmount);
        assertEq(fraxDelegator.mint(mintAmount), 0);

        (, uint256 mintedAmount) = divScalarByExpTruncate(
            mintAmount,
            Exp({mantissa: fraxDelegator.exchangeRateStored()})
        );
        assertEq(fraxDelegator.balanceOf(borrower), mintedAmount);
        assertEq(
            fraxToken.balanceOf(address(fraxDelegator)) - startingTokenBalance,
            mintAmount
        );

        testEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        uint256 borrowCap = comptroller.borrowCaps(
            addresses.getAddress("MOONWELL_mFRAX")
        );
        uint256 _fraxTotalBorrows = fraxDelegator.totalBorrows();
        uint256 borrowAmount = borrowCap - _fraxTotalBorrows;

        vm.expectRevert("market borrow cap reached");
        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(fraxDelegator.totalBorrows(), _fraxTotalBorrows);
    }

    function testMintBorrowRepay() public {
        testMintEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        address borrower = address(this);
        uint256 borrowAmount = 50e6;
        uint256 _fraxTotalBorrows = fraxDelegator.totalBorrows();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(
            fraxDelegator.totalBorrows(),
            (_fraxTotalBorrows + borrowAmount)
        );
        assertEq(fraxToken.balanceOf(borrower), borrowAmount);

        fraxToken.approve(address(fraxDelegator), borrowAmount);
        assertEq(fraxDelegator.repayBorrow(borrowAmount), 0);
        assertEq(fraxDelegator.totalBorrows(), _fraxTotalBorrows);
        assertEq(fraxToken.balanceOf(borrower), 0);
    }

    function testMintBorrowRepayOnBehalf() public {
        testMintEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;
        uint256 _fraxTotalBorrows = fraxDelegator.totalBorrows();
        uint256 balance = fraxDelegator.balanceOf(address(this));

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(
            fraxDelegator.totalBorrows(),
            (_fraxTotalBorrows + borrowAmount)
        );
        assertEq(fraxToken.balanceOf(borrower), borrowAmount);

        address payer = vm.addr(1);

        vm.startPrank(payer);
        deal(address(fraxToken), payer, mintAmount);
        fraxToken.approve(address(fraxDelegator), borrowAmount);
        assertEq(
            fraxDelegator.repayBorrowBehalf(address(this), borrowAmount),
            0
        );
        vm.stopPrank();

        assertEq(fraxDelegator.totalBorrows(), _fraxTotalBorrows);
        assertEq(fraxDelegator.balanceOf(address(this)), balance);
    }

    function testMintBorrowRepayMorethanBorrowed() public {
        testMintEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;
        uint256 _fraxTotalBorrows = fraxDelegator.totalBorrows();

        assertEq(fraxDelegator.borrow(borrowAmount), 0);
        assertEq(
            fraxDelegator.totalBorrows(),
            (_fraxTotalBorrows + borrowAmount)
        );
        assertEq(fraxToken.balanceOf(borrower), borrowAmount);

        address payer = vm.addr(1);

        vm.startPrank(payer);
        deal(address(fraxToken), payer, mintAmount);
        fraxToken.approve(address(fraxDelegator), borrowAmount + 1_000e6);
        vm.expectRevert(
            "REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED"
        );
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

        (, uint256 redeemed) = mulScalarTruncate(
            Exp({mantissa: fraxDelegator.exchangeRateStored()}),
            balance
        );
        assertEq(fraxToken.balanceOf(address(this)), redeemed);
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

        deal(address(fraxToken), supplier, mintAmount);
        fraxToken.approve(address(fraxDelegator), mintAmount);

        assertEq(fraxDelegator.mint(mintAmount), 0);

        IWell well = IWell(addresses.getAddress("WELL"));
        assertEq(well.balanceOf(supplier), 0);

        vm.warp(block.timestamp + 10);

        comptroller.claimReward(0, payable(supplier));
        assertTrue(well.balanceOf(supplier) > 0);
    }

    function testMintClaimInvalidRewardType() public {
        testMintEnterMarket();
        testLiquidityShortfall();
        testUnpauseMarket();

        address claimant = address(this);
        uint256 mintAmount = 10e18;

        deal(address(fraxToken), claimant, mintAmount);
        fraxToken.approve(address(fraxDelegator), mintAmount);

        assertEq(fraxDelegator.mint(mintAmount), 0);

        vm.roll(block.number + 100);
        vm.expectRevert("rewardType is invalid");
        comptroller.claimReward(2, payable(claimant));
    }

    /// TODO
    function testLiquidateBorrow() public {}
}
