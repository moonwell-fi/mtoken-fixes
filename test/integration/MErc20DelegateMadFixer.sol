pragma solidity 0.8.19;

import "@forge-std/Test.sol";

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

    function setUp() public {
        addresses = new Addresses("./addresses/addresses.json");
        createCode = new CreateCode();

        /// @dev load the bytecode for MErc20DelegateMadFixer.sol
        bytes memory delegateCode = createCode.getCode("MErc20DelegateMadFixer.sol");
        delegateAddress = createCode.deployCode(delegateCode);

        bytes memory emptyData = new bytes(0);
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));

        mUSDCMadDelegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mUSDC"));
        mUSDCMadDelegateFixer = IMErc20DelegateMadFixer(delegateAddress);
        mUSDCMadDelegator._setImplementation(delegateAddress, false, emptyData);

        mwETHMadDelegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mETH"));
        mwETHMadDelegateFixer = IMErc20DelegateMadFixer(delegateAddress);
        mwETHMadDelegator._setImplementation(delegateAddress, false, emptyData);

        mwBTCMadDelegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mwBTC"));
        mwBTCMadDelegateFixer = IMErc20DelegateMadFixer(delegateAddress);
        mwBTCMadDelegator._setImplementation(delegateAddress, false, emptyData);

        vm.stopPrank();
    }

    function testSweepUnderlyingUSDC() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));

        assertEq(mUSDCMadDelegator.balance(), 10723851114129);
        assertEq(mUSDCMadDelegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 65456400996);

        mUSDCMadDelegator.sweepAll(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"));

        assertEq(mUSDCMadDelegator.balance(), 0);
        assertEq(mUSDCMadDelegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 10789307515125);

        vm.stopPrank();
    }

    function testSweepUnderlyingUSDCNotAdmin() public {
        vm.startPrank(address(1));
        vm.expectRevert("only admin may sweep all");
        mUSDCMadDelegator.sweepAll(address(2));
        vm.stopPrank();
    }

    function testSweepUnderlyingETH() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));

        assertEq(mwETHMadDelegator.balance(), 2244504406911169383342);
        assertEq(mwETHMadDelegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 24519061554277751182);

        mwETHMadDelegator.sweepAll(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"));

        assertEq(mwETHMadDelegator.balance(), 0);
        assertEq(
            mwETHMadDelegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 2269023468465447134524
        );

        vm.stopPrank();
    }

    function testSweepUnderlyingETHNotAdmin() public {
        vm.startPrank(address(1));
        vm.expectRevert("only admin may sweep all");
        mwETHMadDelegator.sweepAll(address(2));
        vm.stopPrank();
    }

    function testSweepUnderlyingBTC() public {
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));

        assertEq(mwBTCMadDelegator.balance(), 4229359527);
        assertEq(mwBTCMadDelegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 196336752);

        mwBTCMadDelegator.sweepAll(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"));

        assertEq(mwBTCMadDelegator.balance(), 0);
        assertEq(mwBTCMadDelegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 4425696279);

        vm.stopPrank();
    }

    function testSweepUnderlyingBTCNotAdmin() public {
        vm.startPrank(address(1));
        vm.expectRevert("only admin may sweep all");
        mwBTCMadDelegator.sweepAll(address(2));
        vm.stopPrank();
    }
}
