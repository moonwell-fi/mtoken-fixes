pragma solidity 0.8.19;

interface IComptrollerFixer {
    function admin() external returns (address);
    function fixUsers(address liquidator, address[] memory users) external;
}
