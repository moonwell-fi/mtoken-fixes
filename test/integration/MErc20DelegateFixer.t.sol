pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {IWell} from "@protocol/Interfaces/IWell.sol";
import {IMToken} from "@protocol/Interfaces/IMToken.sol";
import {IMGlimmer} from "@protocol/Interfaces/IMGlimmer.sol";
import {IComptroller} from "@protocol/Interfaces/IComptroller.sol";
import {CreateCode} from "@protocol/proposals/utils/CreateCode.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";
import {IMErc20DelegateFixer} from "@protocol/Interfaces/IMErc20DelegateFixer.sol";

import {Addresses} from "@forge-proposal-simulator/addresses/Addresses.sol";
import {IERC20} from "@forge-proposal-simulator/lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract MErc20DelegateFixerIntegrationTest is Test {
    CreateCode createCode;

    /// @dev addresses
    address delegateAddress;
    address user = 0xcCb8E090Fe070945cC0131a075B6e1EA8F208812;

    /// @dev contracts
    Addresses addresses;
    IMToken mToken;
    IMErc20Delegator delegator;
    IERC20 token;
    IMErc20DelegateFixer mTokenDelegate;
    IComptroller comptroller;

    function setUp() public {
        createCode = new CreateCode();

        bytes memory delegateCode = createCode.getCode("MErc20DelegateFixer.sol");
        delegateAddress = createCode.deployCode(delegateCode);

        addresses = new Addresses("./addresses/addresses.json");

        delegator = IMErc20Delegator(payable(addresses.getAddress("MOONWELL_mFRAX")));

        token = IERC20(addresses.getAddress("FRAX"));

        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        delegator._setImplementation(delegateAddress, false, new bytes(0));
        vm.stopPrank();

        address implementation = delegator.implementation();
        mTokenDelegate = IMErc20DelegateFixer(implementation);

        comptroller = IComptroller(addresses.getAddress("UNITROLLER"));
    }

    function _accrueInterest() public {
        assertEq(delegator.accrueInterest(), 0);
    }

    function _mintAndDeal(address sender, uint256 mintAmount) private {
        uint256 startingTokenBalance = token.balanceOf(address(delegator));

        deal(address(token), sender, mintAmount);

        vm.startPrank(sender);
        token.approve(address(delegator), mintAmount);
        assertEq(delegator.mint(mintAmount), 0);
        vm.stopPrank();

        assertTrue(delegator.balanceOf(sender) > 0);
        assertEq(token.balanceOf(address(delegator)) - startingTokenBalance, mintAmount);
    }

    function _enterMarkets(address sender) private {
        address[] memory mTokens = new address[](1);
        mTokens[0] = address(delegator);

        vm.startPrank(sender);
        comptroller.enterMarkets(mTokens);
        vm.stopPrank();
    }

    function _liquidityShortfall(address account) private {
        (uint256 err,, uint256 shortfall) = comptroller.getAccountLiquidity(account);

        assertEq(err, 0);
        assertEq(shortfall, 0);
    }

    function _unpauseMarket(IMToken mtoken) private {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        comptroller._setBorrowPaused(mtoken, false);
        vm.stopPrank();
    }

    function _fixUser(address _user) private {
        uint256 cash = delegator.getCash();

        _accrueInterest();

        assertEq(delegator.badDebt(), 0);
        assertEq(delegator.getAccountTokens(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 0);

        delegator.fixUser(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), _user);

        assertEq(delegator.getCash(), (cash + delegator.badDebt()));
    }

    function testFixUserWithBadDebt() public {
        uint256 cash = delegator.getCash();
        uint256 totalBorrows = delegator.totalBorrows();
        uint256 totalReserves = delegator.totalReserves();

        assertEq(delegator.getAccountTokens(user), 2264582);
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        assertEq(delegator.getCash(), (cash + delegator.badDebt()));
        assertTrue(delegator.totalBorrows() < totalBorrows);
        assertTrue(delegator.totalReserves() > totalReserves);
        assertEq(delegator.totalSupply(), 13286905495267783);
        assertEq(delegator.badDebt(), 357392405781480063721876);

        assertEq(delegator.getAccountTokens(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 2264582);
        assertEq(delegator.getAccountTokens(user), 0);
    }

    function testFixUserWithoutBadDebt() public {
        address _user = vm.addr(1);
        uint256 cash = delegator.getCash();
        uint256 totalBorrows = delegator.totalBorrows();
        uint256 totalReserves = delegator.totalReserves();

        assertEq(delegator.getAccountTokens(_user), 0);
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(_user);
        vm.stopPrank();

        assertEq(delegator.getCash(), (cash + delegator.badDebt()));
        assertTrue(delegator.totalBorrows() > totalBorrows);
        assertTrue(delegator.totalReserves() > totalReserves);
        assertEq(delegator.totalSupply(), 13286905495267783);
        assertEq(delegator.badDebt(), 0);

        assertEq(delegator.getAccountTokens(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 0);
        assertEq(delegator.getAccountTokens(_user), 0);
    }

    function testFixUserNotAdmin() public {
        address liquidator = addresses.getAddress("NOMAD_REALLOCATION_MULTISIG");

        vm.startPrank(vm.addr(1));
        vm.expectRevert("only the admin may call fixUser");
        delegator.fixUser(liquidator, user);
        vm.stopPrank();
    }

    function testMarketPaused() public {
        assertTrue(comptroller.borrowGuardianPaused(addresses.getAddress("MOONWELL_mFRAX")));
    }

    function testAccrueInterest() public {
        _accrueInterest();
    }

    function testAccrueInterestBlockTimestamp() public {
        _accrueInterest();
        assertEq(delegator.accrualBlockTimestamp(), block.timestamp);
    }

    function _accrueInterestBorrowsReserves() private {
        uint256 _totalBorrows = delegator.totalBorrows();
        uint256 _totalReserves = delegator.totalReserves();

        _accrueInterest();
        assertTrue(delegator.totalBorrows() >= _totalBorrows);
        assertTrue(delegator.totalReserves() >= _totalReserves);
    }

    function testAccrueInterestBorrowsReserves() public {
        _accrueInterestBorrowsReserves();
    }

    function testFixUserAccrueInterestBorrowsReserves() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _accrueInterestBorrowsReserves();
    }

    function _mint() private {
        address minter = address(this);
        uint256 mintAmount = 10e8;

        uint256 startingTokenBalance = token.balanceOf(address(delegator));

        deal(address(token), minter, mintAmount);
        token.approve(address(delegator), mintAmount);

        assertEq(delegator.mint(mintAmount), 0);
        assertTrue(delegator.balanceOf(minter) > 0);
        assertEq(token.balanceOf(address(delegator)) - startingTokenBalance, mintAmount);
    }

    function testMint() public {
        _mint();
    }

    function testFixUsertMint() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _mint();
    }

    function _mintMoreThanUserBalance() private {
        address minter = address(this);
        uint256 dealAmount = 10e8;
        uint256 mintAmount = 100e8;

        deal(address(token), minter, dealAmount);
        token.approve(address(delegator), mintAmount);

        vm.expectRevert("ERC20: transfer amount exceeds balance");
        delegator.mint(mintAmount);
    }

    function testMintMoreThanUserHolds() public {
        _mintMoreThanUserBalance();
    }

    function testFixUserMintMoreThanUserHolds() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _mintMoreThanUserBalance();
    }

    function _enterMarket() private {
        address borrower = address(this);
        uint256 mintAmount = 10e18;
        _mintAndDeal(borrower, mintAmount);
        _enterMarkets(borrower);

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));
    }

    function testEnterMarket() public {
        _enterMarket();
    }

    function testFixUserEnterMarket() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _enterMarket();
    }

    function _exitMarket() private {
        address borrower = address(this);

        comptroller.exitMarket(address(delegator));
        assertFalse(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));
    }

    function testExitMarket() public {
        _enterMarket();
        _exitMarket();
    }

    function testFixUserExitMarket() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _enterMarket();
        _exitMarket();
    }

    function testExitMarketNotEntered() public {
        assertEq(comptroller.exitMarket(address(delegator)), 0);
    }

    function testFixUserExitMarketNotEntered() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        assertEq(comptroller.exitMarket(address(delegator)), 0);
    }

    function _exitMarketWithActiveBorrow() private {
        address borrower = address(this);
        uint256 borrowAmount = 50e6;

        _enterMarket();

        _liquidityShortfall(borrower);

        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        assertEq(delegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        /// @dev Error.NONZERO_BORROW_BALANCE
        assertEq(comptroller.exitMarket(address(delegator)), 12);
    }

    function testExitMarketWithActiveBorrow() public {
       _exitMarketWithActiveBorrow();
    }

    function tesFixUsertExitMarketWithActiveBorrow() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _exitMarketWithActiveBorrow();
    }

    function _noLiquidityShortfall() private {
        address borrower = address(this);
        uint256 mintAmount = 10e18;

        _mintAndDeal(borrower, mintAmount);
        _enterMarkets(borrower);

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(borrower);
    }

    function testNoLiquidityShortfall() public {
        _noLiquidityShortfall();
    }

    function testFixUserNoLiquidityShortfall() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _noLiquidityShortfall();
    }

    function _supplyRewardSpeeds() private {
        assertEq(comptroller.supplyRewardSpeeds(0, addresses.getAddress("MOONWELL_mFRAX")), 457875428571428571);
        assertEq(comptroller.supplyRewardSpeeds(1, addresses.getAddress("MOONWELL_mFRAX")), 6952629629629629);
    }

    function testSupplyRewardSpeeds() public {
        _supplyRewardSpeeds();
    }

    function testFixUserSupplyRewardSpeeds() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _supplyRewardSpeeds();
    }

    function _borrow() private {
        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;

        _mintAndDeal(borrower, mintAmount);
        _enterMarkets(borrower);

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(borrower);

        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        assertEq(delegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        assertEq(comptroller.borrowRewardSpeeds(0, addresses.getAddress("MOONWELL_mFRAX")), 1);
        assertEq(comptroller.borrowRewardSpeeds(1, addresses.getAddress("MOONWELL_mFRAX")), 1);
    }

    function testBorrow() public {
        _borrow();
    }

    function testFixUserBorrow() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _borrow();
    }

    function _borrowPaused() private {
        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 11e18;

        _mintAndDeal(borrower, mintAmount);
        _enterMarkets(borrower);

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        vm.expectRevert("borrow is paused");
        delegator.borrow(borrowAmount);
    }

    function testBorrowPaused() public {
        _borrowPaused();
    }

    function testFixUserBorrowPaused() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _borrowPaused();
    }

    function _borrowLiquidityShortfall() private {
        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 11e18;

        _mintAndDeal(borrower, mintAmount);
        _enterMarkets(borrower);

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        /// @dev Error.INSUFFICIENT_LIQUIDITY
        assertEq(delegator.borrow(borrowAmount), 3);
        assertEq(token.balanceOf(borrower), 0);

        assertEq(comptroller.borrowRewardSpeeds(0, addresses.getAddress("MOONWELL_mFRAX")), 1);
        assertEq(comptroller.borrowRewardSpeeds(1, addresses.getAddress("MOONWELL_mFRAX")), 1);
    }

    function testBorrowLiquidityShortfall() public {
        _borrowLiquidityShortfall();
    }

    function testFixUserBorrowLiquidityShortfall() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _borrowLiquidityShortfall();
    }

    function _borrowMaxAmount() private {
        address borrower = address(this);
        uint256 mintAmount = 100_000_000e18;

        _mintAndDeal(borrower, mintAmount);
        _enterMarkets(borrower);

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(borrower);

        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        console.log(comptroller.borrowCaps(addresses.getAddress("MOONWELL_mFRAX")));

        uint256 borrowCap = comptroller.borrowCaps(addresses.getAddress("MOONWELL_mFRAX"));
        uint256 _totalBorrows = delegator.totalBorrows();
        uint256 borrowAmount = borrowCap - _totalBorrows - 1;

        assertEq(delegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);
    }

    function testBorrowMaxAmount() public {
        _borrowMaxAmount();
    }

    function testFixUserBorrowMaxAmount() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _borrowMaxAmount();
    }

    function _borrowCapReached() private {
        address borrower = address(this);
        uint256 mintAmount = 100_000_000e18;

        _mintAndDeal(borrower, mintAmount);
        _enterMarkets(borrower);

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(borrower);

        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        console.log(comptroller.borrowCaps(addresses.getAddress("MOONWELL_mFRAX")));

        uint256 borrowCap = comptroller.borrowCaps(addresses.getAddress("MOONWELL_mFRAX"));
        uint256 _totalBorrows = delegator.totalBorrows();
        uint256 borrowAmount = borrowCap - _totalBorrows;

        vm.expectRevert("market borrow cap reached");
        assertEq(delegator.borrow(borrowAmount), 0);
    }

    function testBorrowCapReached() public {
        _borrowCapReached();
    }

    function testFixUserBorrowCapReached() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _borrowCapReached();
    }

    function _repay() private {
        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;

        _mintAndDeal(borrower, mintAmount);
        _enterMarkets(borrower);

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(borrower);

        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        assertEq(delegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        token.approve(address(delegator), borrowAmount);
        assertEq(delegator.repayBorrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), 0);
    }

    function testRepay() public {
        _repay();
    }

    function testFixUserRepay() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _repay();
    }

    function _repayOnBehalf() private {
        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;

        _mintAndDeal(borrower, mintAmount);
        _enterMarkets(borrower);

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(borrower);

        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        assertEq(delegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        address payer = vm.addr(1);

        vm.startPrank(payer);
        deal(address(token), payer, mintAmount);
        token.approve(address(delegator), borrowAmount);
        assertEq(delegator.repayBorrowBehalf(address(this), borrowAmount), 0);
        vm.stopPrank();
    }

    function testRepayOnBehalf() public {
        _repayOnBehalf();
    }

    function testFixUserRepayOnBehalf() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _repayOnBehalf();
    }

    function _repayMorethanBorrowed() private {
        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;

        _mintAndDeal(borrower, mintAmount);
        _enterMarkets(borrower);

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(borrower);

        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

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

    function testRepayMoreThanBorrowed() public {
        _repayMorethanBorrowed();
    }

    function testFixUserRepayMoreThanBorrowed() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _repayMorethanBorrowed();
    }

    function _redeem() private {
        address redeemer = address(this);
        uint256 mintAmount = 10e18;

        _mintAndDeal(redeemer, mintAmount);

        uint256 balance = delegator.balanceOf(redeemer);
        assertEq(delegator.redeem(balance), 0);
    }

    function testRedeem() public {
        _redeem();
    }

    function testFixUserRedeem() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _redeem();
    }

    function _redeemZeroTokens() private {
        address redeemer = address(this);
        uint256 mintAmount = 10e18;

        _mintAndDeal(redeemer, mintAmount);

        assertEq(delegator.redeem(0), 0);
    }

    function testRedeemZeroTokens() public {
        _redeemZeroTokens();
    }

    function testFixUserRedeemZeroTokens() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _redeemZeroTokens();
    }

    function _redeemMoreTokens() private {
        address redeemer = address(this);
        uint256 mintAmount = 10e18;

        _mintAndDeal(redeemer, mintAmount);

        uint256 balance = delegator.balanceOf(redeemer);
        assertEq(delegator.redeem(balance + 1_000e6), 9);
    }

    function testRedeemMoreTokens() public {
        _redeemMoreTokens();
    }

    function testFixUserRedeemMoreTokens() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _redeemMoreTokens();
    }

    function _claimRewardsSupplier() private {
        address supplier = address(this);
        uint256 mintAmount = 10e18;

        _mintAndDeal(supplier, mintAmount);
        _enterMarkets(supplier);

        assertTrue(comptroller.checkMembership(supplier, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(supplier);

        /// @dev unpause market
        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        deal(address(token), supplier, mintAmount);
        token.approve(address(delegator), mintAmount);

        assertEq(delegator.mint(mintAmount), 0);

        IWell well = IWell(addresses.getAddress("WELL"));
        assertEq(well.balanceOf(supplier), 0);

        vm.warp(block.timestamp + 10);
        comptroller.claimReward(0, payable(supplier));
        assertTrue(well.balanceOf(supplier) > 0);
    }

    function testClaimRewardsSupplier() public {
        _claimRewardsSupplier();
    }

    function testFixUserClaimRewardsSupplier() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _claimRewardsSupplier();
    }

    /// TODO
    function _claimRewardsBorrower() private {}

    function testClaimRewardsBorrower() public {
        _claimRewardsBorrower();
    }

    function testFixUserClaimRewardsBorrower() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _claimRewardsBorrower();
    }

    function _claimInvalidRewardType() private {
        address claimant = address(this);
        uint256 mintAmount = 10e18;

        _mintAndDeal(claimant, mintAmount);
        _enterMarkets(claimant);

        assertTrue(comptroller.checkMembership(claimant, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(claimant);

        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        deal(address(token), claimant, mintAmount);
        token.approve(address(delegator), mintAmount);

        assertEq(delegator.mint(mintAmount), 0);

        vm.roll(block.number + 100);
        vm.expectRevert("rewardType is invalid");
        comptroller.claimReward(2, payable(claimant));
    }

    function testClaimInvalidRewardType() public {
        _claimInvalidRewardType();
    }

    function testFixUserClaimInvalidRewardType() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _claimInvalidRewardType();
    }

    /// TODO
    function _liquidateBorrow() private {}

    function testLiquidateBorrow() public {
        _liquidateBorrow();
    }

    function testFixUserLiquidateBorrow() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _liquidateBorrow();
    }
}
