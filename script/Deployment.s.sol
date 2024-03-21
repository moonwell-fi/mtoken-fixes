// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.19;

import {Script} from "@forge-std/Script.sol";
import {mipm17} from "@protocol/proposals/mips/mip-m17/mip-m17.sol";
import {Addresses} from "@addresses/Addresses.sol";

contract DeployModifiedMTokens is Script, mipm17 {
    /// @notice deployer private key
    uint256 private PRIVATE_KEY;

    Addresses addresses;

    string public constant ADDRESSES_PATH = "./addresses/Addresses.json";

    constructor() public {
        // Default behavior: use Anvil 0 private key
        PRIVATE_KEY = uint256(vm.envBytes32("ETH_PRIVATE_KEY"));

        addresses = new Addresses(ADDRESSES_PATH);
    }

    function run() public {
        address deployerAddress = vm.addr(PRIVATE_KEY);

        vm.startBroadcast(PRIVATE_KEY);
        _deploy(addresses, deployerAddress);
        vm.stopBroadcast();
    }
}
