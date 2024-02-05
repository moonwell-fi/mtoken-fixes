pragma solidity 0.8.19;

import "./IMToken.sol";

/// @title interface for MErc20Delegator
interface IComptroller {
    /// @notice check membership
    function checkMembership(address, IMToken) external view returns (bool);

    /// @notice add assets to be included in account liquidity calculation
    function enterMarkets(address[] memory) external returns (uint256[] memory);

    /// @notice removes an asset from account liquidity calculation
    function exitMarket(address) external returns (uint256);

    /// @notice set state of a market
    function _setBorrowPaused(IMToken, bool) external returns (bool);

    /// @notice borrow caps
    function borrowCaps(address) external returns (uint256);

    /// @notice is the borrow guardian paused for a market
    function borrowGuardianPaused(address) external returns (bool);

    /// @notice account liquidity
    function getAccountLiquidity(address) external view returns (uint256, uint256, uint256);

    /// @notice supply reward speeds
    function supplyRewardSpeeds(uint8, address) external returns (uint256);

    /// @notice borrow reward speeds
    function borrowRewardSpeeds(uint8, address) external returns (uint256);

    /// @notice claim reward
    function claimReward(uint8, address payable) external;

    /// @notice accrued rewards
    function rewardAccrued(uint8, address) external returns (uint256);
}