using MockERC20 as token;
using MockMErc20DelegateFixer as fixer;

methods {
    function badDebt() external returns (uint256) envfree;
    function fixUser(address liquidator, address user) external;
    function borrowIndex() external returns (uint256) envfree;
    function token.balanceOf(address) external returns (uint256) envfree;
    function balanceOf(address) external returns (uint256) envfree;
    function repayBadDebtWithCash(uint256) external;
    function accrueInterest() external returns (uint256);
    function exchangeRateCurrent() external returns (uint256);
    function borrowBalanceCurrent(address account) external returns (uint256);
    function repayBadDebtWithReserves() external;
    function getUserBorrowSnapshot(address user) external returns (uint256, uint256) envfree;
}

function one() returns uint256 {
    return 1000000000000000000;
}

rule fixUserIncreasesBadDebt(env e) {
    address user;
    address liquidator;
    uint256 principle;
    uint256 interestIndex;

    require borrowIndex() >= one();
    principle, interestIndex = getUserBorrowSnapshot(user);

    require interestIndex <= borrowIndex();
    require interestIndex >= one();

    uint256 badDebt = badDebt();
    uint256 liquidatorBalance = balanceOf(liquidator);
    uint256 userBalance = balanceOf(user);
    uint256 borrowBalance = borrowBalanceCurrent(e, user);

    fixUser(e, liquidator, user);

    uint256 badDebtAfter = badDebt();

    assert badDebtAfter >= badDebt, "bad debt decreased from fixing a user";
    assert balanceOf(user) == 0, "user balance not zero";
    assert liquidatorBalance + userBalance == to_mathint(balanceOf(liquidator)), "liquidator balance not increased by user balance";
    assert borrowBalanceCurrent(e, user) == 0, "user borrow balance not zero";
    assert badDebt + borrowBalance == to_mathint(badDebtAfter), "bad debt not increased by user borrow amt";
}

rule fixingUserDoesNotChangeSharePrice(env e) {
    address user;
    address liquidator;
    uint256 principle;
    uint256 interestIndex;

    /// ensure liquidator is not user
    require liquidator != user;

    /// verify market integrity before starting
    require accrueInterest(e) == 0;

    require borrowIndex() >= one();
    principle, interestIndex = getUserBorrowSnapshot(user);

    require interestIndex <= borrowIndex();
    require interestIndex >= one();

    uint256 startingSharePrice = exchangeRateCurrent(e);

    fixUser(e, liquidator, user);

    assert exchangeRateCurrent(e) == startingSharePrice, "share price should not change fixing user";
}

rule repayBadDebtDecreasesBadDebt(env e, uint256 repayAmount) {
    require e.msg.sender != fixer;

    uint256 badDebt = badDebt();
    uint256 userBalance = token.balanceOf(e.msg.sender);
    uint256 mTokenBalance = token.balanceOf(fixer);
    uint256 startingSharePrice = exchangeRateCurrent(e);

    repayBadDebtWithCash(e, repayAmount);

    uint256 badDebtAfter = badDebt();

    assert repayAmount != 0 => badDebtAfter < badDebt, "bad debt did not decrease from repaying";
    assert badDebtAfter <= badDebt, "bad debt increased from repaying";
    assert to_mathint(token.balanceOf(fixer)) == mTokenBalance + repayAmount, "underlying balance did not increase";
    assert badDebt - repayAmount == to_mathint(badDebt()), "bad debt not decreased by repay amt";
    assert exchangeRateCurrent(e) == startingSharePrice, "share price should not change repaying bad debt";
}

/// TODO parametric rules for repayBadDebtWithReserves
