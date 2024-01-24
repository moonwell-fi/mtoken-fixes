pragma solidity 0.8.19;

interface IMErc20DelegateFixer {
    function getTokenBalance(address account) external returns (uint256);
    function fixUser(address liquidator, address user) external;
    function _resignImplementation() external;
    function _zeroBalance(address) external returns (uint256);
    function getCashPrior() external view returns (uint256);
}
