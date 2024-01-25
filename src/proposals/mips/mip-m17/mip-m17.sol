//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.19;

import "@forge-std/Test.sol";

import {IMErc20Delegator} from "@protocol/interfaces/IMErc20Delegator.sol";

import {Addresses} from "@forge-proposal-simulator/addresses/Addresses.sol";
import {GovernorBravoProposal} from "@forge-proposal-simulator/proposals/GovernorBravoProposal.sol";

contract mipm17 is GovernorBravoProposal {
    struct Debtors {
        address addr;
    }

    constructor() {}

    function name() public pure override returns (string memory) {
        return "MIP-M17";
    }

    function description() public view override returns (string memory) {
        return string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/MIP-M17.md")));
    }

    function _deploy(Addresses addresses, address) internal override {}

    function _afterDeploy(Addresses addresses, address deployer) internal override {}

    function _build(Addresses addresses) internal override {
        /// @dev mFRAX
        {
            string memory mFRAXDebtorsRaw = string(abi.encodePacked(vm.readFile("./mFRAX.json")));
            bytes memory mFRAXParsed = vm.parseJson(mFRAXDebtorsRaw);
            Debtors[] memory mFRAXDebtors = abi.decode(mFRAXParsed, (Debtors[]));

            IMErc20Delegator mFRAXMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mFRAX"));

            for (uint256 i = 0; i < mFRAXDebtors.length;) {
                uint256 balance = mFRAXMErc20Delegator.balanceOf(mFRAXDebtors[i].addr);
                _pushAction(
                    addresses.getAddress("MOONWELL_mFRAX"),
                    abi.encodeWithSignature(
                        "liquidateBorrow(address,uint256,address)",
                        mFRAXDebtors[i].addr,
                        balance,
                        addresses.getAddress("FRAX")
                    ),
                    "Liquidate mFRAX"
                );
                unchecked {
                    i++;
                }
            }
        }

        {
            /// @dev mxcDOT
            string memory mxcDOTDebtorsRaw = string(abi.encodePacked(vm.readFile("./mxcDOT.json")));
            bytes memory mxcDOTParsed = vm.parseJson(mxcDOTDebtorsRaw);
            Debtors[] memory mxcDOTDebtors = abi.decode(mxcDOTParsed, (Debtors[]));

            IMErc20Delegator mxcDOTMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mFRAX"));

            for (uint256 i = 0; i < mxcDOTDebtors.length;) {
                uint256 balance = mxcDOTMErc20Delegator.balanceOf(mxcDOTDebtors[i].addr);
                _pushAction(
                    addresses.getAddress("MOONWELL_mxcDOT"),
                    abi.encodeWithSignature(
                        "liquidateBorrow(address,uint256,address)",
                        mxcDOTDebtors[i].addr,
                        balance,
                        addresses.getAddress("xcDOT")
                    ),
                    "Liquidate mxcDOT"
                );
                unchecked {
                    i++;
                }
            }
        }

        /// @dev mUSDC.mad
        IMErc20Delegator mUSDCMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mUSDC"));
        uint256 mUSDCCash = mUSDCMErc20Delegator.getCash();

        _pushAction(
            addresses.getAddress("MOONWELL_mUSDC"),
            abi.encodeWithSignature(
                "transfer(address,uint256)", addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), mUSDCCash
            ),
            "Withdraw the underlying Nomad USDC"
        );

        /// @dev mETH.mad
        IMErc20Delegator mETHMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mETH"));
        uint256 mwETHCash = mETHMErc20Delegator.getCash();

        _pushAction(
            addresses.getAddress("MOONWELL_mETH"),
            abi.encodeWithSignature(
                "transfer(address,uint256)", addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), mwETHCash
            ),
            "Withdraw the underlying Nomad wETH"
        );

        /// @dev mwBTC.mad
        IMErc20Delegator mwBTCMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mwBTC"));
        uint256 mwBTCCash = mwBTCMErc20Delegator.getCash();

        _pushAction(
            addresses.getAddress("MOONWELL_mwBTC"),
            abi.encodeWithSignature(
                "transfer(address,uint256)", addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"), mwBTCCash
            ),
            "Withdraw the underlying Nomad wBTC"
        );
    }

    function _run(Addresses addresses, address) internal override {
        /// @dev set debug
        setDebug(true);

        _simulateActions(
            addresses.getAddress("MOONBEAM_TIMELOCK"),
            addresses.getAddress("ARTEMIS_GOVERNOR"),
            address(this)
        );
    }

    function _validate(Addresses addresses, address) internal override {
        /// @dev mFRAX
        {
            string memory mFRAXDebtorsRaw = string(abi.encodePacked(vm.readFile("./mFRAX.json")));
            bytes memory mFRAXParsed = vm.parseJson(mFRAXDebtorsRaw);
            Debtors[] memory mFRAXDebtors = abi.decode(mFRAXParsed, (Debtors[]));

            IMErc20Delegator mFRAXMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mFRAX"));

            for (uint256 i = 0; i < mFRAXDebtors.length;) {
                assertEq(mFRAXMErc20Delegator.balanceOf(mFRAXDebtors[i].addr), 0);
                unchecked {
                    i++;
                }
            }
        }

        {
            /// @dev mxcDOT
            string memory mxcDOTDebtorsRaw = string(abi.encodePacked(vm.readFile("./mxcDOT.json")));
            bytes memory mxcDOTParsed = vm.parseJson(mxcDOTDebtorsRaw);
            Debtors[] memory mxcDOTDebtors = abi.decode(mxcDOTParsed, (Debtors[]));

            IMErc20Delegator mxcDOTMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mFRAX"));

            for (uint256 i = 0; i < mxcDOTDebtors.length;) {
                assertEq(mxcDOTMErc20Delegator.balanceOf(mxcDOTDebtors[i].addr), 0);
                unchecked {
                    i++;
                }
            }
        }
    }
}
