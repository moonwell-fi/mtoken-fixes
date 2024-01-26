pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {PostProposalCheck} from "@tests/integration/PostProposalCheck.sol";

import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";
import {IMErc20DelegateFixer} from "@protocol/Interfaces/IMErc20DelegateFixer.sol";

contract MIPM17IntegrationTest is PostProposalCheck {
    /// @dev debtors list
    struct Debtors {
        address addr;
    }

    function testmUSDCMadSwept() public {
        IMErc20Delegator mUSDCMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mUSDC"));
        uint256 mUSDCCash = mUSDCMErc20Delegator.getCash();

        assertEq(mUSDCMErc20Delegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 10789470199251);
        assertEq(mUSDCCash, 0);
    }

    function testmETHMadSwept() public {
        IMErc20Delegator mETHMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mETH"));
        uint256 mETHCash = mETHMErc20Delegator.getCash();

        assertEq(
            mETHMErc20Delegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 2269023468465447134524
        );
        assertEq(mETHCash, 0);
    }

    function testmwBTCMadSwept() public {
        IMErc20Delegator mwBTCMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mwBTC"));
        uint256 mwBTCCash = mwBTCMErc20Delegator.getCash();

        assertEq(mwBTCMErc20Delegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 4425696279);
        assertEq(mwBTCCash, 0);
    }

    function testBadmFRAXDebtLiquidated() public {
        string memory debtorsRaw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/mFRAX.json")));
        bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
        Debtors[] memory debtors = abi.decode(debtorsParsed, (Debtors[]));

        IMErc20Delegator mErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mFRAX"));
        for (uint256 i = 0; i < debtors.length; i++) {
            assertEq(mErc20Delegator.balanceOf(debtors[i].addr), 0);
        }

        assertEq(mErc20Delegator.badDebt(), 357392405781480063721876);
    }

    function testBadmxcDOTDebtLiquidated() public {
        string memory debtorsRaw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/mxcDOT.json")));
        bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
        Debtors[] memory debtors = abi.decode(debtorsParsed, (Debtors[]));

        IMErc20Delegator mErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mxcDOT"));
        for (uint256 i = 0; i < debtors.length; i++) {
            assertEq(mErc20Delegator.balanceOf(debtors[i].addr), 0);
        }

        assertEq(mErc20Delegator.badDebt(), 252390068440489);
    }
}
