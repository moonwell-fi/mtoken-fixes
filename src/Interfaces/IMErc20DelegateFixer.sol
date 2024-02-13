pragma solidity 0.8.19;

/// @title interface for MErc20DelegateFixer
interface IMErc20DelegateFixer {
    /// @notice fix user
    function fixUser(address, address) external;

    function repayBadDebt(uint256) external;
}
