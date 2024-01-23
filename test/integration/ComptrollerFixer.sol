pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {CreateCode} from "@proposals/utils/CreateCode.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";
import {IComptrollerFixer} from "@protocol/Interfaces/IComptrollerFixer.sol";
import {IMErc20DelegateFixer} from "@protocol/Interfaces/IMErc20DelegateFixer.sol";

contract ComptrollerFixterIntegrationTest is Test {
    CreateCode createCode;
    address comptrollerAddress;
    address delegateAddress;
    
    function setUp() public {
        createCode = new CreateCode();

        bytes memory comptrollerCode = createCode.getCode("ComptrollerFixer.sol");
        comptrollerAddress = createCode.deployCode(comptrollerCode);

        bytes memory delegateCode = createCode.getCode("MErc20DelegateFixer.sol");
        delegateAddress = createCode.deployCode(delegateCode);
    }

    function testFixUsersFRAX() public {
        IComptrollerFixer comptrollerFixer = IComptrollerFixer(comptrollerAddress);
        assertTrue(comptrollerAddress != address(0));

        IMErc20Delegator delegator = IMErc20Delegator(0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C);
        IMErc20DelegateFixer delegate = IMErc20DelegateFixer(delegateAddress);

        bytes memory emptyData = new bytes(0);
        vm.prank(delegator.admin());
        delegator._setImplementation(delegateAddress, false, emptyData);

        address[] memory userList = new address[](1);
        userList[0] = address(0xA89Da48796bB808cb9aF3637ff7AB436f968C7d5);

        vm.startPrank(comptrollerFixer.admin());
        comptrollerFixer.fixUsers(address(1), userList);
        vm.stopPrank();
    }
}
