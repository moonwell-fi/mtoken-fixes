pragma solidity 0.5.17;

import "./MErc20Delegate.sol";
import "./SafeMath.sol";

//// @title MErc20DelegateMadFixer contract
contract MErc20DelegateFixer is MErc20Delegate {
    /// @notice bad debt counter
    uint256 public badDebt;

    /// @notice user fixed event (user, liquidator, amount)
    event UserFixed(address, address, uint256);

    /// @notice bad debt repayed event (amount)
    event BadDebtRepayed(uint256);

    /// @notice bad debt repayed with reserves
    event BadDebtRepayedWithReserves(
        uint256 badDebt,
        uint256 previousBadDebt,
        uint256 reserves,
        uint256 previousReserves
    );

    /// @notice repay bad debt, can only reduce the bad debt
    /// @param amount the amount of bad debt to repay
    /// invariant, calling this function can only reduce the bad debt
    /// it cannot increase it, which is what would happen on an underflow
    function repayBadDebt(uint256 amount) external nonReentrant {
        /// Checks
        require(amount <= badDebt, "amount exceeds bad debt");

        /// Effects
        badDebt = SafeMath.sub(badDebt, amount);

        EIP20Interface token = EIP20Interface(underlying);

        /// Interactions
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "transfer in failed"
        );

        emit BadDebtRepayed(amount);
    }

    /// @notice function can only decrease bad debt and reserves
    /// if this function is called, both bad debt and reserves will be decreased
    /// calling this function cannot change the share price
    /// both bad debt and reserves will decrement by the same amount
    function repayBadDebtWithReserves() external nonReentrant {
        uint256 currentReserves = totalReserves;
        uint256 currentBadDebt = badDebt;

        require(currentReserves != 0, "reserves are zero");
        require(currentBadDebt != 0, "bad debt is zero");

        /// no reverts possible past this point

        /// take the lesser of the two, subtract it from both numbers
        uint256 subtractAmount = currentBadDebt < currentReserves
            ? currentBadDebt
            : currentReserves;

        /// bad debt -= subtract amount
        badDebt = SafeMath.sub(currentBadDebt, subtractAmount);

        /// current reserves -= subtract amount
        totalReserves = SafeMath.sub(currentReserves, subtractAmount);

        emit BadDebtRepayedWithReserves(
            badDebt,
            currentBadDebt,
            totalReserves,
            currentReserves
        );
    }

    /// @notice fix a user
    /// @param liquidator the account to transfer the tokens to
    /// @param user the account with bad debt
    /// invariant, this can only reduce or keep user and total debt the same
    function fixUser(address liquidator, address user) external {
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

        if (liquidated != 0) {
            /// if assets were liquidated, give them to the liquidator
            accountTokens[liquidator] = SafeMath.add(
                accountTokens[liquidator],
                liquidated
            );

            /// zero out the user's tokens
            accountTokens[user] = 0;
        }

        emit UserFixed(user, liquidator, accountTokens[liquidator]);
    }

    /// @notice zero the balance of a user
    /// @param user user to zero the balance of
    /// @return the principal prior to zeroing
    function _zeroBalance(address user) private returns (uint256 principal) {
        /// @dev ensure that the borrow balance is up to date
        require(
            accrueInterest() == uint256(Error.NO_ERROR),
            "accrue interest failed"
        );
        BorrowSnapshot storage borrowSnapshot = accountBorrows[user];
        if (borrowSnapshot.principal == 0) {
            return 0;
        }

        /// @dev the current principal
        principal = borrowSnapshot.principal;

        /// @dev zero balance
        borrowSnapshot.principal = 0;
        borrowSnapshot.interestIndex = borrowIndex;
    }

    /// @notice get cash for the market, including bad debt in this calculation
    /// bad debt must be included in order to maintain the market share price
    function getCashPrior() internal view returns (uint256) {
        /// safe math unused intentionally, should never overflow as the sum
        /// should never be greater than UINT_MAX
        return EIP20Interface(underlying).balanceOf(address(this)) + badDebt;
    }
}
