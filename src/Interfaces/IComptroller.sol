pragma solidity 0.8.19;

/// @title interface for MErc20Delegator
interface IComptroller {
    /// @dev add assets to be included in account liquidity calculation
    function enterMarkets(address[] memory) external returns (uint[] memory);

    /// @dev removes an asset from account liquidity calculation
    function exitMarket(address) external returns (uint);

    /// @dev is the borrow guardian paused for a market
    function borrowGuardianPaused(address) external returns (bool);
}
