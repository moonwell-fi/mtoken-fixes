pragma solidity 0.8.19;

interface IMErc20DelegateMadFixer {
    function admin() external returns (address);
    function sweepAll(address) external;
}
