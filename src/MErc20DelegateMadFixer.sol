pragma solidity 0.5.17;

import "./MErc20Delegate.sol";

/// @title MErc20DelegateMadFixer contract
contract MErc20DelegateMadFixer is MErc20Delegate {
    /// @notice user fixed event (user, liquidator, amount)
    event TokensSwept(address, uint256);

    /// @notice sweep underlying tokens
    /// @param sweeper address of the sweeper
    function sweepAll(address sweeper) public {
        /// @dev checks
        require(msg.sender == admin, "only admin may sweep all");

        uint256 amount = EIP20Interface(underlying).balanceOf(address(this));
        EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
        require(amount > 0, "balance must be greater than zero");

        /// @dev take it, take it all
        token.approve(address(this), amount);
        token.transferFrom(address(this), sweeper, amount);
    }

    /// @notice balance
    /// @return balance held by the contract
    function balance() public view returns (uint256) {
        return EIP20Interface(underlying).balanceOf(address(this));
    }

    /// @notice balance for a given account
    /// @param account to get the balance of
    /// @return balance held by the account
    function balanceOf(address account) public view returns (uint256) {
        return EIP20Interface(underlying).balanceOf(account);
    }
}
