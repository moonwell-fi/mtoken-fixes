pragma solidity 0.8.19;

/// @title interface for MErc20DelegateFixer
interface IMErc20DelegateFixer {
    /// @notice get token balance
    function getTokenBalance(address) external returns (uint256);

    /// @notice fix a user
    function fixUser(address, address) external;

    /// @notice zero a balance 
    function _zeroBalance(address) external returns (uint256);

    /// @notice get cash
    function getCashPrior() external view returns (uint256);

    /// @notice get balance
    function balanceOf(address) external view returns (uint256);
}
