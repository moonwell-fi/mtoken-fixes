pragma solidity 0.8.19;

interface IComptrollerFixer {
    function admin() external returns (address);
    function balanceOf(address, address) external returns (uint256);
    function fixUsers(address, address[] memory) external;
    function badDebt(address) external returns (uint256);
    function totalBorrows(address market) external returns (uint256);
}
