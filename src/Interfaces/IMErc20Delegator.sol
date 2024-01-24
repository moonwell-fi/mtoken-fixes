pragma solidity 0.8.19;

interface IMErc20Delegator {
    function admin() external returns (address);
    function _setImplementation(address, bool, bytes memory) external;
}
