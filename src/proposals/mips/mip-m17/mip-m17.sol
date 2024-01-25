//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.19;

import "@forge-std/Test.sol";

import {CreateCode} from "@protocol/proposals/utils/CreateCode.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";
// import {MErc20DelegateMadFixer} from "@protocol/MErc20DelegateMadFixer.sol";

import {Addresses} from "@forge-proposal-simulator/addresses/Addresses.sol";
import {GovernorBravoProposal} from "@forge-proposal-simulator/proposals/GovernorBravoProposal.sol";

contract mipm17 is GovernorBravoProposal {
    /// @dev addresses
    address comptrollerFixerAddress;
    address mErc20DelegateFixerAddress;
    address mErc20DelegateMadFixerAddress;

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

        bytes memory comptrollerFixerCode = createCode.getCode("ComptrollerFixer.sol");
        comptrollerFixerAddress = createCode.deployCode(comptrollerFixerCode);

        bytes memory mErc20DelegateFixerCode = createCode.getCode("MErc20DelegateFixer.sol");
        mErc20DelegateFixerAddress = createCode.deployCode(mErc20DelegateFixerCode);

        bytes memory mErc20DelegateMadFixerCode = createCode.getCode("MErc20DelegateMadFixer.sol");
        mErc20DelegateMadFixerAddress = createCode.deployCode(mErc20DelegateMadFixerCode);
    }

    function _afterDeploy(Addresses addresses, address deployer) internal override {}

    function _build(Addresses addresses) internal override {
        /// @dev set pending comptroller implementation
        _pushAction(
            addresses.getAddress("UNITROLLER"),
            abi.encodeWithSignature(
                "_setPendingImplementation(address)", comptrollerFixerAddress
            )
        );

        /// @dev accept comptroller implementation
        _pushAction(
            comptrollerFixerAddress,
            abi.encodeWithSignature(
                "acceptImplementation(address)", addresses.getAddress("UNITROLLER")
            )
        );

        /// @dev set delegate for mFRAX
        _pushAction(
            addresses.getAddress("MOONWELL_mFRAX"),
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)", mErc20DelegateFixerAddress, false, new bytes(0)
            ),
            "Upgrade MErc20Delegate for mFRAX"
        );

        /// @dev set delegate for mxcDOT
        _pushAction(
            addresses.getAddress("MOONWELL_mxcDOT"),
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)", mErc20DelegateFixerAddress, false, new bytes(0)
            ),
            "Upgrade MErc20Delegate for mxcDOT"
        );

        /// @dev mFRAX
        {
            string memory debtorsRaw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/mFRAX.json")));
            bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
            Debtors[] memory debtors = abi.decode(debtorsParsed, (Debtors[]));

            uint256 debtorsCount = debtors.length;
            address[] memory debtorsList = new address[](debtorsCount);

            for (uint256 i = 0; i < debtorsCount;) {
                debtorsList[i] = debtors[i].addr;
                unchecked {
                    i++;
                }
            }

            _pushAction(
                comptrollerFixerAddress,
                abi.encodeWithSignature(
                        "fixUsers(address,address[])",
                        addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"),
                        debtorsList
                    ),
                    "Liquidate bad mFRAX debt"
                );
        }

        /// @dev xcDOT
        {
            string memory debtorsRaw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/mxcDOT.json")));
            bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
            Debtors[] memory debtors = abi.decode(debtorsParsed, (Debtors[]));

            uint256 debtorsCount = debtors.length;
            address[] memory debtorsList = new address[](debtorsCount);

            for (uint256 i = 0; i < debtorsCount;) {
                debtorsList[i] = debtors[i].addr;
                unchecked {
                    i++;
                }
            }

            _pushAction(
                comptrollerFixerAddress,
                abi.encodeWithSignature(
                        "fixUsers(address,address[])",
                        addresses.getAddress("NOMAD_REALLOCATION_MULTISIG"),
                        debtorsList
                    ),
                    "Liquidate bad mxcDOT debt"
                );
        }

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
            abi.encodeWithSignature(
                "sweepAll(address)", addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")
            ),
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
            abi.encodeWithSignature(
                "sweepAll(address)", addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")
            ),
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
            abi.encodeWithSignature(
                "sweepAll(address)", addresses.getAddress("NOMAD_REALLOCATION_MULTISIG")
            ),
            "Sweep all mwBTC.mad"
        );
    }

    function _run(Addresses addresses, address) internal override {
        /// @dev set debug
        setDebug(true);

        _simulateActions(
            addresses.getAddress("ARTEMIS_GOVERNOR"), addresses.getAddress("WELL"), address(this)
        );
    }

    function _validate(Addresses addresses, address) internal override {}
}
