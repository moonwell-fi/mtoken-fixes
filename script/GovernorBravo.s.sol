pragma solidity ^0.8.0;

import {Constants} from "@utils/Constants.sol";
import {ScriptSuite} from "@script/ScriptSuite.s.sol";

import {mipm17} from "@protocol/proposals/mips/mip-m17/mip-m17.sol";

// @dev Use this script to simulates or run a single proposal
// Use this as a template to create your own script
// `forge script script/GovernorBravo.s.sol:GovernorBravoScript -vvvv --rpc-url {rpc} --broadcast --verify --etherscan-api-key {key}`
contract GovernorBravoScript is ScriptSuite {
    string public constant ADDRESSES_PATH = "./addresses/Addresses.json";

    constructor() ScriptSuite(ADDRESSES_PATH, new mipm17()) {}

    function run() public override {
        /// @dev Execute proposal
        proposal.setDebug(true);
        super.run();
    }
}
