pragma solidity 0.5.17;

import "@protocol/UnitrollerFixer.sol";
import "@protocol/MErc20DelegateFixer.sol";
import "@protocol/MErc20DelegateMadFixer.sol";

contract DeployFixerContracts {
    UnitrollerFixer comptroller;
    MErc20DelegateFixer merc20Delegate;
    MErc20DelegateMadFixer merc20DelegateMad;

    function deployUnitrollerFixer() public {
        comptroller = new UnitrollerFixer();
    }

    function deployMErc20DelegateFixer() public {

    }

    function deployMErc20DelegateMadFixer() public {

    }
}
