pragma solidity 0.5.17;

import "./MErc20Delegate.sol";
import "./SafeMath.sol";

//// @title MErc20DelegateMadFixer contract
contract MErc20DelegateFixer is MErc20Delegate {
    /// @notice bad debt counter
    uint256 public badDebt;

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

        /// @dev send the user's mToken balances to the community multisig
        transferTokens(msg.sender, address(user), liquidator, accountTokens[user]);
    }

    /// @notice zero the balance of a user
    /// @param user user to zero the balance of
    /// @return the principal prior to zeroing
    function _zeroBalance(address user) internal returns (uint256) {
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
        borrowSnapshot.interestIndex = 0;

        /// @dev return principal
        return principal;
    }

    /// @notice get cash
    function getCashPrior() internal view returns (uint) {
        return super.getCashPrior() + badDebt;
    }
}
