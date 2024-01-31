pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {IERC20} from "@forge-proposal-simulator/lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import {PostProposalCheck} from "@tests/integration/PostProposalCheck.sol";

import {IComptroller} from "@protocol/Interfaces/IComptroller.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";

contract MIPM17IntegrationTest is PostProposalCheck {
    IComptroller comptroller;

    function testPausedFRAX() public {
        comptroller = IComptroller(addresses.getAddress("UNITROLLER"));
        assertTrue(comptroller.borrowGuardianPaused(addresses.getAddress("MOONWELL_mFRAX")));
    }
}
