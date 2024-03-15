pragma solidity 0.8.19;

/// @title interface for MockMErc20DelegateFixer
interface IMockMErc20DelegateFixer {
    /// @notice bad debt counter
    function getUserBorrowInterestIndex(
        address user
    ) external view returns (uint256 interestIndex);
}
