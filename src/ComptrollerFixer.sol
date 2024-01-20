pragma solidity 0.5.17;

import "./Comptroller.sol";
import "./MErc20DelegateFixer.sol";

/// @title Comptroller fixer contract
contract ComptrollerFixer is Comptroller {
    /// TODO add all markets
    address[] public fixMarkets = [0x948CCfff51F894DBA5C250aa2844d58E169f8aD9];

    /// @notice fix users
    /// @param liquidator address to send the tokens to
    /// @param users users with bad debt
    function fixUsers(address liquidator, address[] memory users) public returns (uint256) {
        /// @dev check user is admin
        require(msg.sender == admin, "only the admin may call fixUsers");

        for (uint256 i; i < fixMarkets.length; i++) {
            address _market = fixMarkets[i];
            for (uint256 j; j < users.length; j++) {
                address user = users[j];
                MErc20DelegateFixer mToken = MErc20DelegateFixer(_market);
                mToken.fixUser(liquidator, user);
            }
        }
    }
}
