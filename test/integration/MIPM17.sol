pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {IERC20} from "@forge-proposal-simulator/lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import {PostProposalCheck} from "@tests/integration/PostProposalCheck.sol";

import {IComptroller} from "@protocol/Interfaces/IComptroller.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";

contract MIPM17IntegrationTest is PostProposalCheck {
    IComptroller comptroller;

    function testMintmFRAX() public {
        address sender = address(this);
        uint256 mintAmount = 10e18;

        comptroller = IComptroller(addresses.getAddress("UNITROLLER"));
    
        IERC20 token = IERC20(addresses.getAddress("FRAX"));
        IMErc20Delegator mToken = IMErc20Delegator(
            payable(addresses.getAddress("MOONWELL_mFRAX"))
        );
        uint256 startingTokenBalance = token.balanceOf(address(mToken));

        deal(address(token), sender, mintAmount);
        token.approve(address(mToken), mintAmount);

        assertEq(mToken.mint(mintAmount), 0);
        assertTrue(mToken.balanceOf(sender) > 0);
        assertEq(
            token.balanceOf(address(mToken)) - startingTokenBalance,
            mintAmount
        );
    }

    function testMintmxcDOT() public {}

    function testAddmFRAXLiquidity() public {
        address sender = address(this);
        uint256 mintAmount = 10e18;

        IERC20 token = IERC20(addresses.getAddress("FRAX"));
        IMErc20Delegator mToken = IMErc20Delegator(
            payable(addresses.getAddress("MOONWELL_mFRAX"))
        );

        deal(address(token), sender, mintAmount);
        token.approve(address(mToken), mintAmount);
    
        address[] memory mTokens = new address[](1);
        mTokens[0] = addresses.getAddress("MOONWELL_mFRAX");

        comptroller = IComptroller(addresses.getAddress("UNITROLLER"));
        uint256[] memory errors = comptroller.enterMarkets(mTokens);
        for (uint256 i = 0; i < errors.length; i++) {
            assertEq(errors[i], 0);
        }
    }

    function testAddmxcDOTLiquidity() public {}

    function testBorrowmFRAX() public {
        address sender = address(this);
        uint256 mintAmount = 10e18;

        IERC20 token = IERC20(addresses.getAddress("FRAX"));
        IMErc20Delegator mToken = IMErc20Delegator(
            payable(addresses.getAddress("MOONWELL_mFRAX"))
        );

        deal(address(token), sender, mintAmount);
        token.approve(address(mToken), mintAmount);

        address[] memory mTokens = new address[](1);
        mTokens[0] = addresses.getAddress("MOONWELL_mFRAX");

        comptroller = IComptroller(addresses.getAddress("UNITROLLER"));
        comptroller.enterMarkets(mTokens);

        uint256 borrowAmount = 1e18;

        assertEq(mToken.borrow(borrowAmount), 0);
        assertEq(token.balanceOf(sender), borrowAmount);
    }

    function testBorrowmxcDOT() public {}
}
