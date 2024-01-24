pragma solidity 0.8.19;

interface IMErc20Delegator {
    function admin() external returns (address);
    function underlying() external returns (address);
    function sweepAll(address) external;
    function balance() external returns (uint256);
    function balanceOf(address) external returns (uint256);
    function _setImplementation(address, bool, bytes memory) external;
}
