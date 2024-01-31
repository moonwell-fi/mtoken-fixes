pragma solidity 0.5.17;

import "./MErc20Delegate.sol";
import "./SafeMath.sol";

//// @title MErc20DelegateMadFixer contract
contract MErc20DelegateFixer is MErc20Delegate {
    /// @notice bad debt counter
    uint256 public badDebt;

    /// @notice user fixed event (user, liquidator, amount)
    event UserFixed(address, address, uint256);

    /// @notice fix a user
    /// @param liquidator the account to transfer the tokens to
    /// @param user the account with bad debt
    function fixUser(address liquidator, address user) public {
        /// @dev check user is admin
        require(msg.sender == admin, "only the admin may call fixUser");

        /// @dev zero a user's borrow balance
        uint256 principal = _zeroBalance(user);

        /// @dev increment the bad debt counter
        badDebt = SafeMath.add(badDebt, principal);

        /// @dev subtract the previous balance from the totalBorrows balance
        totalBorrows = SafeMath.sub(totalBorrows, principal);

        /// @dev current amount for a user that we'll transfer to the liquidator
        uint256 liquidated = accountTokens[user];

        /// @dev zero out the user's tokens and transfer to the liquidator
        accountTokens[user] = 0;
        accountTokens[liquidator] = SafeMath.add(accountTokens[liquidator], liquidated);

        emit UserFixed(user, liquidator, accountTokens[liquidator]);
    }

    /// @notice get account tokens
    /// @param user the address to get the account tokens
    function getAccountTokens(address user) public view returns (uint256) {
        return accountTokens[user];
    }

    /// @notice zero the balance of a user
    /// @param user user to zero the balance of
    /// @return the principal prior to zeroing
    function _zeroBalance(address user) private returns (uint256) {
        /// @dev ensure that the borrow balance is up to date
        require(accrueInterest() == uint256(Error.NO_ERROR), "accrue interest failed");
        BorrowSnapshot storage borrowSnapshot = accountBorrows[user];
        if (borrowSnapshot.principal == 0) {
            return 0;
        }

        /// @dev the current principal
        uint256 principal = borrowSnapshot.principal;

        /// @dev zero balance
        borrowSnapshot.principal = 0;

        /// @dev return principal
        return principal;
    }

    /// @notice get cash
    function getCashPrior() internal view returns (uint256) {
        EIP20Interface token = EIP20Interface(underlying);
        uint256 total = token.balanceOf(address(this)) + badDebt;
        return total;
    }
}
