// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.19;

import {Test} from "@forge-std/Test.sol";
import {Script} from "@forge-std/Script.sol";

import {Addresses} from "@addresses/Addresses.sol";
import {IComptroller} from "@protocol/Interfaces/IComptroller.sol";

/// local:
///     forge script script/RewardClaim.s.sol:RewardClaim --fork-url moonbeam
/// broadcast:
///     forge script script/RewardClaim.s.sol:RewardClaim --fork-url moonbeam --broadcast
contract RewardClaim is Test, Script {
    /// @notice rewards paid in WELL
    uint8 public constant rewardTypeWell = 0;

    /// @notice rewards paid in GLMR
    uint8 public constant rewardTypeGlmr = 1;

    /// @notice list of users to pay out rewards
    address[] public toReward = [
        0xE0B2026E3DB1606ef0Beb764cCdf7b3CEE30Db4A,
        0xcCb8E090Fe070945cC0131a075B6e1EA8F208812,
        0x7ecf0bF3D94dce4838d57B63dc96d6DDc2CC63e7,
        0x6A67a0e5265730952Ed7dD648Aed357c7444999e,
        0xAaDDC55883b7DF9944D54C20f2822f476673cBC0,
        0x7C976f00E84Db0b44F945fC6d7faD34B43150a1A,
        0x4F5ef03E870332A1B42453bBf57B8A041E89eFe8,
        0xA89Da48796bB808cb9aF3637ff7AB436f968C7d5,
        0x54dC6782d6fC5FC05f8486d365186FF25CC44BA7,
        0x395Ef2d7a5D499B62Ac479064B7eAa51ae823A22,
        0xf4f1F5Dd2801f94b732D240a46103089905cCd4e,
        0x9F6dC2Cf76fD22A0e5F11e0EDDe73502364FFBb8,
        0x57e421c8a16bf0A609ef87E296CB931113a5e3ED,
        0x60298D41CEF0759F1127Fc5e48Ba3B663A9e0889,
        0xa3dB05c72c79d52D2D37170A342a2c21c5e5d7C0,
        0xd4D70647651e84536eB218D5889aB764115c4d82,
        0xDD15c08320F01F1b6348b35EeBe29fDB5ca0cDa6,
        0xCbc21Fbf92519f6D90C05a6FDA1a7cb72FA6E02b,
        0x6722Ae8C7a49553f1a80153517d1cfeCa7EcA5F7,
        0x99b84a77f64e5acc269073cf082951C3CE57fe64,
        0xF98A854bc00eAa854894d79e11315A2114C58120,
        0x175A795ef04bc146fd6D6F852e5adeC8B356e310,
        0x51D7193812B5B70e5E30DF5C18ac2062C5F51c5E,
        0xC265bA4D9eD33620978b03235fC9f5AA026da275,
        0x3A531c90e52a02817c0D31794D0ac4eA35a66602,
        0x1fB540757cfd698B4a8f81E510ed09Aa67a4F970,
        0x396a6D7a33655c45044143CB8A812227bf279578,
        0x1f93DC0E5f249C8961027D447C973B9Ce7ab7366,
        0xd2dfF7007586BE8f2E6CB84DE65190B81aDF6A9B,
        0x985C3e74201d8C4907E7d8db06bb1F83639BEF0c,
        0x8DFD78676FA1929D1C7B64Fbd3133e3B4Ec305B3,
        0xDC7428eeFf0CDAc1A45f310DEBB9AF91708F47C9,
        0x08c3e7B6e273d4434Fa466Ff23dba7c602A961a7,
        0xF9923Ae543F039c71CD1Bbc95Ee3dB6F36aFcce6,
        0x3769859A5eFA6133Cd74c5eb5080F46bEFfB6Cef,
        0xB3E6420941AcC44C2996666b4B5C998C1545fc19
    ];

    function run() public {
        Addresses addresses = new Addresses("./addresses/addresses.json");
        IComptroller comptroller = IComptroller(
            addresses.getAddress("UNITROLLER")
        );

        address[] memory mTokens = new address[](2);
        mTokens[0] = addresses.getAddress("MOONWELL_mxcDOT");
        mTokens[1] = addresses.getAddress("MOONWELL_mFRAX");

        vm.startBroadcast(uint256(vm.envBytes32("ETH_PRIVATE_KEY")));

        /// claim both WELL and GLMR rewards
        for (uint256 i = 0; i < toReward.length; i++) {
            comptroller.claimReward(rewardTypeWell, toReward[i], mTokens);
            comptroller.claimReward(rewardTypeGlmr, toReward[i], mTokens);
        }

        vm.stopBroadcast();
    }
}
