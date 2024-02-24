# mToken Fixes and Collateral Sweeping - Proposal #2

This proposal will remove all Nomad collateral from .mad mTokens, sending the underlying to the community multisig, and zero all borrows from users with bad debt.

In order to allow mToken collateral sweeping and bad debt write offs, the mTokens will have their implementations upgraded.

This will stop further issues and to allow the exchange rates of the assets to stay the same post proposal. Interest Rate Models may need to be changed in order to stop rate spikes due to changes in supply and borrow amounts.

See [this](https://forum.moonwell.fi/t/request-for-proposal-rfp-redemption-and-reallocation-of-nomad-collateral-and-protocol-reserves-for-frax-market-enhancement/746/3) forum post for additional information.

## Storage Offset Verification

This proposal changes the logic contract that is used by the `MErc20Delegator` with two new `MErc20Delegate` contracts. To verify the storage slot offsets between the new and the old contracts remain unchanged, the following commands can be run:

```
slither src/OriginalMToken.sol --print variable-order
```

Then running slither on the new contracts and comparing the output to ensure no storage slots from 0 to 19 have been changed.

```
slither src/MErc20DelegateFixer.sol --print variable-order
```

diffing the output, we can see that the 20th slot has been added in the DelegateFixer.

```
< MErc20Delegate:
---
> MErc20DelegateFixer:
63a58
> |        MErc20DelegateFixer.badDebt        |                     uint256                      |  20  |   0    |
64a60,74
> 

```

The only other difference is the name change of the contract.

Diff of the storage slots of the .mad MToken fixer contract.

```
slither src/MErc20DelegateMadFixer.sol --print variable-order
```

```
1c1,9
< ComptrollerErrorReporter:
---
> INFO:Printers:
> ComptrollerInterface:
> +--------------------------------+--------+------+--------+
> |              Name              |  Type  | Slot | Offset |
> +--------------------------------+--------+------+--------+
> | ComptrollerInterface.gasAmount | uint16 |  0   |   0    |
> +--------------------------------+--------+------+--------+
> 
> EIP20Interface:
13c21
< EIP20Interface:
---
> ComptrollerErrorReporter:
19,25d26
< ComptrollerInterface:
< +--------------------------------+--------+------+--------+
< |              Name              |  Type  | Slot | Offset |
< +--------------------------------+--------+------+--------+
< | ComptrollerInterface.gasAmount | uint16 |  0   |   0    |
< +--------------------------------+--------+------+--------+
< 
32,39c33
< MDelegatorInterface:
< +-----------------------------------+---------+------+--------+
< |                Name               |   Type  | Slot | Offset |
< +-----------------------------------+---------+------+--------+
< | MDelegationStorage.implementation | address |  0   |   0    |
< +-----------------------------------+---------+------+--------+
< 
< MErc20Delegate:
---
> MErc20DelegateMadFixer:
64a59,67
> 
> MDelegatorInterface:
> +-----------------------------------+---------+------+--------+
> |                Name               |   Type  | Slot | Offset |
> +-----------------------------------+---------+------+--------+
> | MDelegationStorage.implementation | address |  0   |   0    |
> +-----------------------------------+---------+------+--------+
> 
> 
```

The only difference between the contracts are the contract names. The storage offsets remain unchanged. `MDelegatorInterface` and `ComptrollerInterface` can be safely ignored as they are not inherited and thus do not affect storage slots.

## Contract Diffing

To verify the source code changes between the new and old contracts, the diff can be viewed for the [`MErc20DelegateFixer`](https://www.diffchecker.com/kVNFeip6/) and [`MErc20DelegateMadFixer`](https://www.diffchecker.com/rgqeBxSw/).

## Integration Testing

In order to integration test the new contracts, run the following command:

```
forge test --match-contract MIPM17IntegrationTest --fork-url https://rpc.api.moonbeam.network -vvv
```

## Invariants

The following invariants must hold true immediately after the contracts are upgraded:
- no state variables are changed
- storage offsets are not changed
- only one new variable has been added
- exchange rate cannot change from calling functions `repayBadDebtWithCash`, `repayBadDebtWithReserves`, or `fixUser`.
- If bad debt is repaid with reserves, the reserves must be decreased by the same amount as the bad debt.
- if cash is used to repay bad debt, the underlying must be increased by the amount the bad debt decreased.

The following invariants must remain true after the governance proposal is executed:
- total borrows equals the sum of borrow balance for all users borrowing
- total supply equals the sum of supply balance for all users supplying
- exchange rate is the same as before the proposal for non .mad MTokens, mFRAX and mxcDOT

## Formal Verification

The new functions `repayBadDebtWithCash`, `repayBadDebtWithReserves`, and `fixUser` have been verified using formal verification.
The latest run can be found [here](https://prover.certora.com/output/651303/d5f6f29618d84b1c90fb1b11c90f2578/?anonymousKey=68171dea5299ad449392910f5c4eac61b69eda9b);

The specifications can be found in [these]() [files]().

The prover can be run with the following commands:

```
certoraRun certora/confs/SharePrice.conf 
```

```
certoraRun certora/confs/MErc20DelegateFixer.conf
```

## Deployment

Run the following commands to deploy the new contracts:

```
forge script script/GovernorBravo.s.sol:GovernorBravoScript -vvvv --rpc-url moonbeam --broadcast --verify --etherscan-api-key {key}
```
