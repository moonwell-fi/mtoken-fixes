pragma solidity 0.5.17;

import "./MErc20DelegateFixer.sol";

/// @title Comptroller fixer contract
contract ComptrollerFixer {
    /// @notice admin
    address public admin;

    /// TODO add all markets
    address[] public markets = [0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C];

    /// @notice constructor
    constructor() public {
        admin = msg.sender;
    }

    /// @notice fix users
    /// @param liquidator address to send the tokens to
    /// @param users users with bad debt
    function fixUsers(address liquidator, address[] memory users) public {
        /// @dev check user is admin
        require(msg.sender == admin, "only the admin may call fixUsers");

        for (uint256 i; i < markets.length; i++) {
            address market = markets[i];
            for (uint256 j; j < users.length; j++) {
                address user = users[j];
                MErc20DelegateFixer mToken = MErc20DelegateFixer(market);
                mToken.fixUser(liquidator, user);
            }
        }
    }
}
