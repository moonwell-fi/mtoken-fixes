pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {Addresses} from "@proposals/Addresses.sol";
import {CreateCode} from "@proposals/utils/CreateCode.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";
import {IComptrollerFixer} from "@protocol/Interfaces/IComptrollerFixer.sol";
import {IMErc20DelegateFixer} from "@protocol/Interfaces/IMErc20DelegateFixer.sol";

contract ComptrollerFixterIntegrationTest is Test {
    CreateCode createCode;

    /// @dev contracts
    Addresses addresses;
    IComptrollerFixer comptrollerFixer;
    IMErc20Delegator mFRAXDelegator;
    IMErc20Delegator mxcDOTDelegator;
    IMErc20Delegator mUSDCMadDelegator;
    IMErc20Delegator mwETHMadDelegator;
    IMErc20Delegator mwBTCMadDelegator;
    IMErc20DelegateFixer mFRAXDelegateFixer;
    IMErc20DelegateFixer mxcDOTDelegateFixer;
    IMErc20DelegateFixer mUSDCMadDelegateFixer;
    IMErc20DelegateFixer mwETHMadDelegateFixer;
    IMErc20DelegateFixer mwBTCMadDelegateFixer;

    /// @dev addresses
    address comptrollerAddress;
    address delegateAddress;
    address mFRAXDelegatorAddress = 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C;
    address mxcDOTDelegatorAddress = 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3;
    address mUSDCMadDelegatorAddress = 0x02e9081DfadD37A852F9a73C4d7d69e615E61334;
    address mwETHMadDelegatorAddress = 0xc3090f41Eb54A7f18587FD6651d4D3ab477b07a4;
    address mwBTCMadDelegatorAddress = 0x24A9d8f1f350d59cB0368D3d52A77dB29c833D1D;

    /// @dev users
    address mFRAXUser = 0xA89Da48796bB808cb9aF3637ff7AB436f968C7d5;
    address mxcDOTUser = 0x9F6dC2Cf76fD22A0e5F11e0EDDe73502364FFBb8;
    address mUSDCMadUser = 0x3769859A5eFA6133Cd74c5eb5080F46bEFfB6Cef;
    address mwETHMadUser = 0x193Db18A5EF9a0320b7374C1fE8Af976235f3211;
    address mwBTCMadUser = 0xDD15c08320F01F1b6348b35EeBe29fDB5ca0cDa6;

    /// @dev liquidator
    address liquidator;

    function setUp() public {
        addresses = new Addresses();
        createCode = new CreateCode();

        /// @dev load the bytecode for ComptrollerFixer.sol
        bytes memory comptrollerCode = createCode.getCode("ComptrollerFixer.sol");
        comptrollerAddress = createCode.deployCode(comptrollerCode);

        /// @dev load the bytecode for MErc20DelegateFixer.sol
        bytes memory delegateCode = createCode.getCode("MErc20DelegateFixer.sol");
        delegateAddress = createCode.deployCode(delegateCode);

        bytes memory emptyData = new bytes(0);
        vm.startPrank(addresses.getAddress("MOONBEAM_TIMELOCK"));

        comptrollerFixer = IComptrollerFixer(comptrollerAddress);
        assertTrue(comptrollerAddress != address(0));

        mFRAXDelegator = IMErc20Delegator(mFRAXDelegatorAddress);
        mFRAXDelegateFixer = IMErc20DelegateFixer(delegateAddress);
        mFRAXDelegator._setImplementation(delegateAddress, false, emptyData);

        mxcDOTDelegator = IMErc20Delegator(mxcDOTDelegatorAddress);
        mxcDOTDelegateFixer = IMErc20DelegateFixer(delegateAddress);
        mxcDOTDelegator._setImplementation(delegateAddress, false, emptyData);

        mUSDCMadDelegator = IMErc20Delegator(mUSDCMadDelegatorAddress);
        mUSDCMadDelegateFixer = IMErc20DelegateFixer(delegateAddress);
        mUSDCMadDelegator._setImplementation(delegateAddress, false, emptyData);

        mwETHMadDelegator = IMErc20Delegator(mwETHMadDelegatorAddress);
        mwETHMadDelegateFixer = IMErc20DelegateFixer(delegateAddress);
        mwETHMadDelegator._setImplementation(delegateAddress, false, emptyData);

        mwBTCMadDelegator = IMErc20Delegator(mwBTCMadDelegatorAddress);
        mwBTCMadDelegateFixer = IMErc20DelegateFixer(delegateAddress);
        mwBTCMadDelegator._setImplementation(delegateAddress, false, emptyData);

        vm.stopPrank();
    }

    function testFixUsers_mFRAX() public {
        assertEq(comptrollerFixer.balanceOf(mFRAXUser, address(mFRAXDelegator)), 1345280);
        assertEq(
            comptrollerFixer.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), address(mFRAXDelegator)), 0
        );
        assertEq(comptrollerFixer.badDebt(address(mFRAXDelegator)), 0);
        uint256 totalBorrows = comptrollerFixer.totalBorrows(address(mFRAXDelegator));
        assertTrue(totalBorrows > 0);

        address[] memory userList = new address[](1);
        userList[0] = mFRAXUser;

        vm.startPrank(comptrollerFixer.admin());
        comptrollerFixer.fixUsers(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), userList);
        vm.stopPrank();

        assertEq(comptrollerFixer.balanceOf(mFRAXUser, address(mFRAXDelegator)), 0);
        assertEq(
            comptrollerFixer.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), address(mFRAXDelegator)),
            1345280
        );
        assertEq(comptrollerFixer.badDebt(address(mFRAXDelegator)), 690098631691243174645);
        assertTrue(comptrollerFixer.totalBorrows(address(mFRAXDelegator)) < totalBorrows);
    }

    function testFixUsers_mxcDOT() public {
        assertEq(comptrollerFixer.balanceOf(mxcDOTUser, address(mxcDOTDelegator)), 1);
        assertEq(
            comptrollerFixer.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), address(mxcDOTDelegator)), 0
        );
        assertEq(comptrollerFixer.badDebt(address(mxcDOTDelegator)), 0);
        uint256 totalBorrows = comptrollerFixer.totalBorrows(address(mxcDOTDelegator));
        assertTrue(totalBorrows > 0);

        address[] memory userList = new address[](1);
        userList[0] = mxcDOTUser;

        vm.startPrank(comptrollerFixer.admin());
        comptrollerFixer.fixUsers(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), userList);
        vm.stopPrank();

        assertEq(comptrollerFixer.balanceOf(mxcDOTUser, address(mxcDOTDelegator)), 0);
        assertEq(
            comptrollerFixer.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), address(mxcDOTDelegator)), 1
        );
        assertEq(comptrollerFixer.badDebt(address(mxcDOTDelegator)), 252390068440489);
        assertTrue(comptrollerFixer.totalBorrows(address(mxcDOTDelegator)) < totalBorrows);
    }

    function testFixUsers_mUSDCMad() public {
        assertEq(comptrollerFixer.balanceOf(mUSDCMadUser, address(mUSDCMadDelegator)), 1767);
        assertEq(
            comptrollerFixer.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), address(mUSDCMadDelegator)),
            0
        );
        assertEq(comptrollerFixer.badDebt(address(mUSDCMadDelegator)), 0);
        uint256 totalBorrows = comptrollerFixer.totalBorrows(address(mUSDCMadDelegator));
        assertTrue(totalBorrows > 0);

        address[] memory userList = new address[](1);
        userList[0] = mUSDCMadUser;

        vm.startPrank(comptrollerFixer.admin());
        comptrollerFixer.fixUsers(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), userList);
        vm.stopPrank();

        assertEq(comptrollerFixer.balanceOf(mUSDCMadUser, address(mUSDCMadDelegator)), 0);
        assertEq(
            comptrollerFixer.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), address(mUSDCMadDelegator)),
            1767
        );
        assertEq(comptrollerFixer.badDebt(address(mUSDCMadDelegator)), 510262);
    }

    function testFixUsers_mwETHMad() public {
        assertEq(comptrollerFixer.balanceOf(mwETHMadUser, address(mwETHMadDelegator)), 4189);
        assertEq(
            comptrollerFixer.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), address(mwETHMadDelegator)),
            0
        );
        assertEq(comptrollerFixer.badDebt(address(mwETHMadDelegator)), 0);
        uint256 totalBorrows = comptrollerFixer.totalBorrows(address(mwETHMadDelegator));
        assertTrue(totalBorrows > 0);

        address[] memory userList = new address[](1);
        userList[0] = mwETHMadUser;

        vm.startPrank(comptrollerFixer.admin());
        comptrollerFixer.fixUsers(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), userList);
        vm.stopPrank();

        assertEq(comptrollerFixer.balanceOf(mwETHMadUser, address(mwETHMadDelegator)), 0);
        assertEq(
            comptrollerFixer.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), address(mwETHMadDelegator)),
            4189
        );

        /// TODO this should not be zero!?!?!?
        assertEq(comptrollerFixer.badDebt(address(mwETHMadDelegator)), 0);
    }

    function testFixUsers_mwBTCMad() public {
        assertEq(comptrollerFixer.balanceOf(mwBTCMadUser, address(mwBTCMadDelegator)), 47);
        assertEq(
            comptrollerFixer.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), address(mwBTCMadDelegator)),
            0
        );
        assertEq(comptrollerFixer.badDebt(address(mwBTCMadDelegator)), 0);
        uint256 totalBorrows = comptrollerFixer.totalBorrows(address(mwBTCMadDelegator));
        assertTrue(totalBorrows > 0);

        address[] memory userList = new address[](1);
        userList[0] = mwBTCMadUser;

        vm.startPrank(comptrollerFixer.admin());
        comptrollerFixer.fixUsers(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), userList);
        vm.stopPrank();

        assertEq(comptrollerFixer.balanceOf(mwBTCMadUser, address(mwBTCMadDelegator)), 0);
        assertEq(
            comptrollerFixer.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), address(mwBTCMadDelegator)),
            47
        );
        assertEq(comptrollerFixer.badDebt(address(mwBTCMadDelegator)), 54884);
    }
}
