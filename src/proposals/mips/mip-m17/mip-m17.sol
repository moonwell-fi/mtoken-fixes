//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.19;

import {Strings} from "@openzeppelin/utils/Strings.sol";

import "@forge-std/Test.sol";
import "@forge-std/console.sol";

import {Governor} from "@tests/integration/helpers/Governor.sol";
import {Addresses} from "@forge-proposal-simulator/addresses/Addresses.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";

interface Comptroller {
    function getAccountLiquidity(
        address account
    ) external view returns (uint, uint, uint);
}

contract mipm17 is Governor {
    /// @dev nomad balances
    uint256 public constant mwBTCCash = 4425696499;
    uint256 public constant mUSDCCash = 10789300371738;
    uint256 public constant mETHCash = 2269023468465447134524;

    /// @notice struct to read in JSON file
    struct Accounts {
        address addr;
    }

    function name() public pure override returns (string memory) {
        return "MIP-M17";
    }

    function description() public view override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    vm.readFile("./src/proposals/mips/mip-m17/MIP-M17.md")
                )
            );
    }

    function _deploy(Addresses addresses, address) internal override {
        address mErc20DelegateFixerAddress = deployCode(
            "MErc20DelegateFixer.sol:MErc20DelegateFixer"
        );
        addresses.addAddress(
            "MERC20_BAD_DEBT_DELEGATE_FIXER_LOGIC",
            mErc20DelegateFixerAddress
        );

        address mErc20DelegateMadFixerAddress = deployCode(
            "MErc20DelegateMadFixer.sol:MErc20DelegateMadFixer"
        );
        addresses.addAddress(
            "MERC20_DELEGATE_FIXER_NOMAD_LOGIC",
            mErc20DelegateMadFixerAddress
        );
    }

    function _build(Addresses addresses) internal override {
        address mErc20DelegateFixerAddress = addresses.getAddress(
            "MERC20_BAD_DEBT_DELEGATE_FIXER_LOGIC"
        );
        /// @dev set delegate for mFRAX
        _pushAction(
            addresses.getAddress("MOONWELL_mFRAX"),
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)",
                mErc20DelegateFixerAddress,
                false,
                new bytes(0)
            ),
            "Upgrade MErc20Delegate for mFRAX to MErc20DelegateFixer"
        );

        /// @dev set delegate for mxcDOT
        _pushAction(
            addresses.getAddress("MOONWELL_mxcDOT"),
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)",
                mErc20DelegateFixerAddress,
                false,
                new bytes(0)
            ),
            "Upgrade MErc20Delegate for mxcDOT to MErc20DelegateFixer"
        );

        address reallocationMultisig = addresses.getAddress(
            "NOMAD_REALLOCATION_MULTISIG"
        );
        /// @dev mFRAX
        {
            string memory debtorsRaw = string(
                abi.encodePacked(
                    vm.readFile("./src/proposals/mips/mip-m17/mFRAX.json")
                )
            );
            bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
            Accounts[] memory mFRAXDebtors = abi.decode(
                debtorsParsed,
                (Accounts[])
            );
            address mFRAXAddress = addresses.getAddress("MOONWELL_mFRAX");
            IMErc20Delegator mFRAXDelegator = IMErc20Delegator(mFRAXAddress);

            for (uint256 i = 0; i < mFRAXDebtors.length; i++) {
                if (mFRAXDelegator.balanceOf(mFRAXDebtors[i].addr) > 0) {
                    _pushAction(
                        mFRAXAddress,
                        abi.encodeWithSignature(
                            "fixUser(address,address)",
                            reallocationMultisig,
                            mFRAXDebtors[i].addr
                        ),
                        "Liquidate bad mFRAX debt for user: "
                    );
                }
            }
        }

        /// @dev xcDOT
        {
            string memory debtorsRaw = string(
                abi.encodePacked(
                    vm.readFile("./src/proposals/mips/mip-m17/mxcDOT.json")
                )
            );
            bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
            Accounts[] memory mxcDOTDebtors = abi.decode(
                debtorsParsed,
                (Accounts[])
            );
            address mxcDOTAddress = addresses.getAddress("MOONWELL_mxcDOT");
            IMErc20Delegator mxcDOTDelegator = IMErc20Delegator(mxcDOTAddress);

            for (uint256 i = 0; i < mxcDOTDebtors.length; i++) {
                if (mxcDOTDelegator.balanceOf(mxcDOTDebtors[i].addr) > 0) {
                    _pushAction(
                        mxcDOTAddress,
                        abi.encodeWithSignature(
                            "fixUser(address,address)",
                            reallocationMultisig,
                            mxcDOTDebtors[i].addr
                        ),
                        "Liquidate bad mxcDOT debt for user"
                    );
                }
            }
        }
        address mUSDCAddress = addresses.getAddress("MOONWELL_mUSDC");
        address mETHAddress = addresses.getAddress("MOONWELL_mETH");
        address mwBTCAddress = addresses.getAddress("MOONWELL_mwBTC");
        address mErc20DelegateMadFixerAddress = addresses.getAddress(
            "MERC20_DELEGATE_FIXER_NOMAD_LOGIC"
        );

        /// @dev mUSDC.mad
        _pushAction(
            mUSDCAddress,
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)",
                mErc20DelegateMadFixerAddress,
                false,
                new bytes(0)
            ),
            "Upgrade MErc20Delegate for mUSDC.mad to MErc20DelegateMadFixer"
        );

        _pushAction(
            mUSDCAddress,
            abi.encodeWithSignature("sweepAll(address)", reallocationMultisig),
            "Sweep all mUSDC.mad"
        );

        /// @dev mETH.mad
        _pushAction(
            mETHAddress,
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)",
                mErc20DelegateMadFixerAddress,
                false,
                new bytes(0)
            ),
            "Upgrade MErc20Delegate for mETH.mad to MErc20DelegateMadFixer"
        );

        _pushAction(
            mETHAddress,
            abi.encodeWithSignature("sweepAll(address)", reallocationMultisig),
            "Sweep all mETH.mad"
        );

        /// @dev mwBTC.mad
        _pushAction(
            mwBTCAddress,
            abi.encodeWithSignature(
                "_setImplementation(address,bool,bytes)",
                mErc20DelegateMadFixerAddress,
                false,
                new bytes(0)
            ),
            "Upgrade MErc20Delegate for mwBTC.mad to MErc20DelegateMadFixer"
        );

        _pushAction(
            mwBTCAddress,
            abi.encodeWithSignature("sweepAll(address)", reallocationMultisig),
            "Sweep all mwBTC.mad"
        );
    }

    function _run(Addresses addresses, address) internal override {
        /// @dev set debug
        // setDebug(true);

        uint256 gas_start = gasleft();
        simulateActions(
            addresses.getAddress("ARTEMIS_GOVERNOR"),
            addresses.getAddress("WELL"),
            address(this)
        );
        uint256 gas_used = gas_start - gasleft();

        emit log_named_uint("Gas Metering", gas_used);
    }

    function _validate(Addresses addresses, address) internal override {
        /// @dev check debtors have had their debt zeroed
        {
            Comptroller comptroller = Comptroller(
                addresses.getAddress("UNITROLLER")
            );
            string memory debtorsRaw = string(
                abi.encodePacked(
                    vm.readFile("./src/proposals/mips/mip-m17/mFRAX.json")
                )
            );
            bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
            Accounts[] memory debtors = abi.decode(debtorsParsed, (Accounts[]));

            IMErc20Delegator mErc20Delegator = IMErc20Delegator(
                addresses.getAddress("MOONWELL_mFRAX")
            );

            IMErc20Delegator mErc20DelegatorxcDot = IMErc20Delegator(
                addresses.getAddress("MOONWELL_mxcDOT")
            );
            for (uint256 i = 0; i < debtors.length; i++) {
                (uint256 err, , ) = comptroller.getAccountLiquidity(
                    debtors[i].addr
                );

                /// not an invariant because the mglimmer market still has bad debt
                // assertEq(
                //     shortfall,
                //     0,
                //     string(
                //         abi.encodePacked(
                //             "bad debt not cleared for account: ",
                //             Strings.toHexString(debtors[i].addr)
                //         )
                //     )
                // );
                assertEq(
                    err,
                    0,
                    string(
                        abi.encodePacked(
                            "error code getting liquidity for account: ",
                            Strings.toHexString(debtors[i].addr)
                        )
                    )
                );
                assertEq(
                    mErc20Delegator.balanceOf(debtors[i].addr),
                    0,
                    "mfrax balance after seizing"
                );
                assertEq(
                    mErc20DelegatorxcDot.balanceOf(debtors[i].addr),
                    0,
                    "mxcDOT balance after seizing"
                );
            }
        }

        {
            string memory debtorsRaw = string(
                abi.encodePacked(
                    vm.readFile("./src/proposals/mips/mip-m17/mxcDOT.json")
                )
            );
            bytes memory debtorsParsed = vm.parseJson(debtorsRaw);
            Accounts[] memory debtors = abi.decode(debtorsParsed, (Accounts[]));

            IMErc20Delegator mErc20Delegator = IMErc20Delegator(
                addresses.getAddress("MOONWELL_mxcDOT")
            );
            for (uint256 i = 0; i < debtors.length; i++) {
                assertEq(mErc20Delegator.balanceOf(debtors[i].addr), 0);
            }
        }
        IMErc20Delegator mUSDCMErc20Delegator = IMErc20Delegator(
            addresses.getAddress("MOONWELL_mUSDC")
        );
        IMErc20Delegator mETHMErc20Delegator = IMErc20Delegator(
            addresses.getAddress("MOONWELL_mETH")
        );
        IMErc20Delegator mwBTCMErc20Delegator = IMErc20Delegator(
            addresses.getAddress("MOONWELL_mwBTC")
        );
        address reallocationMultisig = addresses.getAddress(
            "NOMAD_REALLOCATION_MULTISIG"
        );

        /// @dev check that the Nomad assets have been swept
        assertEq(
            mUSDCMErc20Delegator.balanceOf(reallocationMultisig),
            mUSDCCash
        );
        assertEq(mUSDCMErc20Delegator.balance(), 0);

        assertEq(mETHMErc20Delegator.balanceOf(reallocationMultisig), mETHCash);
        assertEq(mETHMErc20Delegator.balance(), 0);

        assertEq(
            mwBTCMErc20Delegator.balanceOf(reallocationMultisig),
            mwBTCCash
        );
        assertEq(mwBTCMErc20Delegator.balance(), 0);
    }
}
