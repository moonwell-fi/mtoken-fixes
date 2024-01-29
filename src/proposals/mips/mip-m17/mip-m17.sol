//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {CreateCode} from "@protocol/proposals/utils/CreateCode.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";

import {Addresses} from "@forge-proposal-simulator/addresses/Addresses.sol";
import {GovernorBravoProposal} from "@forge-proposal-simulator/proposals/GovernorBravoProposal.sol";

contract mipm17 is GovernorBravoProposal {
    /// @dev addresses
    address mErc20DelegateFixerAddress;
    address mErc20DelegateMadFixerAddress;

    /// @dev delegators
    IMErc20Delegator mFRAXDelegator;
    IMErc20Delegator mxcDOTDelegator;

    /// @dev exchange rates
    uint256 mFRAXExchangeRate;
    uint256 mxcDOTExchangeRate;

    /// @dev debtors list
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

    function _deploy(Addresses addresses, address) internal override {
        CreateCode createCode = new CreateCode();

        bytes memory mErc20DelegateFixerCode = createCode.getCode("MErc20DelegateFixer.sol");
        mErc20DelegateFixerAddress = createCode.deployCode(mErc20DelegateFixerCode);

        bytes memory mErc20DelegateMadFixerCode = createCode.getCode("MErc20DelegateMadFixer.sol");
        mErc20DelegateMadFixerAddress = createCode.deployCode(mErc20DelegateMadFixerCode);
    }

    function _afterDeploy(Addresses addresses, address deployer) internal override {}

    function _build(Addresses addresses) internal override {
        /// @dev set delegate for mFRAX
        _pushAction(
            addresses.getAddress("MOONWELL_mFRAX"),
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)", mErc20DelegateFixerAddress, false, new bytes(0)
            ),
            "Upgrade MErc20Delegate for mFRAX"
        );

        // /// @dev set delegate for mxcDOT
        // _pushAction(
        //     addresses.getAddress("MOONWELL_mxcDOT"),
        //     abi.encodeWithSignature(
        //         "_setImplementation(address,bool,bytes)", mErc20DelegateFixerAddress, false, new bytes(0)
        //     ),
        //     "Upgrade MErc20Delegate for mxcDOT"
        // );

        /// @dev mFRAX
        {
            /// TODO replace the file with the full user list
            string memory debtorsRaw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/mFRAX.json")));
            bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
            Debtors[] memory mFRAXDebtors = abi.decode(debtorsParsed, (Debtors[]));

            mFRAXDelegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mFRAX"));
            mFRAXExchangeRate = mFRAXDelegator.exchangeRateStored();

            for (uint256 i = 0; i < mFRAXDebtors.length; i++) {
                _pushAction(
                    addresses.getAddress("MOONWELL_mFRAX"),
                    abi.encodeWithSignature(
                        "fixUser(address,address)",
                        addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"),
                        mFRAXDebtors[i].addr
                    ),
                    "Liquidate bad mFRAX debt"
                );
            }
        }

        // /// @dev xcDOT
        // {
        //     /// TODO replace the file with the full user list
        //     string memory debtorsRaw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/mxcDOT.json")));
        //     bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
        //     Debtors[] memory mxcDOTDebtors = abi.decode(debtorsParsed, (Debtors[]));

        //     mxcDOTDelegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mxcDOT"));
        //     mxcDOTExchangeRate = mxcDOTDelegator.exchangeRateStored();

        //     for (uint256 i = 0; i < mxcDOTDebtors.length; i++) {
        //         _pushAction(
        //             addresses.getAddress("MOONWELL_mxcDOT"),
        //             abi.encodeWithSignature(
        //                 "fixUser(address,address)",
        //                 addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"),
        //                 mxcDOTDebtors[i].addr
        //             ),
        //             "Liquidate bad mxcDOT debt"
        //         );
        //     }
        // }

        /// @dev mUSDC.mad
        _pushAction(
            addresses.getAddress("MOONWELL_mUSDC"),
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)", mErc20DelegateMadFixerAddress, false, new bytes(0)
            ),
            "Upgrade MErc20Delegate for mUSDC.mad"
        );

        _pushAction(
            addresses.getAddress("MOONWELL_mUSDC"),
            abi.encodeWithSignature("sweepAll(address)", addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")),
            "Sweep all mUSDC.mad"
        );

        /// @dev mETH.mad
        _pushAction(
            addresses.getAddress("MOONWELL_mETH"),
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)", mErc20DelegateMadFixerAddress, false, new bytes(0)
            ),
            "Upgrade MErc20Delegate for mETH.mad"
        );

        _pushAction(
            addresses.getAddress("MOONWELL_mETH"),
            abi.encodeWithSignature("sweepAll(address)", addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")),
            "Sweep all mETH.mad"
        );

        /// @dev mwBTC.mad
        _pushAction(
            addresses.getAddress("MOONWELL_mwBTC"),
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)", mErc20DelegateMadFixerAddress, false, new bytes(0)
            ),
            "Upgrade MErc20Delegate for mwBTC.mad"
        );

        _pushAction(
            addresses.getAddress("MOONWELL_mwBTC"),
            abi.encodeWithSignature("sweepAll(address)", addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")),
            "Sweep all mwBTC.mad"
        );
    }

    function _run(Addresses addresses, address) internal override {
        /// @dev set debug
        setDebug(true);

        _simulateActions(addresses.getAddress("ARTEMIS_GOVERNOR"), addresses.getAddress("WELL"), address(this));
    }

    function _validate(Addresses addresses, address) internal override {
        /// @dev check exchange rates
        assertEq(mFRAXDelegator.exchangeRateStored(), mFRAXExchangeRate);
        //assertEq(mxcDOTDelegator.exchangeRateStored(), mxcDOTExchangeRate);

        /// @dev check debtors have had their debt zeroed
        {
            string memory debtorsRaw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/mFRAX.json")));
            bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
            Debtors[] memory mFRAXDebtors = abi.decode(debtorsParsed, (Debtors[]));

            IMErc20Delegator mErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mFRAX"));
            for (uint256 i = 0; i < mFRAXDebtors.length; i++) {
                assertEq(mErc20Delegator.balanceOf(mFRAXDebtors[i].addr), 0);
            }
        }

        // {
        //     string memory debtorsRaw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/mxcDOT.json")));
        //     bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
        //     Debtors[] storage mxcDOTDebtors = abi.decode(debtorsParsed, (Debtors[]));

        //     IMErc20Delegator mErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mxcDOT"));
        //     for (uint256 i = 0; i < mxcDOTDebtors.length; i++) {
        //         assertEq(mErc20Delegator.balanceOf(mxcDOTDebtors[i].addr), 0);
        //     }
        // }

        /// @dev check that the Nomad assets have been swept
        IMErc20Delegator mUSDCMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mUSDC"));
        uint256 mUSDCCash = mUSDCMErc20Delegator.getCash();

        assertEq(mUSDCMErc20Delegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 10789307515125);
        assertEq(mUSDCCash, 0);

        IMErc20Delegator mETHMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mETH"));
        uint256 mETHCash = mETHMErc20Delegator.getCash();

        assertEq(
            mETHMErc20Delegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 2269023468465447134524
        );
        assertEq(mETHCash, 0);

        IMErc20Delegator mwBTCMErc20Delegator = IMErc20Delegator(addresses.getAddress("MOONWELL_mwBTC"));
        uint256 mwBTCCash = mwBTCMErc20Delegator.getCash();

        assertEq(mwBTCMErc20Delegator.balanceOf(addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")), 4425696279);
        assertEq(mwBTCCash, 0);
    }
}
