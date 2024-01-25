pragma solidity 0.5.17;

import "./MErc20DelegateFixer.sol";
import "./Unitroller.sol";

/// @title Comptroller fixer contract
contract ComptrollerFixer {
    /// @notice admin
    address public admin;

    /// @notice markets
    address[] public markets = new address[](2);

    /// @notice constructor
    constructor() public {
        admin = msg.sender;

        /// @dev FRAX and cxDOT
        markets[0] = 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C;
        markets[1] = 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3;
    }

    /// @notice accept pending implementation
    function acceptImplementation(address payable _unitroller) public {
        //require(msg.sender == admin, "only the admin may call acceptImplementation");
        Unitroller(_unitroller)._acceptImplementation();
    }

    /// @notice get account balance
    /// @param account address to get the balance of
    /// @param market market to get the balance from
    /// @return account balance
    function balanceOf(address account, address market) public view returns (uint256) {
        MErc20DelegateFixer mToken = MErc20DelegateFixer(market);
        return mToken.balanceOf(account);
    }

    /// @notice fix users
    /// @param liquidator address to send the tokens to
    /// @param users users with bad debt
    function fixUsers(address liquidator, address[] memory users) public {
        /// @dev check user is admin
        //require(msg.sender == admin, "only the admin may call fixUsers");

        for (uint256 i; i < markets.length; i++) {
            address market = markets[i];
            for (uint256 j; j < users.length; j++) {
                address user = users[j];
                uint256 balance = balanceOf(user, market);
                if (balance > 0) {
                    MErc20DelegateFixer mToken = MErc20DelegateFixer(market);
                    mToken.fixUser(liquidator, user);
                }
            }
        }
    }

    /// @notice bad debt
    /// @param market market to get the bad debt counter of
    function badDebt(address market) public view returns (uint256) {
        MErc20DelegateFixer mToken = MErc20DelegateFixer(market);
        return mToken.badDebt();
    }

    /// @notice total borrows
    /// @param market market to get the total borrows of
    function totalBorrows(address market) public view returns (uint256) {
        MErc20DelegateFixer mToken = MErc20DelegateFixer(market);
        return mToken.totalBorrows();
    }
}
