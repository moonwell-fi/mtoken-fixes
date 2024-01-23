pragma solidity 0.8.19;

interface IMErc20Delegator {
    function admin() external returns (address);
    function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) external;
}
