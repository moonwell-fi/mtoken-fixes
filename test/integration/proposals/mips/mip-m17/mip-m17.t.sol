pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {IERC20} from "@forge-proposal-simulator/lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import {PostProposalCheck} from "@tests/integration/PostProposalCheck.t.sol";

import {IWell} from "@protocol/Interfaces/IWell.sol";
import {IMToken} from "@protocol/Interfaces/IMToken.sol";
import {IComptroller} from "@protocol/Interfaces/IComptroller.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";
import {IMErc20DelegateFixer} from "@protocol/Interfaces/IMErc20DelegateFixer.sol";

contract MIPM17IntegrationTest is PostProposalCheck {
    /// @dev contracts
    IMErc20Delegator delegator;
    IERC20 token;
    IComptroller comptroller;

    function setUp() override public {
        super.setUp();

        delegator = IMErc20Delegator(payable(addresses.getAddress("MOONWELL_mFRAX")));

        token = IERC20(addresses.getAddress("FRAX"));

        comptroller = IComptroller(addresses.getAddress("UNITROLLER"));
    }

    function testMarketPaused() public {
        assertTrue(comptroller.borrowGuardianPaused(addresses.getAddress("MOONWELL_mFRAX")));
    }

    function testAccrueInterest() public {
        assertEq(delegator.accrueInterest(), 0);
    }

    function testAccrueInterestBlockTimestamp() public {
        assertEq(delegator.accrueInterest(), 0);
        assertEq(delegator.accrualBlockTimestamp(), block.timestamp);
    }

    function testAccrueInterestBorrowsReserves() public {
        uint256 _totalBorrows = delegator.totalBorrows();
        uint256 _totalReserves = delegator.totalReserves();

        assertEq(delegator.accrueInterest(), 0);
        assertTrue(delegator.totalBorrows() >= _totalBorrows);
        assertTrue(delegator.totalReserves() >= _totalReserves);
    }

    function testMint() public {
        address minter = address(this);
        uint256 mintAmount = 10e8;

        uint256 startingTokenBalance = token.balanceOf(address(delegator));

        deal(address(token), minter, mintAmount);
        token.approve(address(delegator), mintAmount);

        assertEq(delegator.mint(mintAmount), 0);
        assertTrue(delegator.balanceOf(minter) > 0);
        assertEq(token.balanceOf(address(delegator)) - startingTokenBalance, mintAmount);
    }

    function testMintMoreThanUserBalance() public {
        address minter = address(this);
        uint256 dealAmount = 10e8;
        uint256 mintAmount = 100e8;

        deal(address(token), minter, dealAmount);
        token.approve(address(delegator), mintAmount);

        vm.expectRevert("ERC20: transfer amount exceeds balance");
        delegator.mint(mintAmount);
    }

    function testliquidityShortfall() public {
        (uint256 err,, uint256 shortfall) = comptroller.getAccountLiquidity(address(this));

        assertEq(err, 0);
        assertEq(shortfall, 0);
    }

    function testUnpauseMarket() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        comptroller._setBorrowPaused(IMToken(address(delegator)), false);
        vm.stopPrank();
    }

    function testEnterMarket() public {
        testMint();

        address[] memory mTokens = new address[](1);
        mTokens[0] = address(delegator);

        vm.startPrank(address(this));
        comptroller.enterMarkets(mTokens);
        vm.stopPrank();

        assertTrue(comptroller.checkMembership(address(this), IMToken(addresses.getAddress("MOONWELL_mFRAX"))));
    }

    function testExitMarket() public {
        testEnterMarket();

        comptroller.exitMarket(address(delegator));
        assertFalse(comptroller.checkMembership(address(this), IMToken(addresses.getAddress("MOONWELL_mFRAX"))));
    }

    function testExitMarketNotEntered() public {
        assertEq(comptroller.exitMarket(address(delegator)), 0);
    }

    function testExitMarketWithActiveBorrow() public {
        address borrower = address(this);
        uint256 borrowAmount = 50e6;

        testEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        assertEq(delegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        /// @dev Error.NONZERO_BORROW_BALANCE
        assertEq(comptroller.exitMarket(address(delegator)), 12);
    }

    function testNoLiquidityShortfall() public {
        testMint();
        testEnterMarket();
        testliquidityShortfall();
    }

    function testSupplyRewardSpeeds() public {
        assertEq(comptroller.supplyRewardSpeeds(0, address(delegator)), 457875428571428571);
        assertEq(comptroller.supplyRewardSpeeds(1, address(delegator)), 6952629629629629);
    }

    function testBorrowRewardSpeeds() public {
        assertEq(comptroller.borrowRewardSpeeds(0, address(delegator)), 1);
        assertEq(comptroller.borrowRewardSpeeds(1, address(delegator)), 1);
    }

    function testBorrow() public {
        address borrower = address(this);
        uint256 borrowAmount = 50e6;

        testMint();
        testEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        assertEq(delegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        testBorrowRewardSpeeds();
    }

    function testBorrowPaused() public {
        address borrower = address(this);
        uint256 borrowAmount = 50e6;

        testMint();
        testEnterMarket();

        vm.expectRevert("borrow is paused");
        delegator.borrow(borrowAmount);
    }

    function testBorrowLiquidityShortfall() public {
        address borrower = address(this);
        uint256 borrowAmount = 11e18;

        testMint();
        testEnterMarket();
        testUnpauseMarket();

        /// @dev Error.INSUFFICIENT_LIQUIDITY
        assertEq(delegator.borrow(borrowAmount), 3);
        assertEq(token.balanceOf(borrower), 0);

        testBorrowRewardSpeeds();
    }

    function testBorrowMaxAmount() public {
        address borrower = address(this);
        uint256 mintAmount = 100_000_000e18;

        uint256 startingTokenBalance = token.balanceOf(address(delegator));

        deal(address(token), borrower, mintAmount);

        token.approve(address(delegator), mintAmount);
        assertEq(delegator.mint(mintAmount), 0);

        assertTrue(delegator.balanceOf(borrower) > 0);
        assertEq(token.balanceOf(address(delegator)) - startingTokenBalance, mintAmount);

        testEnterMarket();

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        testliquidityShortfall();
        testUnpauseMarket();

        uint256 borrowCap = comptroller.borrowCaps(addresses.getAddress("MOONWELL_mFRAX"));
        uint256 _totalBorrows = delegator.totalBorrows();
        uint256 borrowAmount = borrowCap - _totalBorrows - 1;

        assertEq(delegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);
    }

    function borrowCapReached() public {
        address borrower = address(this);
        uint256 mintAmount = 100_000_000e18;

        uint256 startingTokenBalance = token.balanceOf(address(delegator));

        deal(address(token), borrower, mintAmount);

        token.approve(address(delegator), mintAmount);
        assertEq(delegator.mint(mintAmount), 0);

        assertTrue(delegator.balanceOf(borrower) > 0);
        assertEq(token.balanceOf(address(delegator)) - startingTokenBalance, mintAmount);

        testEnterMarket();

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        testliquidityShortfall();
        testUnpauseMarket();

        uint256 borrowCap = comptroller.borrowCaps(addresses.getAddress("MOONWELL_mFRAX"));
        uint256 _totalBorrows = delegator.totalBorrows();
        uint256 borrowAmount = borrowCap - _totalBorrows;

        vm.expectRevert("market borrow cap reached");
        assertEq(delegator.borrow(borrowAmount), 0);
    }

    function testRepay() public {
        address borrower = address(this);
        uint256 borrowAmount = 50e6;

        testMint();
        testEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        assertEq(delegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        token.approve(address(delegator), borrowAmount);
        assertEq(delegator.repayBorrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), 0);
    }

    function testRepayOnBehalf() public {
        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;

        testMint();
        testEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        assertEq(delegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        address payer = vm.addr(1);

        vm.startPrank(payer);
        deal(address(token), payer, mintAmount);
        token.approve(address(delegator), borrowAmount);
        assertEq(delegator.repayBorrowBehalf(address(this), borrowAmount), 0);
        vm.stopPrank();
    }

    function testRepayMorethanBorrowed() public {
        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;

        testMint();
        testEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        assertEq(delegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        address payer = vm.addr(1);

        vm.startPrank(payer);
        deal(address(token), payer, mintAmount);
        token.approve(address(delegator), borrowAmount + 1_000e6);
        vm.expectRevert("REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED");
        delegator.repayBorrowBehalf(address(this), borrowAmount + 1_000e6);
        vm.stopPrank();
    }

    function testRedeem() private {
        testMint();

        uint256 balance = delegator.balanceOf(address(this));
        assertEq(delegator.redeem(balance), 0);
    }

    function testRedeemZeroTokens() private {
        testMint();
        assertEq(delegator.redeem(0), 0);
    }

     function testRedeemMoreTokens() private {
        testMint();

        uint256 balance = delegator.balanceOf(address(this));
        assertEq(delegator.redeem(balance + 1_000e6), 9);
    }

    function testClaimRewardsSupplier() public {
        address supplier = address(this);
        uint256 mintAmount = 10e18;

        testMint();
        testEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        deal(address(token), supplier, mintAmount);
        token.approve(address(delegator), mintAmount);

        assertEq(delegator.mint(mintAmount), 0);

        IWell well = IWell(addresses.getAddress("WELL"));
        assertEq(well.balanceOf(supplier), 0);

        vm.warp(block.timestamp + 10);
        comptroller.claimReward(0, payable(supplier));
        assertTrue(well.balanceOf(supplier) > 0);
    }

    function testClaimRewardsBorrower() public {}

    function testClaimInvalidRewardType() private {
        address claimant = address(this);
        uint256 mintAmount = 10e18;

        testMint();
        testEnterMarket();
        testliquidityShortfall();
        testUnpauseMarket();

        deal(address(token), claimant, mintAmount);
        token.approve(address(delegator), mintAmount);

        assertEq(delegator.mint(mintAmount), 0);

        vm.roll(block.number + 100);
        vm.expectRevert("rewardType is invalid");
        comptroller.claimReward(2, payable(claimant));
    }

    function testLiquidateBorrow() public {}
}
