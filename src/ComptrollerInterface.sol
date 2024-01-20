pragma solidity 0.5.17;

contract ComptrollerInterface {
    /// @notice Indicator that this is a Comptroller contract (for inspection)
    bool public constant isComptroller = true;

    /// @notice The amount of gas to use when making a native asset transfer.
    uint16 public gasAmount;

    /**
     * Assets You Are In **
     */
    function enterMarkets(address[] calldata mTokens) external returns (uint256[] memory);
    function exitMarket(address mToken) external returns (uint256);

    /**
     * Policy Hooks **
     */
    function mintAllowed(address mToken, address minter, uint256 mintAmount) external returns (uint256);
    function mintVerify(address mToken, address minter, uint256 mintAmount, uint256 mintTokens) external;

    function redeemAllowed(address mToken, address redeemer, uint256 redeemTokens) external returns (uint256);
    function redeemVerify(address mToken, address redeemer, uint256 redeemAmount, uint256 redeemTokens) external;

    function borrowAllowed(address mToken, address borrower, uint256 borrowAmount) external returns (uint256);
    function borrowVerify(address mToken, address borrower, uint256 borrowAmount) external;

    function repayBorrowAllowed(address mToken, address payer, address borrower, uint256 repayAmount)
        external
        returns (uint256);
    function repayBorrowVerify(
        address mToken,
        address payer,
        address borrower,
        uint256 repayAmount,
        uint256 borrowerIndex
    ) external;

    function liquidateBorrowAllowed(
        address mTokenBorrowed,
        address mTokenCollateral,
        address liquidator,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256);
    function liquidateBorrowVerify(
        address mTokenBorrowed,
        address mTokenCollateral,
        address liquidator,
        address borrower,
        uint256 repayAmount,
        uint256 seizeTokens
    ) external;

    function seizeAllowed(
        address mTokenCollateral,
        address mTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external returns (uint256);
    function seizeVerify(
        address mTokenCollateral,
        address mTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external;

    function transferAllowed(address mToken, address src, address dst, uint256 transferTokens)
        external
        returns (uint256);
    function transferVerify(address mToken, address src, address dst, uint256 transferTokens) external;

    /**
     * Liquidity/Liquidation Calculations **
     */
    function liquidateCalculateSeizeTokens(address mTokenBorrowed, address mTokenCollateral, uint256 repayAmount)
        external
        view
        returns (uint256, uint256);
}
