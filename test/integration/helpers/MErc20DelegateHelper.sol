pragma solidity 0.8.19;

import "@forge-std/Test.sol";

import {IMToken} from "@protocol/Interfaces/IMToken.sol";
import {IComptroller} from "@protocol/Interfaces/IComptroller.sol";
import {IMErc20Delegator} from "@protocol/Interfaces/IMErc20Delegator.sol";

import {IERC20} from "@forge-proposal-simulator/lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract MErc20DelegateHelper is Test {}
