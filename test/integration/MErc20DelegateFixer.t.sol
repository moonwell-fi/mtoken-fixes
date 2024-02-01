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
    IMErc20Delegator mTokenDelegatorFRAX;
    IERC20 token;
    IMErc20DelegateFixer mTokenDelegate;
    IComptroller comptroller;

    /// @dev state vars
    uint256 cash;
    uint256 totalBorrows;
    uint256 totalReserves;
    uint256 exchangeRate;
    uint256 badDebt;

    function setUp() public {
        createCode = new CreateCode();

        /// @dev load the bytecode for MErc20DelegateFixer.sol
        bytes memory delegateCode = createCode.getCode("MErc20DelegateFixer.sol");
        delegateAddress = createCode.deployCode(delegateCode);

        addresses = new Addresses("./addresses/addresses.json");

        mTokenDelegatorFRAX = IMErc20Delegator(payable(addresses.getAddress("MOONWELL_mFRAX")));

        token = IERC20(addresses.getAddress("FRAX"));

        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        mTokenDelegatorFRAX._setImplementation(delegateAddress, false, new bytes(0));
        vm.stopPrank();

        address implementation = mTokenDelegatorFRAX.implementation();
        mTokenDelegate = IMErc20DelegateFixer(implementation);

        comptroller = IComptroller(addresses.getAddress("UNITROLLER"));
    }

    function _accrueInterest() public {
        /// @dev ensure that accrue interest call does not error
        assertEq(mTokenDelegatorFRAX.accrueInterest(), 0);
    }

    function _cashBefore(IMErc20Delegator delgator) private {
        cash = delgator.getCash();
        assertEq(delgator.getCash(), 63400462712177883);
    }

    function _cashAfter(IMErc20Delegator delgator) private {
        badDebt = delgator.badDebt();
        assertEq(delgator.getCash(), (cash + badDebt));
    }

    function _totalBorrowsBefore(IMErc20Delegator delgator) private {
        totalBorrows = delgator.totalBorrows();
        assertEq(totalBorrows, 3237572375993380205681540);
    }

    function _totalReservesBefore(IMErc20Delegator delgator) private {
        totalReserves = delgator.totalReserves();
        assertEq(totalReserves, 192011920067024496033280);
    }

    function _exchangeRateBefore(IMErc20Delegator delgator) private {
        exchangeRate = delgator.exchangeRateStored();
        assertEq(exchangeRate, 229215186366119215900652004);
    }

    function _exchangeRateAfter(IMErc20Delegator delgator) private {
        /// @dev the exchange rate differs because accrueInterest() adjusts the borrow and reserves values
        assertTrue(delgator.exchangeRateStored() > exchangeRate);
    }

    function _mintAndDeal(address sender, uint256 mintAmount) public {
        uint256 startingTokenBalance = token.balanceOf(address(mTokenDelegatorFRAX));

        deal(address(token), sender, mintAmount);

        vm.startPrank(sender);
        token.approve(address(mTokenDelegatorFRAX), mintAmount);
        assertEq(mTokenDelegatorFRAX.mint(mintAmount), 0);
        vm.stopPrank();

        assertTrue(mTokenDelegatorFRAX.balanceOf(sender) > 0);
        assertEq(token.balanceOf(address(mTokenDelegatorFRAX)) - startingTokenBalance, mintAmount);
    }

    function _mintAndDeal(IERC20 _token, address sender, uint256 mintAmount) public {
        uint256 startingTokenBalance = _token.balanceOf(address(mTokenDelegatorFRAX));

        deal(address(_token), sender, mintAmount);

        vm.startPrank(sender);
        _token.approve(address(mTokenDelegatorFRAX), mintAmount);
        assertEq(mTokenDelegatorFRAX.mint(mintAmount), 0);
        vm.stopPrank();

        assertTrue(mTokenDelegatorFRAX.balanceOf(sender) > 0);
        assertEq(token.balanceOf(address(mTokenDelegatorFRAX)) - startingTokenBalance, mintAmount);
    }

    function _enterMarkets(address sender) private {
        address[] memory mTokens = new address[](1);
        mTokens[0] = address(mTokenDelegatorFRAX);

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
        _cashBefore(mTokenDelegatorFRAX);
        _totalBorrowsBefore(mTokenDelegatorFRAX);
        _totalReservesBefore(mTokenDelegatorFRAX);
        _exchangeRateBefore(mTokenDelegatorFRAX);

        _accrueInterest();

        assertEq(mTokenDelegatorFRAX.badDebt(), 0);
        assertEq(mTokenDelegatorFRAX.getAccountTokens(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 0);

        mTokenDelegatorFRAX.fixUser(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), _user);

        _cashAfter(mTokenDelegatorFRAX);
    }

    function testFixUserWithBadDebt() public {
        assertEq(mTokenDelegatorFRAX.getAccountTokens(user), 2264582);
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        assertTrue(mTokenDelegatorFRAX.totalBorrows() < totalBorrows);
        assertTrue(mTokenDelegatorFRAX.totalReserves() > totalReserves);

        assertEq(mTokenDelegatorFRAX.totalSupply(), 13286905495267783);
        assertEq(mTokenDelegatorFRAX.badDebt(), 357392405781480063721876);
        assertEq(mTokenDelegatorFRAX.getAccountTokens(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 2264582);
        assertEq(mTokenDelegatorFRAX.getAccountTokens(user), 0);

        _exchangeRateAfter(mTokenDelegatorFRAX);
    }

    function testFixUserWithoutBadDebt() public {
        address _user = vm.addr(1);

        assertEq(mTokenDelegatorFRAX.getAccountTokens(_user), 0);
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(_user);
        vm.stopPrank();

        assertTrue(mTokenDelegatorFRAX.totalBorrows() > totalBorrows);
        assertTrue(mTokenDelegatorFRAX.totalReserves() > totalReserves);

        assertEq(mTokenDelegatorFRAX.totalSupply(), 13286905495267783);
        assertEq(mTokenDelegatorFRAX.badDebt(), 0);
        assertEq(mTokenDelegatorFRAX.getAccountTokens(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 0);
        assertEq(mTokenDelegatorFRAX.getAccountTokens(_user), 0);

        _exchangeRateAfter(mTokenDelegatorFRAX);
    }

    function testFixUserNotAdmin() public {
        address liquidator = addresses.getAddress("NOMAD_REALLOCATION_MULTISIG");

        vm.startPrank(vm.addr(1));
        vm.expectRevert("only the admin may call fixUser");
        mTokenDelegatorFRAX.fixUser(liquidator, user);
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
        assertEq(mTokenDelegatorFRAX.accrualBlockTimestamp(), block.timestamp);
    }

    function _accrueInterestBorrowsReserves() private {
        uint256 _totalBorrows = mTokenDelegatorFRAX.totalBorrows();
        uint256 _totalReserves = mTokenDelegatorFRAX.totalReserves();
        _accrueInterest();

        assertTrue(mTokenDelegatorFRAX.totalBorrows() >= _totalBorrows);
        assertTrue(mTokenDelegatorFRAX.totalReserves() >= _totalReserves);
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

        uint256 startingTokenBalance = token.balanceOf(address(mTokenDelegatorFRAX));

        deal(address(token), minter, mintAmount);
        token.approve(address(mTokenDelegatorFRAX), mintAmount);

        assertEq(mTokenDelegatorFRAX.mint(mintAmount), 0);
        assertTrue(mTokenDelegatorFRAX.balanceOf(minter) > 0);
        assertEq(token.balanceOf(address(mTokenDelegatorFRAX)) - startingTokenBalance, mintAmount);
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
        token.approve(address(mTokenDelegatorFRAX), mintAmount);

        vm.expectRevert("ERC20: transfer amount exceeds balance");
        mTokenDelegatorFRAX.mint(mintAmount);
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

        comptroller.exitMarket(address(mTokenDelegatorFRAX));
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
        assertEq(comptroller.exitMarket(address(mTokenDelegatorFRAX)), 0);
    }

    function testFixUserExitMarketNotEntered() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        assertEq(comptroller.exitMarket(address(mTokenDelegatorFRAX)), 0);
    }

    function _exitMarketWithActiveBorrow() private {
        address borrower = address(this);
        uint256 borrowAmount = 50e6;

        _enterMarket();

        _liquidityShortfall(borrower);

        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        assertEq(mTokenDelegatorFRAX.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        /// @dev the system does not allow us to exit the market, and returns the error Error.NONZERO_BORROW_BALANCE
        assertEq(comptroller.exitMarket(address(mTokenDelegatorFRAX)), 12);
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

        assertEq(mTokenDelegatorFRAX.borrow(borrowAmount), 0);
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
        mTokenDelegatorFRAX.borrow(borrowAmount);
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

        /// @dev unpause market
        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        /// @dev the system does not allow us to borrow, and returns the error Error.INSUFFICIENT_LIQUIDITY
        assertEq(mTokenDelegatorFRAX.borrow(borrowAmount), 3);
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
        uint256 _totalBorrows = mTokenDelegatorFRAX.totalBorrows();
        uint256 borrowAmount = borrowCap - _totalBorrows - 1;

        assertEq(mTokenDelegatorFRAX.borrow(borrowAmount), 0);
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

    function _borrowCapExceeded() private {
        address borrower = address(this);
        uint256 mintAmount = 100_000_000e18;

        _mintAndDeal(borrower, mintAmount);
        _enterMarkets(borrower);

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(borrower);

        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        console.log(comptroller.borrowCaps(addresses.getAddress("MOONWELL_mFRAX")));

        uint256 borrowCap = comptroller.borrowCaps(addresses.getAddress("MOONWELL_mFRAX"));
        uint256 _totalBorrows = mTokenDelegatorFRAX.totalBorrows();
        uint256 borrowAmount = borrowCap - _totalBorrows;

        vm.expectRevert("market borrow cap reached");
        assertEq(mTokenDelegatorFRAX.borrow(borrowAmount), 0);
    }

    function testBorrowCapExceeded() public {
        _borrowCapExceeded();
    }

    function testFixUserBorrowCapExceeded() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(user);
        vm.stopPrank();

        _borrowCapExceeded();
    }

    function _repay() private {
        address borrower = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;

        _mintAndDeal(borrower, mintAmount);
        _enterMarkets(borrower);

        assertTrue(comptroller.checkMembership(borrower, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(borrower);

        /// @dev unpause market
        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        assertEq(mTokenDelegatorFRAX.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        token.approve(address(mTokenDelegatorFRAX), borrowAmount);
        assertEq(mTokenDelegatorFRAX.repayBorrow(borrowAmount), 0);
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

        /// @dev unpause market
        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        assertEq(mTokenDelegatorFRAX.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        address payer = address(1);

        vm.startPrank(payer);
        deal(address(token), payer, mintAmount);
        token.approve(address(mTokenDelegatorFRAX), borrowAmount);
        assertEq(mTokenDelegatorFRAX.repayBorrowBehalf(address(this), borrowAmount), 0);
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

        /// @dev unpause market
        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        assertEq(mTokenDelegatorFRAX.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(borrower), borrowAmount);

        address payer = vm.addr(1);

        vm.startPrank(payer);
        deal(address(token), payer, mintAmount);
        token.approve(address(mTokenDelegatorFRAX), borrowAmount + 1_000e6);
        vm.expectRevert("REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED");
        mTokenDelegatorFRAX.repayBorrowBehalf(address(this), borrowAmount + 1_000e6);
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

        uint256 balance = mTokenDelegatorFRAX.balanceOf(redeemer);
        assertEq(mTokenDelegatorFRAX.redeem(balance), 0);
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

        assertEq(mTokenDelegatorFRAX.redeem(0), 0);
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

        uint256 balance = mTokenDelegatorFRAX.balanceOf(redeemer);
        assertEq(mTokenDelegatorFRAX.redeem(balance + 1_000e6), 9);
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
        token.approve(address(mTokenDelegatorFRAX), mintAmount);

        assertEq(mTokenDelegatorFRAX.mint(mintAmount), 0);

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

        /// @dev unpause market
        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        deal(address(token), claimant, mintAmount);
        token.approve(address(mTokenDelegatorFRAX), mintAmount);

        assertEq(mTokenDelegatorFRAX.mint(mintAmount), 0);

        vm.roll(block.number + 100);
        vm.expectRevert("rewardType is invalid");
        comptroller.claimReward(99, payable(claimant));
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
