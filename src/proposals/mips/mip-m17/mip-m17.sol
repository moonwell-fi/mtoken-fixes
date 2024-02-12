//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.19;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {Governor} from "@tests/integration/helpers/Governor.sol";
import {CreateCode} from "@protocol/proposals/utils/CreateCode.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";

import {Addresses} from "@forge-proposal-simulator/addresses/Addresses.sol";

contract mipm17 is Governor {
    /// @dev addresses
    address mFRAXAddress;
    address mxcDOTAddress;
    address mUSDCAddress;
    address mETHAddress;
    address mwBTCAddress;
    address mErc20DelegateFixerAddress;
    address mErc20DelegateMadFixerAddress;
    address reallocationMultisig;

    /// @dev delegators
    IMErc20Delegator mFRAXDelegator;
    IMErc20Delegator mxcDOTDelegator;
    IMErc20Delegator mUSDCMErc20Delegator;
    IMErc20Delegator mETHMErc20Delegator;
    IMErc20Delegator mwBTCMErc20Delegator;

    /// @dev nomad balances
    uint256 mUSDCCash;
    uint256 mETHCash;
    uint256 mwBTCCash;

    /// @dev accounts
    struct Accounts {
        address addr;
    }

    /// @dev map to store healthy user balances
    mapping(address market => mapping(address account => uint256 balance)) balances;

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

    function _afterDeploy(Addresses addresses, address deployer) internal override {
        mFRAXAddress = addresses.getAddress("MOONWELL_mFRAX");
        mxcDOTAddress = addresses.getAddress("MOONWELL_mxcDOT");
        mUSDCAddress = addresses.getAddress("MOONWELL_mUSDC");
        mETHAddress = addresses.getAddress("MOONWELL_mETH");
        mwBTCAddress = addresses.getAddress("MOONWELL_mwBTC");
        reallocationMultisig = addresses.getAddress("NOMAD_REALLOCATION_MULTISIG");

        mFRAXDelegator = IMErc20Delegator(mFRAXAddress);
        mxcDOTDelegator = IMErc20Delegator(mxcDOTAddress);

        /// @dev nomad balances should be constant
        mUSDCCash = 10789300371738;
        mETHCash = 2269023468465447134524;
        mwBTCCash = 4425696499;
        mUSDCMErc20Delegator = IMErc20Delegator(mUSDCAddress);
        mETHMErc20Delegator = IMErc20Delegator(mETHAddress);
        mwBTCMErc20Delegator = IMErc20Delegator(mwBTCAddress);

        // string memory raw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/healthy.json")));
        // bytes memory parsed = vm.parseJson(raw);
        // Accounts[] memory accounts = abi.decode(parsed, (Accounts[]));

        // for (uint256 i = 0; i < accounts.length; i++) {
        //     balances[mFRAXAddress][accounts[i].addr] = mFRAXDelegator.balanceOf(accounts[i].addr);
        //     balances[mxcDOTAddress][accounts[i].addr] = mxcDOTDelegator.balanceOf(accounts[i].addr);
        // }
    }

    function _build(Addresses addresses) internal override {
        /// @dev set delegate for mFRAX
        _pushAction(
            mFRAXAddress,
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)", mErc20DelegateFixerAddress, false, new bytes(0)
            ),
            "Upgrade MErc20Delegate for mFRAX to MErc20DelegateFixer"
        );

        /// @dev set delegate for mxcDOT
        _pushAction(
            mxcDOTAddress,
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)", mErc20DelegateFixerAddress, false, new bytes(0)
            ),
            "Upgrade MErc20Delegate for mxcDOT to MErc20DelegateFixer"
        );

        /// @dev mFRAX
        {
            string memory debtorsRaw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/mFRAX.json")));
            bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
            Accounts[] memory mFRAXDebtors = abi.decode(debtorsParsed, (Accounts[]));

            for (uint256 i = 0; i < mFRAXDebtors.length; i++) {
                if (mFRAXDelegator.balanceOf(mFRAXDebtors[i].addr) > 0) {
                    _pushAction(
                        mFRAXAddress,
                        abi.encodeWithSignature("fixUser(address,address)", reallocationMultisig, mFRAXDebtors[i].addr),
                        string(abi.encodePacked("Liquidate bad mFRAX debt for user: ", mFRAXDebtors[i].addr))
                    );
                }
            }
        }

        /// @dev xcDOT
        {
            string memory debtorsRaw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/mxcDOT.json")));
            bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
            Accounts[] memory mxcDOTDebtors = abi.decode(debtorsParsed, (Accounts[]));

            for (uint256 i = 0; i < mxcDOTDebtors.length; i++) {
                if (mxcDOTDelegator.balanceOf(mxcDOTDebtors[i].addr) > 0) {
                    _pushAction(
                        mxcDOTAddress,
                        abi.encodeWithSignature("fixUser(address,address)", reallocationMultisig, mxcDOTDebtors[i].addr),
                        string(abi.encodePacked("Liquidate bad mxcDOT debt for user: ", mxcDOTDebtors[i].addr))
                    );
                }
            }
        }

        /// @dev mUSDC.mad
        _pushAction(
            mUSDCAddress,
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)", mErc20DelegateMadFixerAddress, false, new bytes(0)
            ),
            "Upgrade MErc20Delegate for mUSDC.mad to MErc20DelegateMadFixer"
        );

        _pushAction(
            mUSDCAddress, abi.encodeWithSignature("sweepAll(address)", reallocationMultisig), "Sweep all mUSDC.mad"
        );

        /// @dev mETH.mad
        _pushAction(
            mETHAddress,
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)", mErc20DelegateMadFixerAddress, false, new bytes(0)
            ),
            "Upgrade MErc20Delegate for mETH.mad to MErc20DelegateMadFixer"
        );

        _pushAction(
            mETHAddress, abi.encodeWithSignature("sweepAll(address)", reallocationMultisig), "Sweep all mETH.mad"
        );

        /// @dev mwBTC.mad
        _pushAction(
            mwBTCAddress,
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)", mErc20DelegateMadFixerAddress, false, new bytes(0)
            ),
            "Upgrade MErc20Delegate for mwBTC.mad to MErc20DelegateMadFixer"
        );

        _pushAction(
            mwBTCAddress, abi.encodeWithSignature("sweepAll(address)", reallocationMultisig), "Sweep all mwBTC.mad"
        );
    }

    function _run(Addresses addresses, address) internal override {
        /// @dev set debug
        setDebug(true);

        uint256 gas_start = gasleft();
        simulateActions(addresses.getAddress("ARTEMIS_GOVERNOR"), addresses.getAddress("WELL"), address(this));
        uint256 gas_used = gas_start - gasleft();

        emit log_named_uint("Gas Metering", gas_used);
    }

    function _validate(Addresses addresses, address) internal override {
        // string memory raw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/healthy.json")));
        // bytes memory parsed = vm.parseJson(raw);
        // Accounts[] memory accounts = abi.decode(parsed, (Accounts[]));

        // for (uint256 i = 0; i < accounts.length; i++) {
        //     assertEq(balances[mFRAXAddress][accounts[i].addr], mFRAXDelegator.balanceOf(accounts[i].addr));
        //     assertEq(balances[mxcDOTAddress][accounts[i].addr], mxcDOTDelegator.balanceOf(accounts[i].addr));
        // }

        /// @dev check debtors have had their debt zeroed
        {
            string memory debtorsRaw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/mFRAX.json")));
            bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
            Accounts[] memory debtors = abi.decode(debtorsParsed, (Accounts[]));

            IMErc20Delegator mErc20Delegator = IMErc20Delegator(mFRAXAddress);
            for (uint256 i = 0; i < debtors.length; i++) {
                assertEq(mErc20Delegator.balanceOf(debtors[i].addr), 0);
            }
        }

        {
            string memory debtorsRaw = string(abi.encodePacked(vm.readFile("./src/proposals/mips/mip-m17/mxcDOT.json")));
            bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
            Accounts[] memory debtors = abi.decode(debtorsParsed, (Accounts[]));

            IMErc20Delegator mErc20Delegator = IMErc20Delegator(mxcDOTAddress);
            for (uint256 i = 0; i < debtors.length; i++) {
                assertEq(mErc20Delegator.balanceOf(debtors[i].addr), 0);
            }
        }

        /// @dev check that the Nomad assets have been swept
        assertEq(mUSDCMErc20Delegator.balanceOf(reallocationMultisig), mUSDCCash);
        assertEq(mUSDCMErc20Delegator.balance(), 0);

        assertEq(mETHMErc20Delegator.balanceOf(reallocationMultisig), mETHCash);
        assertEq(mETHMErc20Delegator.balance(), 0);

        assertEq(mwBTCMErc20Delegator.balanceOf(reallocationMultisig), mwBTCCash);
        assertEq(mwBTCMErc20Delegator.balance(), 0);
    }
}
