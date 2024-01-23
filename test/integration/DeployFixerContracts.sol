pragma solidity 0.5.17;

import "@protocol/ComptrollerFixer.sol";
// import "@protocol/MErc20DelegateFixer.sol";
// import "@protocol/MErc20DelegateMadFixer.sol";

contract DeployFixerContracts {
    ComptrollerFixer comptroller;
    // MErc20DelegateFixer merc20Delegate;
    // MErc20DelegateMadFixer merc20DelegateMad;

    function deployUnitrollerFixer() public {
        comptroller = new ComptrollerFixer();
    }

    // function deployMErc20DelegateFixer() public {

    // }

    // function deployMErc20DelegateMadFixer() public {

    // }
}
