pragma solidity 0.8.19;

import "./IMToken.sol";

/// @title interface for MErc20Delegator
interface IComptroller {
    /// @notice check membership
    function checkMembership(address, IMToken) external view returns (bool);

    /// @notice add assets to be included in account liquidity calculation
    function enterMarkets(address[] memory) external returns (uint[] memory);

    /// @notice removes an asset from account liquidity calculation
    function exitMarket(address) external returns (uint);

    /// @notice set state of a market
    function _setBorrowPaused(IMToken, bool) external returns (bool);

    /// @notice borrow caps
    function borrowCaps(address) external returns (uint);

    /// @notice is the borrow guardian paused for a market
    function borrowGuardianPaused(address) external returns (bool);

    /// @notice account liquidity
    function getAccountLiquidity(address account) external view returns (uint, uint, uint);
}
