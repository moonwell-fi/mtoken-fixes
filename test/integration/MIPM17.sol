pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {IERC20} from "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import {PostProposalCheck} from "@tests/integration/PostProposalCheck.sol";

import {IComptroller} from "@protocol/Interfaces/IComptroller.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";

contract MIPM17IntegrationTest is PostProposalCheck {
    IComptroller comptroller;

    function setUp() public {
        comptroller = IComptroller(addresses.getAddress("UNITROLLER"));
    }

    function testMintmFRAX() public {
        address sender = address(this);
        uint256 mintAmount = 100e6;

        EIP20Interface token = IERC20(addresses.getAddress("mFRAX"));
        IMErc20Delegator mToken = MErc20Delegator(
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

        address[] memory mTokens = new address[](1);
        mTokens[0] = address(mToken);

        comptroller.enterMarkets(mTokens);
        assertTrue(
            comptroller.checkMembership(
                sender,
                MToken(addresses.getAddress("MOONWELL_mFRAX"))
            )
        );

        (uint256 err, uint256 liquidity, uint256 shortfall) = comptroller
            .getAccountLiquidity(address(this));

        assertEq(err, 0, "Error getting account liquidity");
        assertApproxEqRel(
            liquidity,
            80e18,
            1e15,
            "liquidity not within .1% of $80"
        );
        assertEq(shortfall, 0, "Incorrect shortfall");

        comptroller.exitMarket(address(mToken));
    }

    // function testAddmFRAXLiquidity() public {
    //     testMintMTokenSucceeds();
    //     testMintcbETHmTokenSucceeds();
    //     testMintMWethMTokenSucceeds();

    //     address[] memory mTokens = new address[](3);
    //     mTokens[0] = addresses.getAddress("MOONWELL_USDBC");
    //     mTokens[1] = addresses.getAddress("MOONWELL_WETH");
    //     mTokens[2] = addresses.getAddress("MOONWELL_cbETH");

    //     uint256[] memory errors = comptroller.enterMarkets(mTokens);
    //     for (uint256 i = 0; i < errors.length; i++) {
    //         assertEq(errors[i], 0);
    //     }

    //     MToken[] memory assets = comptroller.getAssetsIn(address(this));

    //     assertEq(address(assets[0]), addresses.getAddress("MOONWELL_USDBC"));
    //     assertEq(address(assets[1]), addresses.getAddress("MOONWELL_WETH"));
    //     assertEq(address(assets[2]), addresses.getAddress("MOONWELL_cbETH"));
    // }

    function testmUSDCMadSwept() public {
        console.log("fooo");
    }

    function testmETHMadSwept() public {}

    function testmwBTCMadSwept() public {}
}
