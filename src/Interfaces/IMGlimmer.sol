pragma solidity 0.8.19;

/// @title MGlimmer token interface
interface IMGlimmer {
    /// @notice balance of a given address
    function balanceOf(address) external returns (uint256);
}
