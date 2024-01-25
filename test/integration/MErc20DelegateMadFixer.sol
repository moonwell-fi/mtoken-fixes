pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {CreateCode} from "@protocol/proposals/utils/CreateCode.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";
import {IMErc20DelegateMadFixer} from "@protocol/Interfaces/IMErc20DelegateMadFixer.sol";

import {Addresses} from "@forge-proposal-simulator/addresses/Addresses.sol";

contract MErc20DelegateMadFixerIntegrationTest is Test {
    CreateCode createCode;

    /// @dev contracts
    Addresses addresses;
    IMErc20Delegator mUSDCMadDelegator;
    IMErc20Delegator mwETHMadDelegator;
    IMErc20Delegator mwBTCMadDelegator;
    IMErc20DelegateMadFixer mUSDCMadDelegateFixer;
    IMErc20DelegateMadFixer mwETHMadDelegateFixer;
    IMErc20DelegateMadFixer mwBTCMadDelegateFixer;

    /// @dev addresses
    address delegateAddress;
    address mUSDCMadDelegatorAddress = 0x02e9081DfadD37A852F9a73C4d7d69e615E61334;
    address mwETHMadDelegatorAddress = 0xc3090f41Eb54A7f18587FD6651d4D3ab477b07a4;
    address mwBTCMadDelegatorAddress = 0x24A9d8f1f350d59cB0368D3d52A77dB29c833D1D;

    function setUp() public {
        addresses = new Addresses("./addresses/addresses.json");
        createCode = new CreateCode();

        /// @dev load the bytecode for MErc20DelegateMadFixer.sol
        bytes memory delegateCode = createCode.getCode("MErc20DelegateMadFixer.sol");
        delegateAddress = createCode.deployCode(delegateCode);

        bytes memory emptyData = new bytes(0);
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));

        mUSDCMadDelegator = IMErc20Delegator(mUSDCMadDelegatorAddress);
        mUSDCMadDelegateFixer = IMErc20DelegateMadFixer(delegateAddress);
        mUSDCMadDelegator._setImplementation(delegateAddress, false, emptyData);

        mwETHMadDelegator = IMErc20Delegator(mwETHMadDelegatorAddress);
        mwETHMadDelegateFixer = IMErc20DelegateMadFixer(delegateAddress);
        mwETHMadDelegator._setImplementation(delegateAddress, false, emptyData);

        mwBTCMadDelegator = IMErc20Delegator(mwBTCMadDelegatorAddress);
        mwBTCMadDelegateFixer = IMErc20DelegateMadFixer(delegateAddress);
        mwBTCMadDelegator._setImplementation(delegateAddress, false, emptyData);

        vm.stopPrank();
    }

    function testSweepUnderlying_mUSDCMad() public {
        vm.startPrank(mUSDCMadDelegator.admin());

        assertEq(mUSDCMadDelegator.balance(), 10724013798255);
        assertEq(mUSDCMadDelegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 65456400996);

        mUSDCMadDelegator.sweepAll(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"));

        assertEq(mUSDCMadDelegator.balance(), 0);
        assertEq(mUSDCMadDelegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 10789470199251);

        vm.stopPrank();
    }

    function testSweepUnderlying_mwETHMad() public {
        vm.startPrank(mwETHMadDelegator.admin());

        assertEq(mwETHMadDelegator.balance(), 2244504406911169383342);
        assertEq(mwETHMadDelegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 24519061554277751182);

        mwETHMadDelegator.sweepAll(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"));

        assertEq(mwETHMadDelegator.balance(), 0);
        assertEq(mwETHMadDelegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 2269023468465447134524);

        vm.stopPrank();
    }

    function testSweepUnderlying_mwBTCMad() public {
        vm.startPrank(mwBTCMadDelegator.admin());

        assertEq(mwBTCMadDelegator.balance(), 4229359527);
        assertEq(mwBTCMadDelegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 196336752);

        mwBTCMadDelegator.sweepAll(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"));

        assertEq(mwBTCMadDelegator.balance(), 0);
        assertEq(mwBTCMadDelegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 4425696279);

        vm.stopPrank();
    }
}
