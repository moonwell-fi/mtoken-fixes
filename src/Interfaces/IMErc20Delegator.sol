pragma solidity 0.8.19;

/// @title interface for MErc20Delegator
interface IMErc20Delegator {
    /// @notice get cash amount
    function getCash() external returns (uint256);

    /// @notice balance of a given address
    function balanceOf(address) external returns (uint256);

    /// @notice set implementation
    function _setImplementation(address, bool, bytes memory) external;

    /// @notice exchange rate
    function exchangeRateStored() external view returns (uint);
}
