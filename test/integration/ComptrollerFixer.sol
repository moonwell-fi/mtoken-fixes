pragma solidity 0.8.19;

import "@forge-std/Test.sol";

import {CreateCode} from "@protocol/proposals/utils/CreateCode.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";
import {IComptrollerFixer} from "@protocol/Interfaces/IComptrollerFixer.sol";
import {IMErc20DelegateFixer} from "@protocol/Interfaces/IMErc20DelegateFixer.sol";

import {Addresses} from "@forge-proposal-simulator/addresses/Addresses.sol";

contract ComptrollerFixerIntegrationTest is Test {
    CreateCode createCode;

    /// @dev contracts
    Addresses addresses;
    IComptrollerFixer comptrollerFixer;
    IMErc20Delegator mFRAXDelegator;
    IMErc20Delegator mxcDOTDelegator;
    IMErc20DelegateFixer mFRAXDelegateFixer;
    IMErc20DelegateFixer mxcDOTDelegateFixer;

    /// @dev addresses
    address comptrollerAddress;
    address delegateAddress;
    address mFRAXDelegatorAddress = 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C;
    address mxcDOTDelegatorAddress = 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3;

    /// @dev users
    address mFRAXUser = 0xA89Da48796bB808cb9aF3637ff7AB436f968C7d5;
    address mxcDOTUser = 0x9F6dC2Cf76fD22A0e5F11e0EDDe73502364FFBb8;

    /// @dev liquidator
    address liquidator;

    function setUp() public {
        addresses = new Addresses("./addresses/addresses.json");
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
}
