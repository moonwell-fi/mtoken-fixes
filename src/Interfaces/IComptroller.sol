pragma solidity 0.8.19;

/// @title interface for MErc20Delegator
interface IComptroller {
    function checkMembership(address, MToken) external view returns (bool);
    function enterMarkets(address[]) external returns (uint[] memory);
    function exitMarket(address) external returns (uint);
}
