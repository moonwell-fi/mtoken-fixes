pragma solidity 0.8.19;

import "./IMToken.sol";

/// @title interface for MErc20Delegator
interface IMErc20Delegator {
    /// @notice provide assets for the market and receive mTokens in exchange
    function mint(uint256) external returns (uint256);

    /// @notice borrow from the protocol
    function borrow(uint256) external returns (uint256);

    /// @notice bad debt
    function badDebt() external returns (uint256);

    /// @notice sweep all tokens to a given address
    function sweepAll(address) external;

    /// @notice accrue interest
    function accrueInterest() external returns (uint256);

    /// @notice block number that interest was last accrued at
    function accrualBlockTimestamp() external returns (uint256);

    /// @notice get cash amount
    function getCash() external returns (uint256);

    /// @notice balance of the underlying token held by the contract
    function balance() external returns (uint256);

    /// @notice balance of a given address
    function balanceOf(address) external returns (uint256);

    /// @notice set implementation
    function _setImplementation(address, bool, bytes memory) external;

    /// @notice exchange rate
    function exchangeRateStored() external view returns (uint256);

    /// @notice total reserves
    function totalReserves() external returns (uint256);

    /// @notice total borrows
    function totalBorrows() external returns (uint256);

    /// @notice total supply
    function totalSupply() external returns (uint256);

    /// @notice implementation
    function implementation() external returns (address);

    /// @notice underlying asset
    function underlying() external returns (address);

    /// @notice fix user
    function fixUser(address, address) external;

    /// @notice account tokens
    function getAccountTokens(address) external view returns (uint256);

    /// @notice redeem underlying token
    function redeem(uint256) external returns (uint256);

    /// @notice repay what was borrowed
    function repayBorrow(uint256) external returns (uint256);

    /// @notice repay what was borrowed on behalf of another user
    function repayBorrowBehalf(address, uint256) external returns (uint256);

    /// @notice liquidate a borrow
    function liquidateBorrow(address, uint256, IMToken) external returns (uint256);
}
