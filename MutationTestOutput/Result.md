# Mutation Results


## Mutation 1
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 1 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -29,7 +29,8 @@
     /// this function cannot change the share price of the mToken
     function repayBadDebtWithCash(uint256 amount) external nonReentrant {
         /// Checks and Effects
-        badDebt = SafeMath.sub(badDebt, amount, "amount exceeds bad debt");
+        /// DeleteExpressionMutation(`badDebt = SafeMath.sub(badDebt, amount, "amount exceeds bad debt")` |==> `assert(true)`) of: `badDebt = SafeMath.sub(badDebt, amount, "amount exceeds bad debt");`
+        assert(true);
 
         EIP20Interface token = EIP20Interface(underlying);
 

Path: mutants/1/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: Error != expected error: ERC20: transfer amount exceeds balance != amount exceeds bad debt] testRepayBadDebtFailsAmountExceedsBadDebt() (gas: 30939)
[FAIL. Reason: assertion failed; counterexample: calldata=0xf70f04650000000000000000000000000000000000000000000000000000000000000000 args=[0]] testRepayBadDebtSucceeds(uint256) (runs: 0, μ: 0, ~: 0)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|badDebtRulesCash                        |Violated     |2         |Assert message: cash not the same -                         |MockERC20=MockERC20 (0x8c92)                      |
|                                        |             |          |certora/specs/SharePrice.spec line 144                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x8c91)                                          |
|                                        |             |          |                                                            |amount=1                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x8c90                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=0                                   |
|                                        |             |          |                                                            |startingBadDebt=0                                 |
|                                        |             |          |                                                            |startingCash=0                                    |
|repayBadDebtDecreasesBadDebt            |Violated     |2         |Assert message: bad debt not decreased by repay amt -       |MockERC20=MockERC20                               |
|                                        |             |          |certora/specs/SharePrice.spec line 94                       |(0xffffffffffffffffffffffffffffffffffffffff       |
|                                        |             |          |                                                            |(MAX_EVM_ADDRESS))                                |
|                                        |             |          |                                                            |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(1)                                               |
|                                        |             |          |                                                            |badDebt=0                                         |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2712                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |mTokenBalance=0                                   |
|                                        |             |          |                                                            |repayAmount=1                                     |
|                                        |             |          |                                                            |userBalance=2                                     |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Violated     |4         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |4         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on badDebtRulesCash:
Assert message: cash not the same - certora/specs/SharePrice.spec line 144
Failed on repayBadDebtDecreasesBadDebt:
Assert message: bad debt not decreased by repay amt - certora/specs/SharePrice.spec line 94
Failed on allBadDebtRulesCash:
Assert message: cash not correct - certora/specs/SharePrice.spec line 171
Violated for: 
repayBadDebtWithCash(uint256)
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithCash(uint256)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/c6b9cbb1f85a4514afe8e8aa07e92ec3?anonymousKey=48cc97d4919c61d74a1d638b99ac79235264010f
Finished verification request
ERROR: Prover found violations:
[rule] allBadDebtRulesCash: 
  [func] repayBadDebtWithCash(uint256)[rule] badDebtRules: 
  [func] repayBadDebtWithCash(uint256)[rule] badDebtRulesCash: FAIL[rule] repayBadDebtDecreasesBadDebt: FAIL
```
</details>

## Mutation 2
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 2 [AssignmentMutation] ===

--- original
+++ mutant
@@ -29,7 +29,8 @@
     /// this function cannot change the share price of the mToken
     function repayBadDebtWithCash(uint256 amount) external nonReentrant {
         /// Checks and Effects
-        badDebt = SafeMath.sub(badDebt, amount, "amount exceeds bad debt");
+        /// AssignmentMutation(`SafeMath.sub(badDebt, amount, "amount exceeds bad debt")` |==> `0`) of: `badDebt = SafeMath.sub(badDebt, amount, "amount exceeds bad debt");`
+        badDebt = 0;
 
         EIP20Interface token = EIP20Interface(underlying);
 

Path: mutants/2/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: Error != expected error: ERC20: transfer amount exceeds balance != amount exceeds bad debt] testRepayBadDebtFailsAmountExceedsBadDebt() (gas: 33854)
[FAIL. Reason: revert: exchangeRateStored: exchangeRateStoredInternal failed; counterexample: calldata=0xf70f04650000000000000000000000000000000000000000000000000000000000000000 args=[0]] testRepayBadDebtSucceeds(uint256) (runs: 0, μ: 0, ~: 0)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|badDebtRulesCash                        |Violated     |3         |Assert message: cash not the same -                         |MockERC20=MockERC20 (0x3098)                      |
|                                        |             |          |certora/specs/SharePrice.spec line 144                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x3097)                                          |
|                                        |             |          |                                                            |amount=1                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x3096                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=initialized to unknown              |
|                                        |             |          |                                                            |startingBadDebt=0                                 |
|                                        |             |          |                                                            |startingCash=0xfffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffe                     |
|repayBadDebtDecreasesBadDebt            |Violated     |3         |Assert message: bad debt not decreased by repay amt -       |MockERC20=MockERC20 (0x47c0)                      |
|                                        |             |          |certora/specs/SharePrice.spec line 94                       |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x47bf)                                          |
|                                        |             |          |                                                            |badDebt=49                                        |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x47be                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |mTokenBalance=0                                   |
|                                        |             |          |                                                            |repayAmount=50                                    |
|                                        |             |          |                                                            |userBalance=0xffffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffe05d                      |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |2         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |5         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on badDebtRulesCash:
Assert message: cash not the same - certora/specs/SharePrice.spec line 144
Failed on repayBadDebtDecreasesBadDebt:
Assert message: bad debt not decreased by repay amt - certora/specs/SharePrice.spec line 94
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithCash(uint256)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/83590c3273804e838800bba163f7ef3a?anonymousKey=410cf492a07d80e656e380bea293512b672dac13
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] repayBadDebtWithCash(uint256)[rule] badDebtRulesCash: FAIL[rule] repayBadDebtDecreasesBadDebt: FAIL
```
</details>

## Mutation 3
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 3 [AssignmentMutation] ===

--- original
+++ mutant
@@ -29,7 +29,8 @@
     /// this function cannot change the share price of the mToken
     function repayBadDebtWithCash(uint256 amount) external nonReentrant {
         /// Checks and Effects
-        badDebt = SafeMath.sub(badDebt, amount, "amount exceeds bad debt");
+        /// AssignmentMutation(`SafeMath.sub(badDebt, amount, "amount exceeds bad debt")` |==> `1`) of: `badDebt = SafeMath.sub(badDebt, amount, "amount exceeds bad debt");`
+        badDebt = 1;
 
         EIP20Interface token = EIP20Interface(underlying);
 

Path: mutants/3/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: Error != expected error: ERC20: transfer amount exceeds balance != amount exceeds bad debt] testRepayBadDebtFailsAmountExceedsBadDebt() (gas: 33851)
[FAIL. Reason: revert: exchangeRateStored: exchangeRateStoredInternal failed; counterexample: calldata=0xf70f04650000000000000000000000000000000000000000000000000000000000000000 args=[0]] testRepayBadDebtSucceeds(uint256) (runs: 0, μ: 0, ~: 0)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Violated     |3         |Assert message: bad debt not decreased by repay amt -       |MockERC20=MockERC20 (1)                           |
|                                        |             |          |certora/specs/SharePrice.spec line 94                       |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(2)                                               |
|                                        |             |          |                                                            |badDebt=0                                         |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2711                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |mTokenBalance=0                                   |
|                                        |             |          |                                                            |repayAmount=0                                     |
|                                        |             |          |                                                            |userBalance=0                                     |
|badDebtRulesCash                        |Violated     |2         |Assert message: cash not the same -                         |MockERC20=MockERC20 (0x3098)                      |
|                                        |             |          |certora/specs/SharePrice.spec line 144                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x3097)                                          |
|                                        |             |          |                                                            |amount=1                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x3096                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=initialized to unknown              |
|                                        |             |          |                                                            |startingBadDebt=0                                 |
|                                        |             |          |                                                            |startingCash=0xfffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffe                     |
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Violated     |3         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |3         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtDecreasesBadDebt:
Assert message: bad debt not decreased by repay amt - certora/specs/SharePrice.spec line 94
Failed on badDebtRulesCash:
Assert message: cash not the same - certora/specs/SharePrice.spec line 144
Failed on allBadDebtRulesCash:
Assert message: cash not correct - certora/specs/SharePrice.spec line 171
Violated for: 
repayBadDebtWithCash(uint256)
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithCash(uint256)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/7514cf7166fe4b1da6c10a5bb46fd33c?anonymousKey=ad3e6950b1a3d47b27734b23a415d3f4edf4fa24
Finished verification request
ERROR: Prover found violations:
[rule] allBadDebtRulesCash: 
  [func] repayBadDebtWithCash(uint256)[rule] badDebtRules: 
  [func] repayBadDebtWithCash(uint256)[rule] badDebtRulesCash: FAIL[rule] repayBadDebtDecreasesBadDebt: FAIL
```
</details>

## Mutation 4
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 4 [RequireMutation] ===

--- original
+++ mutant
@@ -35,7 +35,8 @@
 
         /// Interactions
         require(
-            token.transferFrom(msg.sender, address(this), amount),
+            /// RequireMutation(`token.transferFrom(msg.sender, address(this), amount)` |==> `true`) of: `token.transferFrom(msg.sender, address(this), amount),`
+            true,
             "transfer in failed"
         );
 

Path: mutants/4/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 45
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: assertion failed; counterexample: calldata=0xf70f04650000000000000000000000000000000000000000000000000000000000000000 args=[0]] testRepayBadDebtSucceeds(uint256) (runs: 0, μ: 0, ~: 0)

Encountered a total of 1 failing tests, 45 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Violated     |4         |Assert message: underlying balance of user did not decre... |MockERC20=MockERC20                               |
|                                        |             |          |- certora/specs/SharePrice.spec line 90                     |(0xbfffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |badDebt=0xc000000000000000000000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000                          |
|                                        |             |          |                                                            |e.block.basefee=0x7fffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffff                  |
|                                        |             |          |                                                            |e.block.coinbase=MockMErc20DelegateFixer          |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.block.difficulty=0x7ffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffffff               |
|                                        |             |          |                                                            |e.block.gaslimit=0x7ffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffff                 |
|                                        |             |          |                                                            |e.block.number=0x7ffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffff                   |
|                                        |             |          |                                                            |e.block.timestamp=0x7fffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffffff                |
|                                        |             |          |                                                            |e.msg.sender=MockERC20                            |
|                                        |             |          |                                                            |(0xbfffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=MockMErc20DelegateFixer               |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |mTokenBalance=0x8000000000000000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000000000                    |
|                                        |             |          |                                                            |repayAmount=0x800000000000000000000000000000000000|
|                                        |             |          |                                                            |0000000000000000000000000000                      |
|                                        |             |          |                                                            |userBalance=0x800000000000000000000000000000000000|
|                                        |             |          |                                                            |0000000000000000000000000000                      |
|badDebtRulesCash                        |Violated     |3         |Assert message: cash not the same -                         |MockERC20=MockERC20 (0x2739)                      |
|                                        |             |          |certora/specs/SharePrice.spec line 144                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2738)                                          |
|                                        |             |          |                                                            |amount=1                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2737                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=0                                   |
|                                        |             |          |                                                            |startingBadDebt=1                                 |
|                                        |             |          |                                                            |startingCash=1                                    |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |4         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtDecreasesBadDebt:
Assert message: underlying balance of user did not decre... - certora/specs/SharePrice.spec line 90
Failed on badDebtRulesCash:
Assert message: cash not the same - certora/specs/SharePrice.spec line 144
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithCash(uint256)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/38dab50b6558417abf3f7379e581a139?anonymousKey=8d3d24f094663c4178b13ce7496ff88bd95a35c7
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] repayBadDebtWithCash(uint256)[rule] badDebtRulesCash: FAIL[rule] repayBadDebtDecreasesBadDebt: FAIL
```
</details>

## Mutation 5
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 5 [RequireMutation] ===

--- original
+++ mutant
@@ -35,7 +35,8 @@
 
         /// Interactions
         require(
-            token.transferFrom(msg.sender, address(this), amount),
+            /// RequireMutation(`token.transferFrom(msg.sender, address(this), amount)` |==> `false`) of: `token.transferFrom(msg.sender, address(this), amount),`
+            false,
             "transfer in failed"
         );
 

Path: mutants/5/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 45
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: log != expected log; counterexample: calldata=0xf70f04650000000000000000000000000000000000000000000000000000000000000000 args=[0]] testRepayBadDebtSucceeds(uint256) (runs: 0, μ: 0, ~: 0)

Encountered a total of 1 failing tests, 45 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|badDebtRulesCash                        |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtDecreasesBadDebt            |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Sanity check |3         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Sanity check |3         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Sanity check |5         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on badDebtRulesCash:
Failed on repayBadDebtDecreasesBadDebt:
Failed on badDebtSymmetry:
Failed on allBadDebtRulesCash:
Failed on badDebtRules:
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/c3372c407ecb4b2e938fc3beb65ba40b?anonymousKey=f17e271771d0eed10f82ce07aea0b66ce950c868
Finished verification request
ERROR: Prover found violations:
[rule] allBadDebtRulesCash: 
  [func] repayBadDebtWithCash(uint256)[rule] badDebtRules: 
  [func] repayBadDebtWithCash(uint256)[rule] badDebtRulesCash: SANITY_FAIL[rule] badDebtSymmetry: 
  [func] repayBadDebtWithCash(uint256)[rule] repayBadDebtDecreasesBadDebt: SANITY_FAIL
```
</details>

## Mutation 6
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 6 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -50,7 +50,8 @@
         uint256 currentReserves = totalReserves;
         uint256 currentBadDebt = badDebt;
 
-        require(currentReserves != 0, "reserves are zero");
+        /// DeleteExpressionMutation(`require(currentReserves != 0, "reserves are zero")` |==> `assert(true)`) of: `require(currentReserves != 0, "reserves are zero");`
+        assert(true);
         require(currentBadDebt != 0, "bad debt is zero");
 
         /// no reverts possible past this point

Path: mutants/6/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 45
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: call did not revert as expected] testRepayBadDebtWithNoReservesFails() (gas: 72345)

Encountered a total of 1 failing tests, 45 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/a4c0963932b6443cae2d7927193e8538?anonymousKey=4d173c4445744cb445b3e3c7aefc6f01b171faf6
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 7
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 7 [RequireMutation] ===

--- original
+++ mutant
@@ -50,7 +50,8 @@
         uint256 currentReserves = totalReserves;
         uint256 currentBadDebt = badDebt;
 
-        require(currentReserves != 0, "reserves are zero");
+        /// RequireMutation(`currentReserves != 0` |==> `true`) of: `require(currentReserves != 0, "reserves are zero");`
+        require(true, "reserves are zero");
         require(currentBadDebt != 0, "bad debt is zero");
 
         /// no reverts possible past this point

Path: mutants/7/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 45
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: call did not revert as expected] testRepayBadDebtWithNoReservesFails() (gas: 72345)

Encountered a total of 1 failing tests, 45 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |1         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/3d254d98fcb741d6af3a5e60f7d09281?anonymousKey=84a000dc66bab8d9d211ede2fc0bec8401a6828e
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 8
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 8 [RequireMutation] ===

--- original
+++ mutant
@@ -50,7 +50,8 @@
         uint256 currentReserves = totalReserves;
         uint256 currentBadDebt = badDebt;
 
-        require(currentReserves != 0, "reserves are zero");
+        /// RequireMutation(`currentReserves != 0` |==> `false`) of: `require(currentReserves != 0, "reserves are zero");`
+        require(false, "reserves are zero");
         require(currentBadDebt != 0, "bad debt is zero");
 
         /// no reverts possible past this point

Path: mutants/8/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 3, Passed Tests: 43
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 3 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: Error != expected error: reserves are zero != bad debt is zero] testRepayBadDebtWithNoBadDebtFails() (gas: 19243)
[FAIL. Reason: log != expected log] testRepayBadDebtWithNoReservesFails() (gas: 45822)
[FAIL. Reason: log != expected log] testRepayBadDebtWithReservesSucceeds() (gas: 45806)

Encountered a total of 3 failing tests, 43 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Sanity check |0         |                                                            |no local variables                                |
|rePrice                                 |failed       |          |                                                            |                                                  |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Sanity check |3         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Sanity check |4         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Sanity check |5         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtWithReservesSuccess:
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Failed on badDebtSymmetry:
Failed on allBadDebtRulesCash:
Failed on badDebtRules:
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/125070ea498b429585cb02fde15dcb10?anonymousKey=5ae2166dd6dcc0ecd4ca230c2d30f170d53ed158
Finished verification request
ERROR: Prover found violations:
[rule] allBadDebtRulesCash: 
  [func] repayBadDebtWithReserves()[rule] badDebtRules: 
  [func] repayBadDebtWithReserves()[rule] badDebtSymmetry: 
  [func] repayBadDebtWithReserves()[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: SANITY_FAIL[rule] repayBadDebtWithReservesSuccess: SANITY_FAIL
```
</details>

## Mutation 9
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 9 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -51,7 +51,8 @@
         uint256 currentBadDebt = badDebt;
 
         require(currentReserves != 0, "reserves are zero");
-        require(currentBadDebt != 0, "bad debt is zero");
+        /// DeleteExpressionMutation(`require(currentBadDebt != 0, "bad debt is zero")` |==> `assert(true)`) of: `require(currentBadDebt != 0, "bad debt is zero");`
+        assert(true);
 
         /// no reverts possible past this point
 

Path: mutants/9/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 45
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: call did not revert as expected] testRepayBadDebtWithNoBadDebtFails() (gas: 21863)

Encountered a total of 1 failing tests, 45 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |2         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |5         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/255592b0712b4c23a5d7b80708cf1886?anonymousKey=41b93368c34648171eedd6177499817846ed82eb
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 10
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 10 [RequireMutation] ===

--- original
+++ mutant
@@ -51,7 +51,8 @@
         uint256 currentBadDebt = badDebt;
 
         require(currentReserves != 0, "reserves are zero");
-        require(currentBadDebt != 0, "bad debt is zero");
+        /// RequireMutation(`currentBadDebt != 0` |==> `true`) of: `require(currentBadDebt != 0, "bad debt is zero");`
+        require(true, "bad debt is zero");
 
         /// no reverts possible past this point
 

Path: mutants/10/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 45
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: call did not revert as expected] testRepayBadDebtWithNoBadDebtFails() (gas: 21863)

Encountered a total of 1 failing tests, 45 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/3bf5287813be4402adb7d0fc88f456f7?anonymousKey=dded98ed94e95ae24491bd8f636191a42a8a77d8
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 11
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 11 [RequireMutation] ===

--- original
+++ mutant
@@ -51,7 +51,8 @@
         uint256 currentBadDebt = badDebt;
 
         require(currentReserves != 0, "reserves are zero");
-        require(currentBadDebt != 0, "bad debt is zero");
+        /// RequireMutation(`currentBadDebt != 0` |==> `false`) of: `require(currentBadDebt != 0, "bad debt is zero");`
+        require(false, "bad debt is zero");
 
         /// no reverts possible past this point
 

Path: mutants/11/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: log != expected log] testRepayBadDebtWithNoReservesFails() (gas: 45839)
[FAIL. Reason: log != expected log] testRepayBadDebtWithReservesSucceeds() (gas: 45823)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Sanity check |0         |                                                            |no local variables                                |
|rePrice                                 |failed       |          |                                                            |                                                  |
|fixUserIncreasesBadDebt                 |Not violated |4         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |4         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Sanity check |4         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Sanity check |5         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Sanity check |6         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtWithReservesSuccess:
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Failed on badDebtSymmetry:
Failed on allBadDebtRulesCash:
Failed on badDebtRules:
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/092d762ec2bd4c6499852b997578b5ff?anonymousKey=21ff96561c744070ddfb94a95b3018b242f13300
Finished verification request
ERROR: Prover found violations:
[rule] allBadDebtRulesCash: 
  [func] repayBadDebtWithReserves()[rule] badDebtRules: 
  [func] repayBadDebtWithReserves()[rule] badDebtSymmetry: 
  [func] repayBadDebtWithReserves()[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: SANITY_FAIL[rule] repayBadDebtWithReservesSuccess: SANITY_FAIL
```
</details>

## Mutation 12
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 12 [SwapArgumentsOperatorMutation] ===

--- original
+++ mutant
@@ -56,7 +56,8 @@
         /// no reverts possible past this point
 
         /// take the lesser of the two, subtract it from both numbers
-        uint256 subtractAmount = currentBadDebt < currentReserves
+        /// SwapArgumentsOperatorMutation(`currentBadDebt < currentReserves` |==> `currentReserves < currentBadDebt`) of: `uint256 subtractAmount = currentBadDebt < currentReserves`
+        uint256 subtractAmount = currentReserves < currentBadDebt
             ? currentBadDebt
             : currentReserves;
 

Path: mutants/12/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: log != expected log] testRepayBadDebtWithNoReservesFails() (gas: 49405)
[FAIL. Reason: log != expected log] testRepayBadDebtWithReservesSucceeds() (gas: 49389)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |2         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |4         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |6         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/34943096a12e467a950523df7d3472ee?anonymousKey=b63f657ebe91d8fcd65a87c4a3b1d06707b4a895
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 13
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 13 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -61,7 +61,8 @@
             : currentReserves;
 
         /// bad debt -= subtract amount
-        badDebt = SafeMath.sub(currentBadDebt, subtractAmount);
+        /// DeleteExpressionMutation(`badDebt = SafeMath.sub(currentBadDebt, subtractAmount)` |==> `assert(true)`) of: `badDebt = SafeMath.sub(currentBadDebt, subtractAmount);`
+        assert(true);
 
         /// current reserves -= subtract amount
         totalReserves = SafeMath.sub(currentReserves, subtractAmount);

Path: mutants/13/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: log != expected log] testRepayBadDebtWithNoReservesFails() (gas: 50991)
[FAIL. Reason: log != expected log] testRepayBadDebtWithReservesSucceeds() (gas: 50975)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Violated     |3         |Assert message: bad debt not fully paid off -               |MockERC20=MockERC20                               |
|                                        |             |          |certora/specs/SharePrice.spec line 184                      |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0xbfffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.block.basefee=0x7fffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffff                  |
|                                        |             |          |                                                            |e.block.coinbase=MockERC20                        |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.block.difficulty=0x7ffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffffff               |
|                                        |             |          |                                                            |e.block.gaslimit=0x7ffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffff                 |
|                                        |             |          |                                                            |e.block.number=0x7ffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffff                   |
|                                        |             |          |                                                            |e.block.timestamp=0x7fffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffffff                |
|                                        |             |          |                                                            |e.msg.sender=MockERC20                            |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.msg.value=0x7fffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffff                      |
|                                        |             |          |                                                            |e.tx.origin=MockERC20                             |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |endingBadDebt=0x4000000000000000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000000000                    |
|                                        |             |          |                                                            |endingReserves=initialized to unknown             |
|                                        |             |          |                                                            |startingBadDebt=0x40000000000000000000000000000000|
|                                        |             |          |                                                            |00000000000000000000000000000000                  |
|                                        |             |          |                                                            |startingReserves=0x8000000000000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000000000000                 |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |2         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (1)                           |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(2)                                               |
|                                        |             |          |                                                            |e.block.basefee=0xffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffff (MAX_UINT256)    |
|                                        |             |          |                                                            |e.block.coinbase=0xfffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffff (MAX_EVM_ADDRESS)                       |
|                                        |             |          |                                                            |e.block.difficulty=0xfffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffffff (MAX_UINT256) |
|                                        |             |          |                                                            |e.block.gaslimit=0xfffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffff (MAX_UINT256)   |
|                                        |             |          |                                                            |e.block.number=0xfffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffff (MAX_UINT256)     |
|                                        |             |          |                                                            |e.block.timestamp=0xffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffffff (MAX_UINT256)  |
|                                        |             |          |                                                            |e.msg.sender=0x2710                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0xffffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffff (MAX_EVM_ADDRESS)                            |
|                                        |             |          |                                                            |endingSharePrice=0x7ffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffee00c13e37b50a40000                 |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |3         |Assert message: reserves bad debt incorrect -               |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 229                      |                                                  |
|allBadDebtRulesCash                     |Not violated |4         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |5         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtWithReservesSuccess:
Assert message: bad debt not fully paid off - certora/specs/SharePrice.spec line 184
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on badDebtSymmetry:
Assert message: reserves bad debt incorrect - certora/specs/SharePrice.spec line 229
Violated for: 
repayBadDebtWithReserves()
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithReserves()
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/528425aa0fa04c8b8ec942393207f818?anonymousKey=3cabee9bd5b5f9ce3818943b15db25914e5b9f88
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] repayBadDebtWithReserves()[rule] badDebtSymmetry: 
  [func] repayBadDebtWithReserves()[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: FAIL[rule] repayBadDebtWithReservesSuccess: FAIL
```
</details>

## Mutation 14
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 14 [AssignmentMutation] ===

--- original
+++ mutant
@@ -61,7 +61,8 @@
             : currentReserves;
 
         /// bad debt -= subtract amount
-        badDebt = SafeMath.sub(currentBadDebt, subtractAmount);
+        /// AssignmentMutation(`SafeMath.sub(currentBadDebt, subtractAmount)` |==> `0`) of: `badDebt = SafeMath.sub(currentBadDebt, subtractAmount);`
+        badDebt = 0;
 
         /// current reserves -= subtract amount
         totalReserves = SafeMath.sub(currentReserves, subtractAmount);

Path: mutants/14/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: log != expected log] testRepayBadDebtWithNoReservesFails() (gas: 53897)
[FAIL. Reason: log != expected log] testRepayBadDebtWithReservesSucceeds() (gas: 53881)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Violated     |3         |Assert message: bad debt not paid off by reserve amount -   |MockERC20=MockERC20 (1)                           |
|                                        |             |          |certora/specs/SharePrice.spec line 188                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(2)                                               |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0                                    |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=initialized to unknown              |
|                                        |             |          |                                                            |endingReserves=initialized to unknown             |
|                                        |             |          |                                                            |startingBadDebt=2                                 |
|                                        |             |          |                                                            |startingReserves=1                                |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |2         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (2)                           |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(1)                                               |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0                                    |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingSharePrice=0                                |
|                                        |             |          |                                                            |startingSharePrice=1                              |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |3         |Assert message: reserves bad debt incorrect -               |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 229                      |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |3         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtWithReservesSuccess:
Assert message: bad debt not paid off by reserve amount - certora/specs/SharePrice.spec line 188
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on badDebtSymmetry:
Assert message: reserves bad debt incorrect - certora/specs/SharePrice.spec line 229
Violated for: 
repayBadDebtWithReserves()
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithReserves()
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/5d355f6967274638b280c94b8276e24a?anonymousKey=7a2f5fca01ebb73df80d2d0b97ad386274994d6a
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] repayBadDebtWithReserves()[rule] badDebtSymmetry: 
  [func] repayBadDebtWithReserves()[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: FAIL[rule] repayBadDebtWithReservesSuccess: FAIL
```
</details>

## Mutation 15
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 15 [AssignmentMutation] ===

--- original
+++ mutant
@@ -61,7 +61,8 @@
             : currentReserves;
 
         /// bad debt -= subtract amount
-        badDebt = SafeMath.sub(currentBadDebt, subtractAmount);
+        /// AssignmentMutation(`SafeMath.sub(currentBadDebt, subtractAmount)` |==> `1`) of: `badDebt = SafeMath.sub(currentBadDebt, subtractAmount);`
+        badDebt = 1;
 
         /// current reserves -= subtract amount
         totalReserves = SafeMath.sub(currentReserves, subtractAmount);

Path: mutants/15/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: log != expected log] testRepayBadDebtWithNoReservesFails() (gas: 53897)
[FAIL. Reason: log != expected log] testRepayBadDebtWithReservesSucceeds() (gas: 53881)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Violated     |3         |Assert message: bad debt not fully paid off -               |MockERC20=MockERC20                               |
|                                        |             |          |certora/specs/SharePrice.spec line 184                      |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0xbfffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.block.basefee=0x7fffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffff                  |
|                                        |             |          |                                                            |e.block.coinbase=MockERC20                        |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.block.difficulty=0x7ffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffffff               |
|                                        |             |          |                                                            |e.block.gaslimit=0x7ffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffff                 |
|                                        |             |          |                                                            |e.block.number=0x7ffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffff                   |
|                                        |             |          |                                                            |e.block.timestamp=0x7fffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffffff                |
|                                        |             |          |                                                            |e.msg.sender=MockERC20                            |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.msg.value=0x7fffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffff                      |
|                                        |             |          |                                                            |e.tx.origin=MockERC20                             |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |endingBadDebt=initialized to unknown              |
|                                        |             |          |                                                            |endingReserves=initialized to unknown             |
|                                        |             |          |                                                            |startingBadDebt=0x40000000000000000000000000000000|
|                                        |             |          |                                                            |00000000000000000000000000000000                  |
|                                        |             |          |                                                            |startingReserves=0x8000000000000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000000000000                 |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |2         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (2)                           |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(1)                                               |
|                                        |             |          |                                                            |e.block.basefee=0xffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffff (MAX_UINT256)    |
|                                        |             |          |                                                            |e.block.coinbase=0xfffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffff (MAX_EVM_ADDRESS)                       |
|                                        |             |          |                                                            |e.block.difficulty=0xfffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffffff (MAX_UINT256) |
|                                        |             |          |                                                            |e.block.gaslimit=0xfffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffff (MAX_UINT256)   |
|                                        |             |          |                                                            |e.block.number=0xfffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffff (MAX_UINT256)     |
|                                        |             |          |                                                            |e.block.timestamp=0xffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffffff (MAX_UINT256)  |
|                                        |             |          |                                                            |e.msg.sender=0x2710                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0xffffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffff (MAX_EVM_ADDRESS)                            |
|                                        |             |          |                                                            |endingSharePrice=0                                |
|                                        |             |          |                                                            |startingSharePrice=1                              |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |4         |Assert message: reserves bad debt incorrect -               |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 229                      |                                                  |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |4         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtWithReservesSuccess:
Assert message: bad debt not fully paid off - certora/specs/SharePrice.spec line 184
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on badDebtSymmetry:
Assert message: reserves bad debt incorrect - certora/specs/SharePrice.spec line 229
Violated for: 
repayBadDebtWithReserves()
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithReserves()
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/ed6e4113f78e49e49490a9983bc56f33?anonymousKey=68b5da5c891a50a01667acdcd61f08e779542695
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] repayBadDebtWithReserves()[rule] badDebtSymmetry: 
  [func] repayBadDebtWithReserves()[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: FAIL[rule] repayBadDebtWithReservesSuccess: FAIL
```
</details>

## Mutation 16
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 16 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -64,7 +64,8 @@
         badDebt = SafeMath.sub(currentBadDebt, subtractAmount);
 
         /// current reserves -= subtract amount
-        totalReserves = SafeMath.sub(currentReserves, subtractAmount);
+        /// DeleteExpressionMutation(`totalReserves = SafeMath.sub(currentReserves, subtractAmount)` |==> `assert(true)`) of: `totalReserves = SafeMath.sub(currentReserves, subtractAmount);`
+        assert(true);
 
         emit BadDebtRepayedWithReserves(
             badDebt,

Path: mutants/16/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: log != expected log] testRepayBadDebtWithNoReservesFails() (gas: 51085)
[FAIL. Reason: log != expected log] testRepayBadDebtWithReservesSucceeds() (gas: 51069)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |4         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (2)                           |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(4)                                               |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0                                    |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingSharePrice=0                                |
|                                        |             |          |                                                            |startingSharePrice=0xfffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffff7e52fe5afe40000               |
|fixUserIncreasesBadDebt                 |Not violated |4         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |4         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |4         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |3         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithReserves()
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/f6e0dabddc2b40ac975e9faa9e7b5aee?anonymousKey=48512a2f0ce1d2dff32b16913e7e7804729f2599
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] repayBadDebtWithReserves()[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 17
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 17 [AssignmentMutation] ===

--- original
+++ mutant
@@ -64,7 +64,8 @@
         badDebt = SafeMath.sub(currentBadDebt, subtractAmount);
 
         /// current reserves -= subtract amount
-        totalReserves = SafeMath.sub(currentReserves, subtractAmount);
+        /// AssignmentMutation(`SafeMath.sub(currentReserves, subtractAmount)` |==> `0`) of: `totalReserves = SafeMath.sub(currentReserves, subtractAmount);`
+        totalReserves = 0;
 
         emit BadDebtRepayedWithReserves(
             badDebt,

Path: mutants/17/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 0, Passed Tests: 46

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |4         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (0x2711)                      |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2712)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2711)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingSharePrice=1                                |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|fixUserIncreasesBadDebt                 |Not violated |2         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |4         |Assert message: reserves bad debt incorrect -               |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 229                      |                                                  |
|allBadDebtRulesCash                     |Not violated |4         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |3         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on badDebtSymmetry:
Assert message: reserves bad debt incorrect - certora/specs/SharePrice.spec line 229
Violated for: 
repayBadDebtWithReserves()
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithReserves()
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/4cb664ac1f09458791ea6956edd754cd?anonymousKey=1e3eab42f27250ae8fac799facb36be21dd371a1
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] repayBadDebtWithReserves()[rule] badDebtSymmetry: 
  [func] repayBadDebtWithReserves()[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 18
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 18 [AssignmentMutation] ===

--- original
+++ mutant
@@ -64,7 +64,8 @@
         badDebt = SafeMath.sub(currentBadDebt, subtractAmount);
 
         /// current reserves -= subtract amount
-        totalReserves = SafeMath.sub(currentReserves, subtractAmount);
+        /// AssignmentMutation(`SafeMath.sub(currentReserves, subtractAmount)` |==> `1`) of: `totalReserves = SafeMath.sub(currentReserves, subtractAmount);`
+        totalReserves = 1;
 
         emit BadDebtRepayedWithReserves(
             badDebt,

Path: mutants/18/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: log != expected log] testRepayBadDebtWithNoReservesFails() (gas: 53797)
[FAIL. Reason: log != expected log] testRepayBadDebtWithReservesSucceeds() (gas: 53781)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |3         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (1)                           |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(2)                                               |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2711                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingSharePrice=0                                |
|                                        |             |          |                                                            |startingSharePrice=1                              |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |2         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |3         |Assert message: reserves bad debt incorrect -               |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 229                      |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |4         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on badDebtSymmetry:
Assert message: reserves bad debt incorrect - certora/specs/SharePrice.spec line 229
Violated for: 
repayBadDebtWithReserves()
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithReserves()
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/00b697ad3b9347239e820bcbf26251b5?anonymousKey=f6f9266b4134d8ef238f382d4a25fc666d292a72
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] repayBadDebtWithReserves()[rule] badDebtSymmetry: 
  [func] repayBadDebtWithReserves()[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 19
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 19 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -82,7 +82,8 @@
     /// assumes governance is non malicious, and that all users liquidated have active borrows
     function fixUser(address liquidator, address user) external {
         /// @dev check user is admin
-        require(msg.sender == admin, "only the admin may call fixUser");
+        /// DeleteExpressionMutation(`require(msg.sender == admin, "only the admin may call fixUser")` |==> `assert(true)`) of: `require(msg.sender == admin, "only the admin may call fixUser");`
+        assert(true);
 
         /// ensure nothing strange can happen with incorrect liquidator
         require(liquidator != user, "liquidator cannot be user");

Path: mutants/19/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 45
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: Error != expected error: liquidator cannot be user != only the admin may call fixUser] testNonAdminCannotFixUser() (gas: 13995)

Encountered a total of 1 failing tests, 45 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/e7ee8b8b43db401f9786d341ae63271e?anonymousKey=11b4ddc22913f463c9d622803c80f86fd459cd75
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 20
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 20 [RequireMutation] ===

--- original
+++ mutant
@@ -82,7 +82,8 @@
     /// assumes governance is non malicious, and that all users liquidated have active borrows
     function fixUser(address liquidator, address user) external {
         /// @dev check user is admin
-        require(msg.sender == admin, "only the admin may call fixUser");
+        /// RequireMutation(`msg.sender == admin` |==> `true`) of: `require(msg.sender == admin, "only the admin may call fixUser");`
+        require(true, "only the admin may call fixUser");
 
         /// ensure nothing strange can happen with incorrect liquidator
         require(liquidator != user, "liquidator cannot be user");

Path: mutants/20/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 45
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: Error != expected error: liquidator cannot be user != only the admin may call fixUser] testNonAdminCannotFixUser() (gas: 13995)

Encountered a total of 1 failing tests, 45 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |5         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/52a3792c2f854a71b8c9bc92fcb35cff?anonymousKey=c60bb592864988eaa03b9c65088c2828baabb285
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 21
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 21 [RequireMutation] ===

--- original
+++ mutant
@@ -82,7 +82,8 @@
     /// assumes governance is non malicious, and that all users liquidated have active borrows
     function fixUser(address liquidator, address user) external {
         /// @dev check user is admin
-        require(msg.sender == admin, "only the admin may call fixUser");
+        /// RequireMutation(`msg.sender == admin` |==> `false`) of: `require(msg.sender == admin, "only the admin may call fixUser");`
+        require(false, "only the admin may call fixUser");
 
         /// ensure nothing strange can happen with incorrect liquidator
         require(liquidator != user, "liquidator cannot be user");

Path: mutants/21/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: revert: Timelock::executeTransaction: Transaction execution reverted.] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Sanity check |3         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|badDebtRules                            |Sanity check |5         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserZeroUserBalance:
Failed on fixingUserDoesNotChangeSharePrice:
Failed on badDebtSymmetry:
Failed on fixUserIncreasesBadDebt:
Failed on badDebtRules:
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/26128a110e084afaa944f816e0f88930?anonymousKey=58d4050719b62bec145f9f4d3f2f35b08730c075
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] fixUser(address,address)[rule] badDebtSymmetry: 
  [func] fixUser(address,address)[rule] fixUserIncreasesBadDebt: SANITY_FAIL[rule] fixingUserDoesNotChangeSharePrice: SANITY_FAIL[rule] fixingUserZeroUserBalance: SANITY_FAIL
```
</details>

## Mutation 22
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 22 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -85,7 +85,8 @@
         require(msg.sender == admin, "only the admin may call fixUser");
 
         /// ensure nothing strange can happen with incorrect liquidator
-        require(liquidator != user, "liquidator cannot be user");
+        /// DeleteExpressionMutation(`require(liquidator != user, "liquidator cannot be user")` |==> `assert(true)`) of: `require(liquidator != user, "liquidator cannot be user");`
+        assert(true);
 
         require(accrueInterest() == 0, "accrue interest failed");
 

Path: mutants/22/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 45
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: Error != expected error: cannot liquidate user without borrows != liquidator cannot be user] testFixUserFailsUserEqLiquidator() (gas: 30894)

Encountered a total of 1 failing tests, 45 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Violated     |3         |Assert message: liquidator balance incorrect -              |MockERC20=MockERC20 (1)                           |
|                                        |             |          |certora/specs/SharePrice.spec line 66                       |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(2)                                               |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockMErc20DelegateFixer (2)          |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x2711                                 |
|                                        |             |          |                                                            |startingLiquidatorBalance=1                       |
|                                        |             |          |                                                            |startingUserBalance=1                             |
|                                        |             |          |                                                            |user=0x2711                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserZeroUserBalance:
Assert message: liquidator balance incorrect - certora/specs/SharePrice.spec line 66
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/97deb37041da4d039956c18ad9362a69?anonymousKey=e028d662349173974694bacc703ec79d2e5236b4
Finished verification request
ERROR: Prover found violations:
[rule] fixingUserZeroUserBalance: FAIL
```
</details>

## Mutation 23
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 23 [RequireMutation] ===

--- original
+++ mutant
@@ -85,7 +85,8 @@
         require(msg.sender == admin, "only the admin may call fixUser");
 
         /// ensure nothing strange can happen with incorrect liquidator
-        require(liquidator != user, "liquidator cannot be user");
+        /// RequireMutation(`liquidator != user` |==> `true`) of: `require(liquidator != user, "liquidator cannot be user");`
+        require(true, "liquidator cannot be user");
 
         require(accrueInterest() == 0, "accrue interest failed");
 

Path: mutants/23/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 45
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: Error != expected error: cannot liquidate user without borrows != liquidator cannot be user] testFixUserFailsUserEqLiquidator() (gas: 30894)

Encountered a total of 1 failing tests, 45 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Violated     |4         |Assert message: liquidator balance incorrect -              |MockERC20=MockERC20 (2)                           |
|                                        |             |          |certora/specs/SharePrice.spec line 66                       |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2711)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2713                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x4a02                                 |
|                                        |             |          |                                                            |startingLiquidatorBalance=1                       |
|                                        |             |          |                                                            |startingUserBalance=1                             |
|                                        |             |          |                                                            |user=0x4a02                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserZeroUserBalance:
Assert message: liquidator balance incorrect - certora/specs/SharePrice.spec line 66
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/55968105d30947e2b83328ffaca4a3dd?anonymousKey=a79e508332fc1e102838aea6ba766c6cc8e3ffe9
Finished verification request
ERROR: Prover found violations:
[rule] fixingUserZeroUserBalance: FAIL
```
</details>

## Mutation 24
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 24 [RequireMutation] ===

--- original
+++ mutant
@@ -85,7 +85,8 @@
         require(msg.sender == admin, "only the admin may call fixUser");
 
         /// ensure nothing strange can happen with incorrect liquidator
-        require(liquidator != user, "liquidator cannot be user");
+        /// RequireMutation(`liquidator != user` |==> `false`) of: `require(liquidator != user, "liquidator cannot be user");`
+        require(false, "liquidator cannot be user");
 
         require(accrueInterest() == 0, "accrue interest failed");
 

Path: mutants/24/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: revert: Timelock::executeTransaction: Transaction execution reverted.] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|fixUserIncreasesBadDebt                 |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Sanity check |4         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRules                            |Sanity check |5         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserZeroUserBalance:
Failed on fixUserIncreasesBadDebt:
Failed on fixingUserDoesNotChangeSharePrice:
Failed on badDebtSymmetry:
Failed on badDebtRules:
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/a2961b64aab548ed8a075f3609c74876?anonymousKey=b524c48ad209edc8ea5beea42e3610a18d8c5a8c
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] fixUser(address,address)[rule] badDebtSymmetry: 
  [func] fixUser(address,address)[rule] fixUserIncreasesBadDebt: SANITY_FAIL[rule] fixingUserDoesNotChangeSharePrice: SANITY_FAIL[rule] fixingUserZeroUserBalance: SANITY_FAIL
```
</details>

## Mutation 25
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 25 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -87,7 +87,8 @@
         /// ensure nothing strange can happen with incorrect liquidator
         require(liquidator != user, "liquidator cannot be user");
 
-        require(accrueInterest() == 0, "accrue interest failed");
+        /// DeleteExpressionMutation(`require(accrueInterest() == 0, "accrue interest failed")` |==> `assert(true)`) of: `require(accrueInterest() == 0, "accrue interest failed");`
+        assert(true);
 
         /// @dev fetch user's current borrow balance, first updating interest index
         uint256 principal = borrowBalanceStored(user);

Path: mutants/25/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: assertion failed] testSetUp() (gas: 251376)
[FAIL. Reason: assertion failed] testSetUpxcDot() (gas: 137724)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |5         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/0bf53419c9e44ef3816eda8d0997576e?anonymousKey=badd779202646d0ad379753a81d07490bdde4a4b
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 26
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 26 [RequireMutation] ===

--- original
+++ mutant
@@ -87,7 +87,8 @@
         /// ensure nothing strange can happen with incorrect liquidator
         require(liquidator != user, "liquidator cannot be user");
 
-        require(accrueInterest() == 0, "accrue interest failed");
+        /// RequireMutation(`accrueInterest() == 0` |==> `true`) of: `require(accrueInterest() == 0, "accrue interest failed");`
+        require(true, "accrue interest failed");
 
         /// @dev fetch user's current borrow balance, first updating interest index
         uint256 principal = borrowBalanceStored(user);

Path: mutants/26/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: assertion failed] testSetUp() (gas: 251376)
[FAIL. Reason: assertion failed] testSetUpxcDot() (gas: 137724)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/f4dea1ed5bdd47c8a8fa19dc1005fe42?anonymousKey=d9226e6511b950121e114bc5dbd29f56cbb1c2b2
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 27
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 27 [RequireMutation] ===

--- original
+++ mutant
@@ -87,7 +87,8 @@
         /// ensure nothing strange can happen with incorrect liquidator
         require(liquidator != user, "liquidator cannot be user");
 
-        require(accrueInterest() == 0, "accrue interest failed");
+        /// RequireMutation(`accrueInterest() == 0` |==> `false`) of: `require(accrueInterest() == 0, "accrue interest failed");`
+        require(false, "accrue interest failed");
 
         /// @dev fetch user's current borrow balance, first updating interest index
         uint256 principal = borrowBalanceStored(user);

Path: mutants/27/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: revert: Timelock::executeTransaction: Transaction execution reverted.] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|fixUserIncreasesBadDebt                 |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Sanity check |3         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Sanity check |5         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserZeroUserBalance:
Failed on fixingUserDoesNotChangeSharePrice:
Failed on fixUserIncreasesBadDebt:
Failed on badDebtSymmetry:
Failed on badDebtRules:
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/62b1d223f3d64e32a82a17d54239ad54?anonymousKey=36f5249471ae017927f2f5abd702f44079f32a0f
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] fixUser(address,address)[rule] badDebtSymmetry: 
  [func] fixUser(address,address)[rule] fixUserIncreasesBadDebt: SANITY_FAIL[rule] fixingUserDoesNotChangeSharePrice: SANITY_FAIL[rule] fixingUserZeroUserBalance: SANITY_FAIL
```
</details>

## Mutation 28
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 28 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -92,7 +92,8 @@
         /// @dev fetch user's current borrow balance, first updating interest index
         uint256 principal = borrowBalanceStored(user);
 
-        require(principal != 0, "cannot liquidate user without borrows");
+        /// DeleteExpressionMutation(`require(principal != 0, "cannot liquidate user without borrows")` |==> `assert(true)`) of: `require(principal != 0, "cannot liquidate user without borrows");`
+        assert(true);
 
         /// user effects
 

Path: mutants/28/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 45
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: call did not revert as expected] testFixUserFailsNoUserBorrows() (gas: 63687)

Encountered a total of 1 failing tests, 45 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Violated     |3         |Assert message: bad debt not increased from fixing a use... |MockERC20=MockERC20 (0x49aa)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 53                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x49a9)                                          |
|                                        |             |          |                                                            |badDebt=0x760                                     |
|                                        |             |          |                                                            |badDebtAfter=0x760                                |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x49a8                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |interestIndex=0                                   |
|                                        |             |          |                                                            |liquidator=0x2e15                                 |
|                                        |             |          |                                                            |principle=0                                       |
|                                        |             |          |                                                            |user=0x2e16                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixUserIncreasesBadDebt:
Assert message: bad debt not increased from fixing a use... - certora/specs/SharePrice.spec line 53
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/1c99e60a295445c488fb1eefd97e252d?anonymousKey=6478d15f8880b1b019bb7e3ef8a4a79e3f07e1d9
Finished verification request
ERROR: Prover found violations:
[rule] fixUserIncreasesBadDebt: FAIL
```
</details>

## Mutation 29
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 29 [RequireMutation] ===

--- original
+++ mutant
@@ -92,7 +92,8 @@
         /// @dev fetch user's current borrow balance, first updating interest index
         uint256 principal = borrowBalanceStored(user);
 
-        require(principal != 0, "cannot liquidate user without borrows");
+        /// RequireMutation(`principal != 0` |==> `true`) of: `require(principal != 0, "cannot liquidate user without borrows");`
+        require(true, "cannot liquidate user without borrows");
 
         /// user effects
 

Path: mutants/29/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 45
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: call did not revert as expected] testFixUserFailsNoUserBorrows() (gas: 63687)

Encountered a total of 1 failing tests, 45 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Violated     |3         |Assert message: bad debt not increased from fixing a use... |MockERC20=MockERC20 (1)                           |
|                                        |             |          |- certora/specs/SharePrice.spec line 53                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(2)                                               |
|                                        |             |          |                                                            |badDebt=0                                         |
|                                        |             |          |                                                            |badDebtAfter=0                                    |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockMErc20DelegateFixer (2)          |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |interestIndex=0                                   |
|                                        |             |          |                                                            |liquidator=0x2711                                 |
|                                        |             |          |                                                            |principle=0                                       |
|                                        |             |          |                                                            |user=0x2712                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixUserIncreasesBadDebt:
Assert message: bad debt not increased from fixing a use... - certora/specs/SharePrice.spec line 53
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/acc9ad0b781744ae89ff5f7a38fcd509?anonymousKey=a991a783dcbd599923ee72e06757967cbea37f82
Finished verification request
ERROR: Prover found violations:
[rule] fixUserIncreasesBadDebt: FAIL
```
</details>

## Mutation 30
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 30 [RequireMutation] ===

--- original
+++ mutant
@@ -92,7 +92,8 @@
         /// @dev fetch user's current borrow balance, first updating interest index
         uint256 principal = borrowBalanceStored(user);
 
-        require(principal != 0, "cannot liquidate user without borrows");
+        /// RequireMutation(`principal != 0` |==> `false`) of: `require(principal != 0, "cannot liquidate user without borrows");`
+        require(false, "cannot liquidate user without borrows");
 
         /// user effects
 

Path: mutants/30/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: revert: Timelock::executeTransaction: Transaction execution reverted.] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|fixUserIncreasesBadDebt                 |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Sanity check |4         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |4         |                                                            |no local variables                                |
|badDebtRules                            |Sanity check |4         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserZeroUserBalance:
Failed on fixUserIncreasesBadDebt:
Failed on fixingUserDoesNotChangeSharePrice:
Failed on badDebtSymmetry:
Failed on badDebtRules:
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/85c1b34890fb4c328a2c30fb2ce3093d?anonymousKey=019b8b77b3d42bead358297345303bab7d8f02d0
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] fixUser(address,address)[rule] badDebtSymmetry: 
  [func] fixUser(address,address)[rule] fixUserIncreasesBadDebt: SANITY_FAIL[rule] fixingUserDoesNotChangeSharePrice: SANITY_FAIL[rule] fixingUserZeroUserBalance: SANITY_FAIL
```
</details>

## Mutation 31
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 31 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -97,7 +97,8 @@
         /// user effects
 
         /// @dev zero balance
-        accountBorrows[user].principal = 0;
+        /// DeleteExpressionMutation(`accountBorrows[user].principal = 0` |==> `assert(true)`) of: `accountBorrows[user].principal = 0;`
+        assert(true);
         accountBorrows[user].interestIndex = borrowIndex;
 
         /// @dev current amount for a user that we'll transfer to the liquidator

Path: mutants/31/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: execution error] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |2         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |4         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |2         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/b5e02c8be0eb4eed9ea7766addf7712b?anonymousKey=5e21d65b6a3b4ed1642c0ca76533f47aea0c2137
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 32
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 32 [AssignmentMutation] ===

--- original
+++ mutant
@@ -97,7 +97,8 @@
         /// user effects
 
         /// @dev zero balance
-        accountBorrows[user].principal = 0;
+        /// AssignmentMutation(`0` |==> `1`) of: `accountBorrows[user].principal = 0;`
+        accountBorrows[user].principal = 1;
         accountBorrows[user].interestIndex = borrowIndex;
 
         /// @dev current amount for a user that we'll transfer to the liquidator

Path: mutants/32/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: execution error] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |4         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/5c2508415f89419f88d38f6b6011316e?anonymousKey=5af94373707abbf282c215b6fb9b8005dde38cc4
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 33
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 33 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -98,7 +98,8 @@
 
         /// @dev zero balance
         accountBorrows[user].principal = 0;
-        accountBorrows[user].interestIndex = borrowIndex;
+        /// DeleteExpressionMutation(`accountBorrows[user].interestIndex = borrowIndex` |==> `assert(true)`) of: `accountBorrows[user].interestIndex = borrowIndex;`
+        assert(true);
 
         /// @dev current amount for a user that we'll transfer to the liquidator
         uint256 liquidated = accountTokens[user];

Path: mutants/33/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 0, Passed Tests: 46

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |6         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/dc36ea177c6b45d79a2757ad62eab4b1?anonymousKey=b9d47febedff07299b263cb6c897de4357cdce00
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 34
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 34 [AssignmentMutation] ===

--- original
+++ mutant
@@ -98,7 +98,8 @@
 
         /// @dev zero balance
         accountBorrows[user].principal = 0;
-        accountBorrows[user].interestIndex = borrowIndex;
+        /// AssignmentMutation(`borrowIndex` |==> `0`) of: `accountBorrows[user].interestIndex = borrowIndex;`
+        accountBorrows[user].interestIndex = 0;
 
         /// @dev current amount for a user that we'll transfer to the liquidator
         uint256 liquidated = accountTokens[user];

Path: mutants/34/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 0, Passed Tests: 46

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/30fa7811fd2a4833a065de2f43b4ba65?anonymousKey=8e4554d4f38acf2bf20ab1d2352468542b73dfb6
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 35
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 35 [AssignmentMutation] ===

--- original
+++ mutant
@@ -98,7 +98,8 @@
 
         /// @dev zero balance
         accountBorrows[user].principal = 0;
-        accountBorrows[user].interestIndex = borrowIndex;
+        /// AssignmentMutation(`borrowIndex` |==> `1`) of: `accountBorrows[user].interestIndex = borrowIndex;`
+        accountBorrows[user].interestIndex = 1;
 
         /// @dev current amount for a user that we'll transfer to the liquidator
         uint256 liquidated = accountTokens[user];

Path: mutants/35/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 0, Passed Tests: 46

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |2         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |1         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |5         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/f4545804ad124226b94c004aadec3ad3?anonymousKey=1c18ceb75eefc57f2bac4d31632336fd598dfba5
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 36
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 36 [IfStatementMutation] ===

--- original
+++ mutant
@@ -104,7 +104,8 @@
         uint256 liquidated = accountTokens[user];
 
         /// can only seize collateral assets if they exist
-        if (liquidated != 0) {
+        /// IfStatementMutation(`liquidated != 0` |==> `true`) of: `if (liquidated != 0) {`
+        if (true) {
             /// if assets were liquidated, give them to the liquidator
             accountTokens[liquidator] = SafeMath.add(
                 accountTokens[liquidator],

Path: mutants/36/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 0, Passed Tests: 46

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/ad1919580a4144c28f3a0a1df43e68e2?anonymousKey=529d57b962af5fc7d582d14728d42be1f73c9112
Finished verification request
No errors found by Prover!
```
</details>

## Mutation 37
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 37 [IfStatementMutation] ===

--- original
+++ mutant
@@ -104,7 +104,8 @@
         uint256 liquidated = accountTokens[user];
 
         /// can only seize collateral assets if they exist
-        if (liquidated != 0) {
+        /// IfStatementMutation(`liquidated != 0` |==> `false`) of: `if (liquidated != 0) {`
+        if (false) {
             /// if assets were liquidated, give them to the liquidator
             accountTokens[liquidator] = SafeMath.add(
                 accountTokens[liquidator],

Path: mutants/37/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: execution error] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Violated     |3         |Assert message: user balance should be zero after fix -     |MockERC20=MockERC20                               |
|                                        |             |          |certora/specs/SharePrice.spec line 65                       |(0xbfffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.block.basefee=0x7fffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffff                  |
|                                        |             |          |                                                            |e.block.coinbase=MockMErc20DelegateFixer          |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.block.difficulty=0x7ffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffffff               |
|                                        |             |          |                                                            |e.block.gaslimit=0x7ffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffff                 |
|                                        |             |          |                                                            |e.block.number=0x7ffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffff                   |
|                                        |             |          |                                                            |e.block.timestamp=0x7fffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffffff                |
|                                        |             |          |                                                            |e.msg.sender=MockMErc20DelegateFixer              |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=MockMErc20DelegateFixer               |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |liquidator=MockMErc20DelegateFixer                |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |startingLiquidatorBalance=0x8000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000000000000000000000        |
|                                        |             |          |                                                            |startingUserBalance=0x8000000000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000000000000000              |
|                                        |             |          |                                                            |user=MockERC20                                    |
|                                        |             |          |                                                            |(0xbfffffffffffffffffffffffffffffffffffffff)      |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserZeroUserBalance:
Assert message: user balance should be zero after fix - certora/specs/SharePrice.spec line 65
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/dfccb5958e7d4f7c816525dea535b98c?anonymousKey=657d4840ec6aa1354282ee47a06ad5f6ac00c0f8
Finished verification request
ERROR: Prover found violations:
[rule] fixingUserZeroUserBalance: FAIL
```
</details>

## Mutation 38
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 38 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -112,7 +112,8 @@
             );
 
             /// zero out the user's tokens
-            delete accountTokens[user];
+            /// DeleteExpressionMutation(`delete accountTokens[user]` |==> `assert(true)`) of: `delete accountTokens[user];`
+            assert(true);
         }
 
         /// global effects

Path: mutants/38/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: execution error] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Violated     |3         |Assert message: user balance should be zero after fix -     |MockERC20=MockERC20 (243)                         |
|                                        |             |          |certora/specs/SharePrice.spec line 65                       |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2715)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2714                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x2712                                 |
|                                        |             |          |                                                            |startingLiquidatorBalance=0                       |
|                                        |             |          |                                                            |startingUserBalance=1                             |
|                                        |             |          |                                                            |user=0x2713                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |4         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |5         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserZeroUserBalance:
Assert message: user balance should be zero after fix - certora/specs/SharePrice.spec line 65
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/87f85418edce4233b4cc84f46bff56a5?anonymousKey=ad86f60a636e40d9cd551b7d8ae29b0c74df4660
Finished verification request
ERROR: Prover found violations:
[rule] fixingUserZeroUserBalance: FAIL
```
</details>

## Mutation 39
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 39 [UnaryOperatorMutation] ===

--- original
+++ mutant
@@ -112,7 +112,8 @@
             );
 
             /// zero out the user's tokens
-            delete accountTokens[user];
+            /// UnaryOperatorMutation(`delete` |==> `++`) of: `delete accountTokens[user];`
+            ++ accountTokens[user];
         }
 
         /// global effects

Path: mutants/39/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: execution error] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
WARNING: 'send_only' is deprecated and is now the default. In CI, use 'wait_for_results false' instead
WARNING: Incompatible package certora-cli version 6.3.1 with the latest version 7.0.7. Please upgrade by running:
pip install certora-cli --upgrade
or
pip3 install certora-cli --upgrade
Compiling test/mock/MockERC20.sol...
Compiling test/mock/MockERC20.sol to expose internal function information...
Compiling test/mock/MockMErc20DelegateFixer.sol...
Compiling test/mock/MockMErc20DelegateFixer.sol to expose internal function information...

Connecting to server...

ERROR: An error occurred: couldn't upload file - .certora_internal/e9098173bfb642a28418bb9b03f3bc20.zip
ssl.SSLEOFError: EOF occurred in violation of protocol (_ssl.c:2426)

During handling of the above exception, another exception occurred:

urllib3.exceptions.MaxRetryError: HTTPSConnectionPool(host='certora-prod.s3.amazonaws.com', port=443): Max retries exceeded with url: /uploadFiles/925723/e9098173bfb642a28418bb9b03f3bc20.zip?AWSAccessKeyId=ASIAXXOD664BDO25DNXC&Signature=2wXzjXkngRv3dI2ZoIjcAU4o5EI%3D&content-type=application%2Fzip&x-amz-security-token=IQoJb3JpZ2luX2VjEMv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLXdlc3QtMiJIMEYCIQCrx2KmKJUwvLzr2TX%2FL2P5H7TiSX2sCoBEqqLqcTIjJgIhANvopE9J6t0CV7iCwpiuacwSAAhTaPAVshst8qmGf4jRKo8DCNT%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQAxoMNTMxMzc2MzA1OTIyIgwOgX5dy9kMU%2F29yRUq4wJCNL5XJoWerCaFF2y7K89Vo6ArqYImD%2BHGKv5ciIMlDQh6Rl35ud%2BX8dQggR6IIP%2FxkMrts6dhN8l7eajNiSv8NZufb9O1JTH32LRJRMB9vqQkYyAPWq%2F67aN1F3G2tPykUw8Qx7Pmut%2FLUNmvBsjLnS8%2FndLNdTwrcYBFTm1pNpp2IVuE8XS2ypHMi%2BIVJddLDZPQTgTtWkR1fc4K0hPnYjtD1b4aQN2b1IzdMXjy9dZ3iT9WyI5%2BYmdPAEXCRNMAWIayQDWiA1nzDAmnD7PJwQoYoTvmhU83SLgKEntBW6j34fHhRW0Y6CY2yAbjlirev0K2GNLzDudHs2hChrrtXmwGmpi0%2BwQrkBrfylsqNNOSS2cxdsGS4ZAKuuodUYKG7YhlspH6uO%2F2LWfsAMxOq4yz%2FGZt78%2FRmGcIKNeFzj08I1QPSR4gcc0YR9nPlP1fJJVkqh7hQWAaYROt6GdW%2Bb%2FBMJey4K8GOp0BhS7EYOcl1q6%2B5l5vBJQXwUlhhIfRq1xCzU79IfhOLQZkRaS%2BbdpqW3OhecCEk0vfNwDP7hrr%2BLair8TcDDzLqLTUn9UAPV0LCck%2BEIALoaxBmjQNKT7iRaNFJw3IY2Xz9hE%2FdZlA2yUXyxSmhbsnSa18kThBsE5Kl5orQDFXteemEIalUaS0F7QYJnBlSmyLRRaiu7MLwwJ9jjdzhQ%3D%3D&Expires=1710760807 (Caused by SSLError(SSLEOFError(8, 'EOF occurred in violation of protocol (_ssl.c:2426)')))

During handling of the above exception, another exception occurred:

requests.exceptions.SSLError: HTTPSConnectionPool(host='certora-prod.s3.amazonaws.com', port=443): Max retries exceeded with url: /uploadFiles/925723/e9098173bfb642a28418bb9b03f3bc20.zip?AWSAccessKeyId=ASIAXXOD664BDO25DNXC&Signature=2wXzjXkngRv3dI2ZoIjcAU4o5EI%3D&content-type=application%2Fzip&x-amz-security-token=IQoJb3JpZ2luX2VjEMv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLXdlc3QtMiJIMEYCIQCrx2KmKJUwvLzr2TX%2FL2P5H7TiSX2sCoBEqqLqcTIjJgIhANvopE9J6t0CV7iCwpiuacwSAAhTaPAVshst8qmGf4jRKo8DCNT%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQAxoMNTMxMzc2MzA1OTIyIgwOgX5dy9kMU%2F29yRUq4wJCNL5XJoWerCaFF2y7K89Vo6ArqYImD%2BHGKv5ciIMlDQh6Rl35ud%2BX8dQggR6IIP%2FxkMrts6dhN8l7eajNiSv8NZufb9O1JTH32LRJRMB9vqQkYyAPWq%2F67aN1F3G2tPykUw8Qx7Pmut%2FLUNmvBsjLnS8%2FndLNdTwrcYBFTm1pNpp2IVuE8XS2ypHMi%2BIVJddLDZPQTgTtWkR1fc4K0hPnYjtD1b4aQN2b1IzdMXjy9dZ3iT9WyI5%2BYmdPAEXCRNMAWIayQDWiA1nzDAmnD7PJwQoYoTvmhU83SLgKEntBW6j34fHhRW0Y6CY2yAbjlirev0K2GNLzDudHs2hChrrtXmwGmpi0%2BwQrkBrfylsqNNOSS2cxdsGS4ZAKuuodUYKG7YhlspH6uO%2F2LWfsAMxOq4yz%2FGZt78%2FRmGcIKNeFzj08I1QPSR4gcc0YR9nPlP1fJJVkqh7hQWAaYROt6GdW%2Bb%2FBMJey4K8GOp0BhS7EYOcl1q6%2B5l5vBJQXwUlhhIfRq1xCzU79IfhOLQZkRaS%2BbdpqW3OhecCEk0vfNwDP7hrr%2BLair8TcDDzLqLTUn9UAPV0LCck%2BEIALoaxBmjQNKT7iRaNFJw3IY2Xz9hE%2FdZlA2yUXyxSmhbsnSa18kThBsE5Kl5orQDFXteemEIalUaS0F7QYJnBlSmyLRRaiu7MLwwJ9jjdzhQ%3D%3D&Expires=1710760807 (Caused by SSLError(SSLEOFError(8, 'EOF occurred in violation of protocol (_ssl.c:2426)')))
```
</details>

## Mutation 40
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 40 [UnaryOperatorMutation] ===

--- original
+++ mutant
@@ -112,7 +112,8 @@
             );
 
             /// zero out the user's tokens
-            delete accountTokens[user];
+            /// UnaryOperatorMutation(`delete` |==> `--`) of: `delete accountTokens[user];`
+            -- accountTokens[user];
         }
 
         /// global effects

Path: mutants/40/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: execution error] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
WARNING: 'send_only' is deprecated and is now the default. In CI, use 'wait_for_results false' instead
WARNING: Incompatible package certora-cli version 6.3.1 with the latest version 7.0.7. Please upgrade by running:
pip install certora-cli --upgrade
or
pip3 install certora-cli --upgrade
Compiling test/mock/MockERC20.sol...
Compiling test/mock/MockERC20.sol to expose internal function information...
Compiling test/mock/MockMErc20DelegateFixer.sol...
Compiling test/mock/MockMErc20DelegateFixer.sol to expose internal function information...

Connecting to server...
```
</details>

## Mutation 41
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 41 [UnaryOperatorMutation] ===

--- original
+++ mutant
@@ -112,7 +112,8 @@
             );
 
             /// zero out the user's tokens
-            delete accountTokens[user];
+            /// UnaryOperatorMutation(`delete` |==> `~`) of: `delete accountTokens[user];`
+            ~ accountTokens[user];
         }
 
         /// global effects

Path: mutants/41/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: execution error] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Violated     |3         |Assert message: user balance should be zero after fix -     |MockERC20=MockERC20                               |
|                                        |             |          |certora/specs/SharePrice.spec line 65                       |(0xbfffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.block.basefee=0x7fffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffff                  |
|                                        |             |          |                                                            |e.block.coinbase=MockMErc20DelegateFixer          |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.block.difficulty=0x7ffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffffff               |
|                                        |             |          |                                                            |e.block.gaslimit=0x7ffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffff                 |
|                                        |             |          |                                                            |e.block.number=0x7ffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffff                   |
|                                        |             |          |                                                            |e.block.timestamp=0x7fffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffffff                |
|                                        |             |          |                                                            |e.msg.sender=MockMErc20DelegateFixer              |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=MockMErc20DelegateFixer               |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |liquidator=MockERC20                              |
|                                        |             |          |                                                            |(0xbfffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |startingLiquidatorBalance=0x4000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000000000000000000000        |
|                                        |             |          |                                                            |startingUserBalance=0x8000000000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000000000000000              |
|                                        |             |          |                                                            |user=MockMErc20DelegateFixer                      |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |4         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |3         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserZeroUserBalance:
Assert message: user balance should be zero after fix - certora/specs/SharePrice.spec line 65
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/adf2902a068645f188ad8dea675dab98?anonymousKey=8e49c3fc1edf3187ef781f8663a3d1bef903ba42
Finished verification request
ERROR: Prover found violations:
[rule] fixingUserZeroUserBalance: FAIL
```
</details>

## Mutation 42
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 42 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -118,7 +118,8 @@
         /// global effects
 
         /// @dev increment the bad debt counter
-        badDebt = SafeMath.add(badDebt, principal);
+        /// DeleteExpressionMutation(`badDebt = SafeMath.add(badDebt, principal)` |==> `assert(true)`) of: `badDebt = SafeMath.add(badDebt, principal);`
+        assert(true);
 
         /// @dev subtract the previous balance from the totalBorrows balance
         totalBorrows = SafeMath.sub(totalBorrows, principal);

Path: mutants/42/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: execution error] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Violated     |3         |Assert message: bad debt not increased from fixing a use... |MockERC20=MockERC20                               |
|                                        |             |          |- certora/specs/SharePrice.spec line 53                     |(0xbfffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |badDebt=0x8000000000000000000000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000                          |
|                                        |             |          |                                                            |badDebtAfter=0x80000000000000000000000000000000000|
|                                        |             |          |                                                            |00000000000000000000000000000                     |
|                                        |             |          |                                                            |e.block.basefee=0x7fffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffff                  |
|                                        |             |          |                                                            |e.block.coinbase=MockMErc20DelegateFixer          |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.block.difficulty=0x7ffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffffff               |
|                                        |             |          |                                                            |e.block.gaslimit=0x7ffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffffff                 |
|                                        |             |          |                                                            |e.block.number=0x7ffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffffff                   |
|                                        |             |          |                                                            |e.block.timestamp=0x7fffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffffffff                |
|                                        |             |          |                                                            |e.msg.sender=MockMErc20DelegateFixer              |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=MockMErc20DelegateFixer               |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |interestIndex=0x7fffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffff                    |
|                                        |             |          |                                                            |liquidator=0x3ffffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffe                                               |
|                                        |             |          |                                                            |principle=0x7fffffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffff                        |
|                                        |             |          |                                                            |user=0x3fffffffffffffffffffffffffffffffffffffff   |
|fixingUserDoesNotChangeSharePrice       |Violated     |3         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2711)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2713)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2712                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x2fb4                                 |
|                                        |             |          |                                                            |startingSharePrice=2                              |
|                                        |             |          |                                                            |user=0x2fb5                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Violated     |4         |Assert message: borrows bad debt incorrect -                |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 225                      |                                                  |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |4         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixUserIncreasesBadDebt:
Assert message: bad debt not increased from fixing a use... - certora/specs/SharePrice.spec line 53
Failed on fixingUserDoesNotChangeSharePrice:
Assert message: share price should not change fixing use... - certora/specs/SharePrice.spec line 78
Failed on badDebtSymmetry:
Assert message: borrows bad debt incorrect - certora/specs/SharePrice.spec line 225
Violated for: 
fixUser(address,address)
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
fixUser(address,address)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/82d3d5fba0884dd08e5b64a9e77d4a1d?anonymousKey=afb132c8a064493fa316a49ed7f175fa58f047bd
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] fixUser(address,address)[rule] badDebtSymmetry: 
  [func] fixUser(address,address)[rule] fixUserIncreasesBadDebt: FAIL[rule] fixingUserDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 43
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 43 [AssignmentMutation] ===

--- original
+++ mutant
@@ -118,7 +118,8 @@
         /// global effects
 
         /// @dev increment the bad debt counter
-        badDebt = SafeMath.add(badDebt, principal);
+        /// AssignmentMutation(`SafeMath.add(badDebt, principal)` |==> `0`) of: `badDebt = SafeMath.add(badDebt, principal);`
+        badDebt = 0;
 
         /// @dev subtract the previous balance from the totalBorrows balance
         totalBorrows = SafeMath.sub(totalBorrows, principal);

Path: mutants/43/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: execution error] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Violated     |4         |Assert message: bad debt not increased from fixing a use... |MockERC20=MockERC20 (1)                           |
|                                        |             |          |- certora/specs/SharePrice.spec line 53                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(2)                                               |
|                                        |             |          |                                                            |badDebt=initialized to unknown                    |
|                                        |             |          |                                                            |badDebtAfter=initialized to unknown               |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockMErc20DelegateFixer (2)          |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |interestIndex=0                                   |
|                                        |             |          |                                                            |liquidator=0x2711                                 |
|                                        |             |          |                                                            |principle=0                                       |
|                                        |             |          |                                                            |user=0x2712                                       |
|fixingUserDoesNotChangeSharePrice       |Violated     |3         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2714)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2713)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2715                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x472e                                 |
|                                        |             |          |                                                            |startingSharePrice=1                              |
|                                        |             |          |                                                            |user=0x472f                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Violated     |3         |Assert message: borrows bad debt incorrect -                |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 225                      |                                                  |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |4         |Assert message: bad debt should only increase when fixin... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 123                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixUserIncreasesBadDebt:
Assert message: bad debt not increased from fixing a use... - certora/specs/SharePrice.spec line 53
Failed on fixingUserDoesNotChangeSharePrice:
Assert message: share price should not change fixing use... - certora/specs/SharePrice.spec line 78
Failed on badDebtSymmetry:
Assert message: borrows bad debt incorrect - certora/specs/SharePrice.spec line 225
Violated for: 
fixUser(address,address)
Failed on badDebtRules:
Assert message: bad debt should only increase when fixin... - certora/specs/SharePrice.spec line 123
Violated for: 
fixUser(address,address)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/cb64bbe7a57845d1b1258a0e0d9ca2a4?anonymousKey=c974452bfa40698f3b06207c0a8fb4769f97c78c
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] fixUser(address,address)[rule] badDebtSymmetry: 
  [func] fixUser(address,address)[rule] fixUserIncreasesBadDebt: FAIL[rule] fixingUserDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 44
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 44 [AssignmentMutation] ===

--- original
+++ mutant
@@ -118,7 +118,8 @@
         /// global effects
 
         /// @dev increment the bad debt counter
-        badDebt = SafeMath.add(badDebt, principal);
+        /// AssignmentMutation(`SafeMath.add(badDebt, principal)` |==> `1`) of: `badDebt = SafeMath.add(badDebt, principal);`
+        badDebt = 1;
 
         /// @dev subtract the previous balance from the totalBorrows balance
         totalBorrows = SafeMath.sub(totalBorrows, principal);

Path: mutants/44/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: execution error] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Violated     |3         |Assert message: bad debt not increased from fixing a use... |MockERC20=MockERC20 (2)                           |
|                                        |             |          |- certora/specs/SharePrice.spec line 53                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2712)                                          |
|                                        |             |          |                                                            |badDebt=1                                         |
|                                        |             |          |                                                            |badDebtAfter=initialized to unknown               |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2711                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |interestIndex=0                                   |
|                                        |             |          |                                                            |liquidator=0x2711                                 |
|                                        |             |          |                                                            |principle=0                                       |
|                                        |             |          |                                                            |user=MockMErc20DelegateFixer (0x2712)             |
|fixingUserDoesNotChangeSharePrice       |Violated     |4         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2715)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2716)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2715)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x472e                                 |
|                                        |             |          |                                                            |startingSharePrice=2                              |
|                                        |             |          |                                                            |user=0x472f                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |2         |Assert message: borrows bad debt incorrect -                |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 225                      |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |4         |Assert message: bad debt should only increase when fixin... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 123                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixUserIncreasesBadDebt:
Assert message: bad debt not increased from fixing a use... - certora/specs/SharePrice.spec line 53
Failed on fixingUserDoesNotChangeSharePrice:
Assert message: share price should not change fixing use... - certora/specs/SharePrice.spec line 78
Failed on badDebtSymmetry:
Assert message: borrows bad debt incorrect - certora/specs/SharePrice.spec line 225
Violated for: 
fixUser(address,address)
Failed on badDebtRules:
Assert message: bad debt should only increase when fixin... - certora/specs/SharePrice.spec line 123
Violated for: 
fixUser(address,address)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/05c04105584b4e11b7cb8837d968a218?anonymousKey=3024c1ec8b6e5589799e9f1387359535094c4459
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] fixUser(address,address)[rule] badDebtSymmetry: 
  [func] fixUser(address,address)[rule] fixUserIncreasesBadDebt: FAIL[rule] fixingUserDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 45
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 45 [DeleteExpressionMutation] ===

--- original
+++ mutant
@@ -121,7 +121,8 @@
         badDebt = SafeMath.add(badDebt, principal);
 
         /// @dev subtract the previous balance from the totalBorrows balance
-        totalBorrows = SafeMath.sub(totalBorrows, principal);
+        /// DeleteExpressionMutation(`totalBorrows = SafeMath.sub(totalBorrows, principal)` |==> `assert(true)`) of: `totalBorrows = SafeMath.sub(totalBorrows, principal);`
+        assert(true);
 
         emit UserFixed(user, liquidator, liquidated);
     }

Path: mutants/45/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: assertion failed] testSetUp() (gas: 236262)
[FAIL. Reason: assertion failed] testSetUpxcDot() (gas: 117140)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Violated     |4         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2712)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2713)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2712)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x4c4c                                 |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|                                        |             |          |                                                            |user=0x4c4d                                       |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |3         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserDoesNotChangeSharePrice:
Assert message: share price should not change fixing use... - certora/specs/SharePrice.spec line 78
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
fixUser(address,address)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/038ca56e40094a3aa914e99a8dae4fca?anonymousKey=b50a03efeb4cf9fcccf7629e3c233a9ad8226831
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] fixUser(address,address)[rule] fixingUserDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 46
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 46 [AssignmentMutation] ===

--- original
+++ mutant
@@ -121,7 +121,8 @@
         badDebt = SafeMath.add(badDebt, principal);
 
         /// @dev subtract the previous balance from the totalBorrows balance
-        totalBorrows = SafeMath.sub(totalBorrows, principal);
+        /// AssignmentMutation(`SafeMath.sub(totalBorrows, principal)` |==> `0`) of: `totalBorrows = SafeMath.sub(totalBorrows, principal);`
+        totalBorrows = 0;
 
         emit UserFixed(user, liquidator, liquidated);
     }

Path: mutants/46/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: assertion failed] testSetUp() (gas: 236262)
[FAIL. Reason: assertion failed] testSetUpxcDot() (gas: 117140)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Violated     |4         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2711)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2712)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2711)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x3149                                 |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|                                        |             |          |                                                            |user=0x314a                                       |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Violated     |4         |Assert message: borrows bad debt incorrect -                |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 225                      |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |4         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserDoesNotChangeSharePrice:
Assert message: share price should not change fixing use... - certora/specs/SharePrice.spec line 78
Failed on badDebtSymmetry:
Assert message: borrows bad debt incorrect - certora/specs/SharePrice.spec line 225
Violated for: 
fixUser(address,address)
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
fixUser(address,address)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/058138e3faf24d3ca8f78b73c8731939?anonymousKey=15918c83ba05f5fe998f80f2ab950b70e068f631
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] fixUser(address,address)[rule] badDebtSymmetry: 
  [func] fixUser(address,address)[rule] fixingUserDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 47
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 47 [AssignmentMutation] ===

--- original
+++ mutant
@@ -121,7 +121,8 @@
         badDebt = SafeMath.add(badDebt, principal);
 
         /// @dev subtract the previous balance from the totalBorrows balance
-        totalBorrows = SafeMath.sub(totalBorrows, principal);
+        /// AssignmentMutation(`SafeMath.sub(totalBorrows, principal)` |==> `1`) of: `totalBorrows = SafeMath.sub(totalBorrows, principal);`
+        totalBorrows = 1;
 
         emit UserFixed(user, liquidator, liquidated);
     }

Path: mutants/47/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 2, Passed Tests: 44
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 2 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: assertion failed] testSetUp() (gas: 236262)
[FAIL. Reason: assertion failed] testSetUpxcDot() (gas: 117140)

Encountered a total of 2 failing tests, 44 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Violated     |5         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2712)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2714)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2712)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x2b65                                 |
|                                        |             |          |                                                            |startingSharePrice=0xde0b6b3a7640000              |
|                                        |             |          |                                                            |user=0x2b66                                       |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |4         |Assert message: borrows bad debt incorrect -                |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 225                      |                                                  |
|badDebtRules                            |Violated     |4         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserDoesNotChangeSharePrice:
Assert message: share price should not change fixing use... - certora/specs/SharePrice.spec line 78
Failed on badDebtSymmetry:
Assert message: borrows bad debt incorrect - certora/specs/SharePrice.spec line 225
Violated for: 
fixUser(address,address)
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
fixUser(address,address)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/ad468bda57064108b30e13bb26ef74cc?anonymousKey=70194e156807bcf432d1e88847bf75967995d0d8
Finished verification request
ERROR: Prover found violations:
[rule] badDebtRules: 
  [func] fixUser(address,address)[rule] badDebtSymmetry: 
  [func] fixUser(address,address)[rule] fixingUserDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 48
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 48 [BinaryOpMutation] ===

--- original
+++ mutant
@@ -131,6 +131,7 @@
     function getCashPrior() internal view returns (uint256) {
         /// safe math unused intentionally, should never overflow as the sum
         /// should never be greater than UINT_MAX
-        return EIP20Interface(underlying).balanceOf(address(this)) + badDebt;
+        /// BinaryOpMutation(`+` |==> `-`) of: `return EIP20Interface(underlying).balanceOf(address(this)) + badDebt;`
+        return EIP20Interface(underlying).balanceOf(address(this))-badDebt;
     }
 }

Path: mutants/48/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: execution error] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|badDebtRulesCash                        |Violated     |4         |Assert message: bad debt should not increase when repayi... |MockERC20=MockERC20 (1)                           |
|                                        |             |          |- certora/specs/SharePrice.spec line 147                    |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(2)                                               |
|                                        |             |          |                                                            |amount=0                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2711                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=1                                   |
|                                        |             |          |                                                            |startingBadDebt=1                                 |
|                                        |             |          |                                                            |startingCash=0                                    |
|allBadDebtRulesCash                     |Violated     |4         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |4         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (0x2711)                      |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2712)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2711)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingSharePrice=0x1bc16d674ec80000               |
|                                        |             |          |                                                            |startingSharePrice=0xde0b6b3a7640000              |
|fixingUserDoesNotChangeSharePrice       |Violated     |4         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2711)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2715)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2714                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x2712                                 |
|                                        |             |          |                                                            |startingSharePrice=0x1bc16d674ec80000             |
|                                        |             |          |                                                            |user=MockERC20 (0x2711)                           |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |4         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on badDebtRulesCash:
Assert message: bad debt should not increase when repayi... - certora/specs/SharePrice.spec line 147
Failed on allBadDebtRulesCash:
Assert message: cash not correct - certora/specs/SharePrice.spec line 171
Violated for: 
repayBadDebtWithCash(uint256),
repayBadDebtWithReserves()
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on fixingUserDoesNotChangeSharePrice:
Assert message: share price should not change fixing use... - certora/specs/SharePrice.spec line 78
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithCash(uint256),
fixUser(address,address),
repayBadDebtWithReserves()
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/73311518a39f418ba51c34ce8fc913dd?anonymousKey=fd2665f180fd06e954a73ad376b688c1c795063f
Finished verification request
ERROR: Prover found violations:
[rule] allBadDebtRulesCash: 
  [func] repayBadDebtWithCash(uint256)
  [func] repayBadDebtWithReserves()[rule] badDebtRules: 
  [func] fixUser(address,address)
  [func] repayBadDebtWithCash(uint256)
  [func] repayBadDebtWithReserves()[rule] badDebtRulesCash: FAIL[rule] fixingUserDoesNotChangeSharePrice: FAIL[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 49
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 49 [BinaryOpMutation] ===

--- original
+++ mutant
@@ -131,6 +131,7 @@
     function getCashPrior() internal view returns (uint256) {
         /// safe math unused intentionally, should never overflow as the sum
         /// should never be greater than UINT_MAX
-        return EIP20Interface(underlying).balanceOf(address(this)) + badDebt;
+        /// BinaryOpMutation(`+` |==> `*`) of: `return EIP20Interface(underlying).balanceOf(address(this)) + badDebt;`
+        return EIP20Interface(underlying).balanceOf(address(this))*badDebt;
     }
 }

Path: mutants/49/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 17, Passed Tests: 29
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 17 failing tests in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: assertion failed] testCashEqualsUnderlyingBalancePlusBalance() (gas: 82309)
[FAIL. Reason: assertion failed] testExitMarketWithActiveBorrow() (gas: 577170)
[FAIL. Reason: assertion failed; counterexample: calldata=0x7ed063e60000000000000000000000000000000000000000000000000000000000000000 args=[0]] testIncreaseBadDebtIncreasesCash(uint256) (runs: 0, μ: 0, ~: 0)
[FAIL. Reason: assertion failed] testLiquidateBorrowFrax() (gas: 925618)
[FAIL. Reason: assertion failed] testLiquidateBorrowxcDOT() (gas: 1027833)
[FAIL. Reason: assertion failed] testMintBorrow() (gas: 548784)
[FAIL. Reason: assertion failed] testMintBorrowCapReached() (gas: 517286)
[FAIL. Reason: assertion failed] testMintBorrowMaxAmount() (gas: 690386)
[FAIL. Reason: revert: ERC20: transfer amount exceeds balance] testMintBorrowRepay() (gas: 783834)
[FAIL. Reason: assertion failed] testMintBorrowRepayMorethanBorrowed() (gas: 770105)
[FAIL. Reason: revert: REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED] testMintBorrowRepayOnBehalf() (gas: 970844)
[FAIL. Reason: assertion failed] testMintClaimRewardsSupplier() (gas: 1949115)
[FAIL. Reason: assertion failed; counterexample: calldata=0xf70f04650000000000000000000000000000000000000000000000000000000000000000 args=[0]] testRepayBadDebtSucceeds(uint256) (runs: 0, μ: 0, ~: 0)
[FAIL. Reason: assertion failed] testRepayBadDebtWithNoReservesFails() (gas: 77556)
[FAIL. Reason: assertion failed] testRepayBadDebtWithReservesSucceeds() (gas: 72143)
[FAIL. Reason: assertion failed] testSetUp() (gas: 251378)
[FAIL. Reason: panic: arithmetic underflow or overflow (0x11)] testSetUpxcDot() (gas: 20895)

Encountered a total of 17 failing tests, 29 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Violated     |3         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
|badDebtRulesCash                        |Violated     |4         |Assert message: bad debt should not increase when repayi... |MockERC20=MockERC20 (0x2712)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 147                    |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2713)                                          |
|                                        |             |          |                                                            |amount=0                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2712)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=0x8000000000000000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000000c2a                    |
|                                        |             |          |                                                            |startingBadDebt=0x80000000000000000000000000000000|
|                                        |             |          |                                                            |00000000000000000000000000000c2a                  |
|                                        |             |          |                                                            |startingCash=1                                    |
|fixingUserDoesNotChangeSharePrice       |Violated     |4         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (2)                           |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(1)                                               |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0                                    |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x4956                                 |
|                                        |             |          |                                                            |startingSharePrice=1                              |
|                                        |             |          |                                                            |user=0x4957                                       |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |5         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (0x2711)                      |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(1)                                               |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0                                    |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingSharePrice=0                                |
|                                        |             |          |                                                            |startingSharePrice=1                              |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |4         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on allBadDebtRulesCash:
Assert message: cash not correct - certora/specs/SharePrice.spec line 171
Violated for: 
repayBadDebtWithReserves(),
repayBadDebtWithCash(uint256)
Failed on badDebtRulesCash:
Assert message: bad debt should not increase when repayi... - certora/specs/SharePrice.spec line 147
Failed on fixingUserDoesNotChangeSharePrice:
Assert message: share price should not change fixing use... - certora/specs/SharePrice.spec line 78
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
fixUser(address,address),
repayBadDebtWithCash(uint256),
repayBadDebtWithReserves()
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/06191e56b40042178579776c6e09ddf9?anonymousKey=0478f844a31cba22489dd576e76ef5885356ba6d
Finished verification request
ERROR: Prover found violations:
[rule] allBadDebtRulesCash: 
  [func] repayBadDebtWithCash(uint256)
  [func] repayBadDebtWithReserves()[rule] badDebtRules: 
  [func] fixUser(address,address)
  [func] repayBadDebtWithCash(uint256)
  [func] repayBadDebtWithReserves()[rule] badDebtRulesCash: FAIL[rule] fixingUserDoesNotChangeSharePrice: FAIL[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 50
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 50 [BinaryOpMutation] ===

--- original
+++ mutant
@@ -131,6 +131,7 @@
     function getCashPrior() internal view returns (uint256) {
         /// safe math unused intentionally, should never overflow as the sum
         /// should never be greater than UINT_MAX
-        return EIP20Interface(underlying).balanceOf(address(this)) + badDebt;
+        /// BinaryOpMutation(`+` |==> `/`) of: `return EIP20Interface(underlying).balanceOf(address(this)) + badDebt;`
+        return EIP20Interface(underlying).balanceOf(address(this))/badDebt;
     }
 }

Path: mutants/50/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: revert: Timelock::executeTransaction: Transaction execution reverted.] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|badDebtRulesCash                        |Violated     |3         |Assert message: bad debt should not increase when repayi... |MockERC20=MockERC20 (1)                           |
|                                        |             |          |- certora/specs/SharePrice.spec line 147                    |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(2)                                               |
|                                        |             |          |                                                            |amount=0                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2711                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=1                                   |
|                                        |             |          |                                                            |startingBadDebt=1                                 |
|                                        |             |          |                                                            |startingCash=0                                    |
|allBadDebtRulesCash                     |Violated     |3         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |4         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (0x2711)                      |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2712)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2711)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingSharePrice=1                                |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|fixingUserDoesNotChangeSharePrice       |Violated     |4         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2712)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2713)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2712)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x2ff7                                 |
|                                        |             |          |                                                            |startingSharePrice=0xde0b6b3a7640000              |
|                                        |             |          |                                                            |user=0x2ff8                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |3         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on badDebtRulesCash:
Assert message: bad debt should not increase when repayi... - certora/specs/SharePrice.spec line 147
Failed on allBadDebtRulesCash:
Assert message: cash not correct - certora/specs/SharePrice.spec line 171
Violated for: 
repayBadDebtWithReserves(),
repayBadDebtWithCash(uint256)
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on fixingUserDoesNotChangeSharePrice:
Assert message: share price should not change fixing use... - certora/specs/SharePrice.spec line 78
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithCash(uint256),
repayBadDebtWithReserves(),
fixUser(address,address)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/b5f03cab626147f0b46307a4cd7fd9c0?anonymousKey=ca08a05ecf9165f6cef9d4cbf84463efccbee21e
Finished verification request
ERROR: Prover found violations:
[rule] allBadDebtRulesCash: 
  [func] repayBadDebtWithCash(uint256)
  [func] repayBadDebtWithReserves()[rule] badDebtRules: 
  [func] fixUser(address,address)
  [func] repayBadDebtWithCash(uint256)
  [func] repayBadDebtWithReserves()[rule] badDebtRulesCash: FAIL[rule] fixingUserDoesNotChangeSharePrice: FAIL[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 51
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 51 [BinaryOpMutation] ===

--- original
+++ mutant
@@ -131,6 +131,7 @@
     function getCashPrior() internal view returns (uint256) {
         /// safe math unused intentionally, should never overflow as the sum
         /// should never be greater than UINT_MAX
-        return EIP20Interface(underlying).balanceOf(address(this)) + badDebt;
+        /// BinaryOpMutation(`+` |==> `%`) of: `return EIP20Interface(underlying).balanceOf(address(this)) + badDebt;`
+        return EIP20Interface(underlying).balanceOf(address(this))%badDebt;
     }
 }

Path: mutants/51/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: revert: Timelock::executeTransaction: Transaction execution reverted.] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |3         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (0x2711)                      |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2712)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2711)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingSharePrice=1                                |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Violated     |3         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
|badDebtRulesCash                        |Violated     |4         |Assert message: bad debt should not increase when repayi... |MockERC20=MockERC20 (0x2711)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 147                    |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x282b)                                          |
|                                        |             |          |                                                            |amount=0                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x282a                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=0xffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffd222                    |
|                                        |             |          |                                                            |startingBadDebt=0xffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffd222                  |
|                                        |             |          |                                                            |startingCash=0x1c67                               |
|fixingUserDoesNotChangeSharePrice       |Violated     |4         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2712)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2711)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2712)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x352a                                 |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|                                        |             |          |                                                            |user=0x352b                                       |
|fixUserIncreasesBadDebt                 |Not violated |2         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |2         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on allBadDebtRulesCash:
Assert message: cash not correct - certora/specs/SharePrice.spec line 171
Violated for: 
repayBadDebtWithCash(uint256),
repayBadDebtWithReserves()
Failed on badDebtRulesCash:
Assert message: bad debt should not increase when repayi... - certora/specs/SharePrice.spec line 147
Failed on fixingUserDoesNotChangeSharePrice:
Assert message: share price should not change fixing use... - certora/specs/SharePrice.spec line 78
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithCash(uint256),
repayBadDebtWithReserves(),
fixUser(address,address)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/85c9e2497cd94a618c067df4a801d46f?anonymousKey=9347bf56c40fa0a5b95f8de7cf96ddf4df5698c7
Finished verification request
ERROR: Prover found violations:
[rule] allBadDebtRulesCash: 
  [func] repayBadDebtWithCash(uint256)
  [func] repayBadDebtWithReserves()[rule] badDebtRules: 
  [func] fixUser(address,address)
  [func] repayBadDebtWithCash(uint256)
  [func] repayBadDebtWithReserves()[rule] badDebtRulesCash: FAIL[rule] fixingUserDoesNotChangeSharePrice: FAIL[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation 52
<details>
<summary>View mutation diff</summary>

```


             === Mutant ID: 52 [BinaryOpMutation] ===

--- original
+++ mutant
@@ -131,6 +131,7 @@
     function getCashPrior() internal view returns (uint256) {
         /// safe math unused intentionally, should never overflow as the sum
         /// should never be greater than UINT_MAX
-        return EIP20Interface(underlying).balanceOf(address(this)) + badDebt;
+        /// BinaryOpMutation(`+` |==> `**`) of: `return EIP20Interface(underlying).balanceOf(address(this)) + badDebt;`
+        return EIP20Interface(underlying).balanceOf(address(this))**badDebt;
     }
 }

Path: mutants/52/src/MErc20DelegateFixer.sol
```
</details>

### Integration Tests:
Failed Integration Tests: 1, Passed Tests: 0
<details>
<summary>View Failing tests</summary>

```
Failing tests:
Encountered 1 failing test in test/integration/proposals/mips/mip-m17/mip-m17.t.sol:MIPM17IntegrationTest
[FAIL. Reason: setup failed: execution error] setUp() (gas: 0)

Encountered a total of 1 failing tests, 0 tests succeeded
```
</details>

## Certora Mutation Results: 

<details>
<summary>View Result</summary>

```
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|badDebtRulesCash                        |Violated     |2         |Assert message: bad debt should not increase when repayi... |MockERC20=MockERC20 (0x2711)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 147                    |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x28d3)                                          |
|                                        |             |          |                                                            |amount=0                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x28d2                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=0                                   |
|                                        |             |          |                                                            |startingBadDebt=0                                 |
|                                        |             |          |                                                            |startingCash=1                                    |
|allBadDebtRulesCash                     |Violated     |3         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |4         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (0x2711)                      |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2712)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2711)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingSharePrice=3                                |
|                                        |             |          |                                                            |startingSharePrice=2                              |
|fixingUserDoesNotChangeSharePrice       |Violated     |4         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2711)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2713)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2712                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x45df                                 |
|                                        |             |          |                                                            |startingSharePrice=0x6f05b59d3b20000              |
|                                        |             |          |                                                            |user=0x45e0                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |3         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on badDebtRulesCash:
Assert message: bad debt should not increase when repayi... - certora/specs/SharePrice.spec line 147
Failed on allBadDebtRulesCash:
Assert message: cash not correct - certora/specs/SharePrice.spec line 171
Violated for: 
repayBadDebtWithCash(uint256),
repayBadDebtWithReserves()
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on fixingUserDoesNotChangeSharePrice:
Assert message: share price should not change fixing use... - certora/specs/SharePrice.spec line 78
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
fixUser(address,address),
repayBadDebtWithCash(uint256),
repayBadDebtWithReserves()
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/f31d745639154130bd202fbd170cb101?anonymousKey=58e367d35a37143f544c3a53475b4788a4abcc49
Finished verification request
ERROR: Prover found violations:
[rule] allBadDebtRulesCash: 
  [func] repayBadDebtWithCash(uint256)
  [func] repayBadDebtWithReserves()[rule] badDebtRules: 
  [func] fixUser(address,address)
  [func] repayBadDebtWithCash(uint256)
  [func] repayBadDebtWithReserves()[rule] badDebtRulesCash: FAIL[rule] fixingUserDoesNotChangeSharePrice: FAIL[rule] repayBadDebtWithReservesDoesNotChangeSharePrice: FAIL
```
</details>

## Mutation Testing Result
47 failed out of total 52 through integration tests
