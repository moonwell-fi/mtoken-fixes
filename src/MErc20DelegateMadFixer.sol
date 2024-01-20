pragma solidity 0.5.17;

import "./MErc20Delegate.sol";

//// @title MErc20DelegateMadFixer contract
contract MErc20DelegateFixer is MErc20Delegate {
    /// @notice sweep underlying nomad ERC-20 tokens
    /// @param sweeper address of the sweeper (admin multisig?)
    function sweepUnderlying(address sweeper) public {
        /// @dev checks
        require(msg.sender == admin, "only admin may sweep all collateral");
        /// TODO check that underlying is a nomad asset

        uint256 amount = EIP20Interface(underlying).balanceOf(address(this));
        EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
        require(amount > 0, "balance must be greater than zero");

        /// @dev take it, take it all
        token.transferFrom(address(this), sweeper, amount);
    }
}
