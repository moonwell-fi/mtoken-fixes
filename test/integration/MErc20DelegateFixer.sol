pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {IMToken} from "@protocol/Interfaces/IMToken.sol";
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
    IMErc20Delegator mTokenDelegator;
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

        mTokenDelegator = IMErc20Delegator(payable(addresses.getAddress("MOONWELL_mFRAX")));

        token = IERC20(addresses.getAddress("FRAX"));

        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        mTokenDelegator._setImplementation(delegateAddress, false, new bytes(0));
        vm.stopPrank();

        address implementation = mTokenDelegator.implementation();
        mTokenDelegate = IMErc20DelegateFixer(implementation);

        comptroller = IComptroller(addresses.getAddress("UNITROLLER"));
    }

    function _accrueInterest() public {
        /// @dev ensure that accrue interest call does not error
        assertEq(mTokenDelegator.accrueInterest(), 0);
    }

    function _cashBeforeFixUser() private {
        cash = mTokenDelegator.getCash();
        assertEq(cash, 63400462712177883);
    }

    function _cashAfterFixUser() private {
        badDebt = mTokenDelegator.badDebt();
        assertEq(mTokenDelegator.getCash(), (cash + badDebt));
    }

    function _totalBorrowsBeforeFixUser() private {
        totalBorrows = mTokenDelegator.totalBorrows();
        assertEq(totalBorrows, 3237572375993380205681540);
    }

    function _totalReservesBeforeFixUser() private {
        totalReserves = mTokenDelegator.totalReserves();
        assertEq(totalReserves, 192011920067024496033280);
    }

    function _exchangeRateBeforeFixUser() private {
        exchangeRate = mTokenDelegator.exchangeRateStored();
        assertEq(exchangeRate, 229215186366119215900652004);
    }

    function _exchangeRateAfterFixUser() private {
        /// @dev the exchange rate differs because accrueInterest() adjusts the borrow and reserves values
        assertTrue(mTokenDelegator.exchangeRateStored() > exchangeRate);
    }

    function _mintAndDeal(address sender, uint256 mintAmount) public {
        uint256 startingTokenBalance = token.balanceOf(address(mTokenDelegator));

        deal(address(token), sender, mintAmount);
        token.approve(address(mTokenDelegator), mintAmount);

        assertEq(mTokenDelegator.mint(mintAmount), 0);
        assertTrue(mTokenDelegator.balanceOf(sender) > 0);
        assertEq(token.balanceOf(address(mTokenDelegator)) - startingTokenBalance, mintAmount);
    }

    function _mintAndDeal(IERC20 _token, address sender, uint256 mintAmount) public {
        uint256 startingTokenBalance = _token.balanceOf(address(mTokenDelegator));

        deal(address(_token), sender, mintAmount);
        _token.approve(address(mTokenDelegator), mintAmount);

        assertEq(mTokenDelegator.mint(mintAmount), 0);
        assertTrue(mTokenDelegator.balanceOf(sender) > 0);
        assertEq(token.balanceOf(address(mTokenDelegator)) - startingTokenBalance, mintAmount);
    }

    function _enterMarkets() private {
        address[] memory mTokens = new address[](1);
        mTokens[0] = address(mTokenDelegator);

        comptroller.enterMarkets(mTokens);
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

    function _fixUser(address admin) private {
        mTokenDelegator.fixUser(admin, user);
    }

    function testFixUser() public {
        _cashBeforeFixUser();
        _totalBorrowsBeforeFixUser();
        _totalReservesBeforeFixUser();
        _exchangeRateBeforeFixUser();

        assertEq(mTokenDelegator.totalSupply(), 13286905495267783);

        _accrueInterest();

        assertEq(mTokenDelegator.badDebt(), 0);
        assertEq(mTokenDelegator.getAccountTokens(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 0);
        assertEq(mTokenDelegator.getAccountTokens(user), 2264582);

        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));
        _fixUser(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"));
        vm.stopPrank();

        _cashAfterFixUser();

        /// @dev these should hold true because accrue interest adjusts these values
        assertTrue(mTokenDelegator.totalBorrows() < totalBorrows);
        assertTrue(mTokenDelegator.totalReserves() > totalReserves);

        assertEq(mTokenDelegator.totalSupply(), 13286905495267783);
        assertEq(mTokenDelegator.badDebt(), 357392405781480063721876);
        assertEq(mTokenDelegator.getAccountTokens(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 2264582);
        assertEq(mTokenDelegator.getAccountTokens(user), 0);

        _exchangeRateAfterFixUser();
    }

    function testFixUserNotAdmin() public {
        vm.startPrank(address(1));
        vm.expectRevert("only the admin may call fixUser");
        _fixUser(address(2));
        vm.stopPrank();
    }

    function testMarketPaused() public {
        assertTrue(comptroller.borrowGuardianPaused(addresses.getAddress("MOONWELL_mFRAX")));
    }

    function testMint() public {
        address sender = address(this);
        uint256 mintAmount = 10e8;

        uint256 startingTokenBalance = token.balanceOf(address(mTokenDelegator));

        deal(address(token), sender, mintAmount);
        token.approve(address(mTokenDelegator), mintAmount);

        assertEq(mTokenDelegator.mint(mintAmount), 0);
        assertTrue(mTokenDelegator.balanceOf(sender) > 0);
        assertEq(token.balanceOf(address(mTokenDelegator)) - startingTokenBalance, mintAmount);
    }

    function testMintMoreThanUserHolds() public {
        address sender = address(this);
        uint256 dealAmount = 10e8;
        uint256 mintAmount = 100e8;

        deal(address(token), sender, dealAmount);
        token.approve(address(mTokenDelegator), mintAmount);

        vm.expectRevert("ERC20: transfer amount exceeds balance");
        mTokenDelegator.mint(mintAmount);
    }

    function testEnterMarket() public {
        address sender = address(this);
        uint256 mintAmount = 10e18;
        _mintAndDeal(sender, mintAmount);
        _enterMarkets();

        assertTrue(comptroller.checkMembership(sender, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));
    }

    function testEnterAndExitMarket() public {
        address sender = address(this);
        uint256 mintAmount = 10e18;
        _mintAndDeal(sender, mintAmount);
        _enterMarkets();

        assertTrue(comptroller.checkMembership(sender, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        comptroller.exitMarket(address(mTokenDelegator));

        assertFalse(comptroller.checkMembership(sender, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));
    }

    function testExitMarketNotEntered() public {
        assertEq(comptroller.exitMarket(address(mTokenDelegator)), 0);
    }

    function testExitMarketWithActiveBorrow() public {
        address sender = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;

        _mintAndDeal(sender, mintAmount);
        _enterMarkets();

        assertTrue(comptroller.checkMembership(sender, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(sender);

        /// @dev unpause market
        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        assertEq(mTokenDelegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(sender), borrowAmount);

        /// @dev the system does not allow us to exit the market, and returns the error Error.NONZERO_BORROW_BALANCE
        assertEq(comptroller.exitMarket(address(mTokenDelegator)), 12);
    }

    function testNoLiquidityShortfall() public {
        address sender = address(this);
        uint256 mintAmount = 10e18;

        _mintAndDeal(sender, mintAmount);
        _enterMarkets();

        assertTrue(comptroller.checkMembership(sender, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(sender);
    }

    function testBorrow() public {
        address sender = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 50e6;

        _mintAndDeal(sender, mintAmount);
        _enterMarkets();

        assertTrue(comptroller.checkMembership(sender, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        _liquidityShortfall(sender);

        /// @dev unpause market
        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        assertEq(mTokenDelegator.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(sender), borrowAmount);

        /// TODO check reward speed
    }

    function testBorrowPaused() public {
        address sender = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 11e18;

        _mintAndDeal(sender, mintAmount);
        _enterMarkets();

        assertTrue(comptroller.checkMembership(sender, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        vm.expectRevert("borrow is paused");
        mTokenDelegator.borrow(borrowAmount);
    }

    function testBorrowLiquidityShortfall() public {
        address sender = address(this);
        uint256 mintAmount = 10e18;
        uint256 borrowAmount = 11e18;

        _mintAndDeal(sender, mintAmount);
        _enterMarkets();

        assertTrue(comptroller.checkMembership(sender, IMToken(addresses.getAddress("MOONWELL_mFRAX"))));

        /// @dev unpause market
        _unpauseMarket(IMToken(addresses.getAddress("MOONWELL_mFRAX")));

        /// @dev the system does not allow us to borrow, and returns the error Error.INSUFFICIENT_LIQUIDITY
        assertEq(mTokenDelegator.borrow(borrowAmount), 3);
        assertEq(token.balanceOf(sender), 0);

        /// TODO check reward speed
    }

    function testBorrowMaxAmount() public {}

    function testBorrowCapExceeded() public {}

    function testRepay() public {}

    function testRepayMoreThanBorrowed() public {}

    function testRedeem() public {
        address sender = address(this);
        uint256 mintAmount = 10e18;

        _mintAndDeal(sender, mintAmount);

        uint256 balance = mTokenDelegator.balanceOf(sender);
        assertEq(mTokenDelegator.redeem(balance), 0);
    }

    function testRedeemOfMoreTokens() public {
        address sender = address(this);
        uint256 mintAmount = 10e18;

        _mintAndDeal(sender, mintAmount);

        uint256 balance = mTokenDelegator.balanceOf(sender);
        assertEq(mTokenDelegator.redeem(balance + 1_000e6), 9);
    }

    function testWithdrawOtherAssets() public {}

    function testClaimRewards() public {}

    function testClaimWELLReward() public {}

    function testClaimGLMRReward() public {}

    function testClaimInvalidReward() public {}

    function testLiquidateBorrow() public {}
}
