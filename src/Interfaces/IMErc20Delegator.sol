pragma solidity 0.8.19;

/// @title interface for MErc20Delegator
interface IMErc20Delegator {
    /// @notice provide assets for the market and receive mTokens in exchange
    function mint(uint) external returns (uint);

    /// @notice borrow from the protocol
    function borrow(uint) external returns (uint);

    /// @notice bad debt
    function badDebt() external returns (uint);

    /// @notice sweep all tokens to a given address
    function sweepAll(address) external;

    /// @notice accrue interest
    function accrueInterest() external returns (uint);

    /// @notice get cash amount
    function getCash() external returns (uint);

    /// @notice balance of the underlying token held by the contract
    function balance() external returns (uint);

    /// @notice balance of a given address
    function balanceOf(address) external returns (uint);

    /// @notice set implementation
    function _setImplementation(address, bool, bytes memory) external;

    /// @notice exchange rate
    function exchangeRateStored() external view returns (uint);

    /// @notice total reserves
    function totalReserves() external returns (uint);

    /// @notice total borrows
    function totalBorrows() external returns (uint);

    /// @notice total supply
    function totalSupply() external returns (uint);

    /// @notice implementation
    function implementation() external returns (address);

    /// @notice underlying asset
    function underlying() external returns (address);

    /// @notice fix user
    function fixUser(address, address) external;

    /// @notice account tokens
    function getAccountTokens(address) external view returns (uint);

    /// @notice redeem underlying token
    function redeem(uint) external returns (uint);
}
