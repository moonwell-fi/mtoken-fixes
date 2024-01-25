pragma solidity 0.8.19;

/// @title interface for MErc20Delegator
interface IMErc20Delegator {
    /// @notice get the admin address
    function admin() external returns (address);

    /// @notice get the underlying ERC20 address
    function underlying() external returns (address);

    /// @notice sweep all tokens to a given address
    function sweepAll(address) external;

    /// @notice get cash amount
    function getCash() external returns (uint256);

    /// @notice balance of the underlying token held by the contract
    function balance() external returns (uint256);

    /// @notice balance of a given address
    function balanceOf(address) external returns (uint256);

    /// @notice set implementation
    function _setImplementation(address, bool, bytes memory) external;
}
