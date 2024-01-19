pragma solidity 0.5.17;

import "./MErc20.sol";

/**
 * @title Moonwell's MErc20Delegate Contract to sweep all nomad assets
 * @notice MTokens which wrap an EIP-20 underlying and are delegated to
 * @author Moonwell
 */
contract MErc20DelegateMadFixer is MErc20, MDelegateInterface {
    /**
     * @notice Construct an empty delegate
     */
    constructor() public {}

    /**
     * @notice Called by the delegator on a delegate to initialize it for duty
     * @param data The encoded bytes data for any initialization
     */
    function _becomeImplementation(bytes memory data) public {
        // Shh -- currently unused
        data;

        // Shh -- we don't ever want this hook to be marked pure
        if (false) {
            implementation = address(0);
        }

        require(msg.sender == admin, "only the admin may call _becomeImplementation");
    }

    /**
     * @notice Called by the delegator on a delegate to forfeit its responsibility
     */
    function _resignImplementation() public {
        // Shh -- we don't ever want this hook to be marked pure
        if (false) {
            implementation = address(0);
        }

        require(msg.sender == admin, "only the admin may call _resignImplementation");
    }

    /// @notice sweep all underlying collateral
    /// @param sweeper address of the sweeper (admin multisig?)
    function sweepAllCollateral(address sweeper) public {
        /// @dev checks
        require(msg.sender == admin, "only admin may sweep all collateral");

        uint amount = EIP20Interface(underlying).balanceOf(address(this));
        EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
        require(amount > 0, "balance must be greater than zero");

        /// @dev take it, take it all
        token.transferFrom(address(this), sweeper, amount);
    }
}
