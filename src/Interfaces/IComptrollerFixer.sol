pragma solidity 0.8.19;

/// @title interface for ComptrollerFixer
interface IComptrollerFixer {
    /// @notice get the admin address
    function admin() external returns (address);

    /// @notice balance held by an account in a given market
    function balanceOf(address, address) external returns (uint256);

    /// @notice fix users
    function fixUsers(address, address[] memory) external;

    /// @notice amount of bad debt held by an address
    function badDebt(address) external returns (uint256);

    /// @notice total borrows for a market
    function totalBorrows(address) external returns (uint256);
}
