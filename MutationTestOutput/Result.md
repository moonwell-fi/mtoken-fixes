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
|repayBadDebtDecreasesBadDebt            |Violated     |3         |Assert message: bad debt not decreased by repay amt -       |MockERC20=MockERC20 (0x47c0)                      |
|                                        |             |          |certora/specs/SharePrice.spec line 94                       |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x47bf)                                          |
|                                        |             |          |                                                            |badDebt=0                                         |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x47be                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |mTokenBalance=0x16dd                              |
|                                        |             |          |                                                            |repayAmount=1                                     |
|                                        |             |          |                                                            |userBalance=0xffffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffe05d                      |
|badDebtRulesCash                        |Violated     |4         |Assert message: cash not the same -                         |MockERC20=MockERC20 (0x2b89)                      |
|                                        |             |          |certora/specs/SharePrice.spec line 144                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2b88)                                          |
|                                        |             |          |                                                            |amount=1                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2b87                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=0                                   |
|                                        |             |          |                                                            |startingBadDebt=0                                 |
|                                        |             |          |                                                            |startingCash=0                                    |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Violated     |3         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |5         |Assert message: share price should not change repaying b... |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/5898b3ca85b74af0a4e6d11f12f4eed9?anonymousKey=70ede511091668b7bb5718cdeda4814bab25cbc8
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
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |2         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |5         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtDecreasesBadDebt:
Assert message: bad debt not decreased by repay amt - certora/specs/SharePrice.spec line 94
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

Job is completed! View the results at https://prover.certora.com/output/925723/53353c93d392467bb6e5655498c7d480?anonymousKey=99dbd40f1b65950cb11c50b7f186d8f068879ce1
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
[FAIL. Reason: revert: exchangeRateStored: exchangeRateStoredInternal failed; counterexample: calldata=0xf70f04650000000000000000000000000000000000000000000000000000000000000000 args=[0]] testRepayBadDebtSucceeds(uint256) (runs: 1, μ: 217954, ~: 217954)

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
|repayBadDebtDecreasesBadDebt            |Violated     |4         |Assert message: bad debt not decreased by repay amt -       |MockERC20=MockERC20 (0x47c0)                      |
|                                        |             |          |certora/specs/SharePrice.spec line 94                       |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x47bf)                                          |
|                                        |             |          |                                                            |badDebt=0                                         |
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
|                                        |             |          |                                                            |repayAmount=49                                    |
|                                        |             |          |                                                            |userBalance=0xffffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffe05d                      |
|badDebtRulesCash                        |Violated     |4         |Assert message: cash not the same -                         |MockERC20=MockERC20 (0x3098)                      |
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
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Violated     |4         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |2         |Assert message: share price should not change repaying b... |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/c04740cb4f334060a113dad7134a3c44?anonymousKey=cd5da0b7e343f611bc5f5a04fee294e19dd5d828
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
|badDebtRulesCash                        |Violated     |3         |Assert message: cash not the same -                         |MockERC20=MockERC20 (1)                           |
|                                        |             |          |certora/specs/SharePrice.spec line 144                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(2)                                               |
|                                        |             |          |                                                            |amount=1                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2711                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=0                                   |
|                                        |             |          |                                                            |startingBadDebt=1                                 |
|                                        |             |          |                                                            |startingCash=0                                    |
|repayBadDebtDecreasesBadDebt            |Violated     |4         |Assert message: underlying balance of user did not decre... |MockERC20=MockERC20 (0x2ac0)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 90                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2be6)                                          |
|                                        |             |          |                                                            |badDebt=0x2298                                    |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2be5                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |mTokenBalance=0                                   |
|                                        |             |          |                                                            |repayAmount=1                                     |
|                                        |             |          |                                                            |userBalance=0                                     |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |3         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on badDebtRulesCash:
Assert message: cash not the same - certora/specs/SharePrice.spec line 144
Failed on repayBadDebtDecreasesBadDebt:
Assert message: underlying balance of user did not decre... - certora/specs/SharePrice.spec line 90
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithCash(uint256)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/714e2d20fe824826be107f0f6739b4c0?anonymousKey=7659c7a6aae83ab28dbf4b98591fa316df4e4b8f
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
|repayBadDebtDecreasesBadDebt            |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|badDebtRulesCash                        |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Sanity check |3         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|badDebtSymmetry                         |Sanity check |4         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Sanity check |4         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on repayBadDebtDecreasesBadDebt:
Failed on badDebtRulesCash:
Failed on allBadDebtRulesCash:
Failed on badDebtSymmetry:
Failed on badDebtRules:
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/3a03bcfa3d684e3bae790a6fe145e3dd?anonymousKey=2d46956488e8bc9cb94a7281d2e50ef3d2b11c00
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
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |4         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/657f25b2ac9d42ad8fbe9f4ac49f1217?anonymousKey=b0abda6805015396fc0a8c95a69ea21246742075
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
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |6         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/0bc4a13a67044379af8db884ee08f069?anonymousKey=c161dfdad927d16589bb51385e30e5346cacb7ab
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
|repayBadDebtWithReservesSuccess         |Sanity check |1         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Sanity check |0         |                                                            |no local variables                                |
|rePrice                                 |failed       |          |                                                            |                                                  |
|fixUserIncreasesBadDebt                 |Not violated |4         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |4         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |4         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Sanity check |4         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Sanity check |5         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
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

Job is completed! View the results at https://prover.certora.com/output/925723/bd63571153f34a088cb2ca85a5ae2e2b?anonymousKey=90727a941cb382b676990da23e57a2e44534995e
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
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |4         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/041a65baf9894de7b9f9144a63fbba44?anonymousKey=ae45c117ab97fad1e21246829f0dd6532ad537e5
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
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/714e2f5616c54884a92a1a8cb7c9bc2a?anonymousKey=6b810f8f2b7e6b5c40776b0fbe4685ae8adc625f
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
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Sanity check |3         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Sanity check |5         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
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

Job is completed! View the results at https://prover.certora.com/output/925723/2fd3a9a91e5048aea32b8b7fdad57f62?anonymousKey=11382670e09f52362977c86f06bf1607c6dd8d0a
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
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |5         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |3         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/b07da03205d741ed879d0b00d5f9befe?anonymousKey=a05ae140e377f1134f373d6509531dc414fa48f9
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
|repayBadDebtWithReservesSuccess         |Violated     |5         |Assert message: bad debt not fully paid off -               |MockERC20=MockERC20 (1)                           |
|                                        |             |          |certora/specs/SharePrice.spec line 184                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
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
|                                        |             |          |                                                            |endingBadDebt=1                                   |
|                                        |             |          |                                                            |endingReserves=initialized to unknown             |
|                                        |             |          |                                                            |startingBadDebt=1                                 |
|                                        |             |          |                                                            |startingReserves=2                                |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |3         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (1)                           |
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
|fixingUserZeroUserBalance               |Not violated |5         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |5         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |3         |Assert message: reserves bad debt incorrect -               |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 229                      |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |3         |Assert message: share price should not change repaying b... |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/835e9ec7a611475c90288e31a479b8fc?anonymousKey=5bc6eed2ec1993e9dd08c4262d3be0bf971631bc
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
|repayBadDebtWithReservesSuccess         |Violated     |5         |Assert message: bad debt not paid off by reserve amount -   |MockERC20=MockERC20 (1)                           |
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
|fixingUserZeroUserBalance               |Not violated |4         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |4         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |2         |Assert message: reserves bad debt incorrect -               |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 229                      |                                                  |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/2d94893b4e2745c5aeb7351f8276b199?anonymousKey=7a96a348969bc07c78bc603f43c45acf803053f4
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
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |3         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (2)                           |
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
|repayBadDebtDecreasesBadDebt            |Not violated |1         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |2         |Assert message: reserves bad debt incorrect -               |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 229                      |                                                  |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/04512ee586bb44bfa979820ced1bde6f?anonymousKey=22b11b687c77b69b08952949e0f7495d2ddb3d5d
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
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |4         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (0x2713)                      |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2712)                                          |
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
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |4         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |5         |Assert message: share price should not change repaying b... |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/887a945ff5924bbd92b2cefc0debdd8c?anonymousKey=4cce952a8303517a2f0a1ede5a9947ee296e0aa8
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
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |7         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (0x2713)                      |
|rePrice                                 |             |          |certora/specs/SharePrice.spec line 202                      |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2712)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2711                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingSharePrice=1                                |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|repayBadDebtWithReservesSuccess         |Not violated |7         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |6         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |6         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |4         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |4         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |4         |Assert message: reserves bad debt incorrect -               |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 229                      |                                                  |
|allBadDebtRulesCash                     |Not violated |4         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |4         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |7         |Assert message: share price should not change repaying b... |no local variables                                |
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
Done 3m
Done 3m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/5f63514d03da41b3ad151de0d4fee6a1?anonymousKey=ded8f9dd03bfd41e253566848e3306330d18bf85
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
|                                        |             |          |                                                            |endingSharePrice=2                                |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |2         |Assert message: reserves bad debt incorrect -               |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 229                      |                                                  |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
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
Done 2m
Done 2m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/4938e2c64d7d4ff7a79b2f0cf5dcb11c?anonymousKey=9b7b313aea5c720f3c92902a47ca2a68f6532084
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
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/d322c5c94101424a9e76266d7b9cc68d?anonymousKey=adaf9fbf3a381496f0308ffd74f594a9e9b7b013
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
|fixUserIncreasesBadDebt                 |Not violated |2         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/a01b0bcccfcc44949f15e4c3a6b2d559?anonymousKey=f24694db232895e3ced2c4637baf832872d809f7
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
|fixUserIncreasesBadDebt                 |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Sanity check |3         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/d5c5c6f08b2c48c8a7b9bcade74b4c01?anonymousKey=cfc7b588314675d2d72b7fb2596796bf22799ee0
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
|                                        |             |          |                                                            |e.msg.sender=0x2711                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x2711                                 |
|                                        |             |          |                                                            |startingLiquidatorBalance=1                       |
|                                        |             |          |                                                            |startingUserBalance=1                             |
|                                        |             |          |                                                            |user=0x2711                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/575fb3c3d87f40aa9a9528b7d95fa529?anonymousKey=ddc392a2f68f579e4af17813118d278999217d70
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
|fixingUserZeroUserBalance               |Violated     |3         |Assert message: liquidator balance incorrect -              |MockERC20=MockERC20 (2)                           |
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
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/b1874769c511485d8c8d04347061e4cf?anonymousKey=715bed3896f299ac6904ad95ef79a9dddb21bd9a
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
|fixUserIncreasesBadDebt                 |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|fixingUserZeroUserBalance               |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Sanity check |3         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Sanity check |4         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixUserIncreasesBadDebt:
Failed on fixingUserZeroUserBalance:
Failed on fixingUserDoesNotChangeSharePrice:
Failed on badDebtSymmetry:
Failed on badDebtRules:
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/ea4b95b380f041f1a9950294006843a8?anonymousKey=8c6311ada998ad711e4ebf0c89f8913d46f8ac82
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
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |3         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/6631a34708484d3087802a7439a685f5?anonymousKey=d5211f3d07d182071ba81de4c926bf10f37591bc
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
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |5         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/36a6c6903f8743b5bf7cfbfdd9c40e77?anonymousKey=36d8c4062074917922acaa249c1610939c2e5dc9
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
|fixUserIncreasesBadDebt                 |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Sanity check |0         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|badDebtSymmetry                         |Sanity check |3         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |4         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/a8b10a9baa6d4124b4edb880421db49d?anonymousKey=738be915fe2b48026bca19285e2ab75d59e6dd99
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
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |4         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Violated     |1         |Assert message: bad debt not increased from fixing a use... |MockERC20=MockERC20 (2)                           |
|                                        |             |          |- certora/specs/SharePrice.spec line 53                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(1)                                               |
|                                        |             |          |                                                            |badDebt=0xffffffffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffff (MAX_UINT256)            |
|                                        |             |          |                                                            |badDebtAfter=0xfffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |fffffffffffffffffffffffffffff (MAX_UINT256)       |
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
|                                        |             |          |                                                            |interestIndex=0xffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffff (MAX_UINT256)      |
|                                        |             |          |                                                            |liquidator=0x52b                                  |
|                                        |             |          |                                                            |principle=0xffffffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffff (MAX_UINT256)          |
|                                        |             |          |                                                            |user=0x1f8f                                       |
|badDebtRules                            |Not violated |5         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixUserIncreasesBadDebt:
Assert message: bad debt not increased from fixing a use... - certora/specs/SharePrice.spec line 53
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/f6b62bc9910940f5b5d047397b567bbf?anonymousKey=d182c69630971393d5b7a9e7e9f097d0ef8a12c3
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
|fixUserIncreasesBadDebt                 |Violated     |3         |Assert message: bad debt not increased from fixing a use... |MockERC20=MockERC20 (0x6069)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 53                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x606a)                                          |
|                                        |             |          |                                                            |badDebt=0                                         |
|                                        |             |          |                                                            |badDebtAfter=0                                    |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x606b                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |interestIndex=0                                   |
|                                        |             |          |                                                            |liquidator=0x2e15                                 |
|                                        |             |          |                                                            |principle=0                                       |
|                                        |             |          |                                                            |user=0x2e16                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/5a8a6f9e7f7047bf8c76d91ff2fccfff?anonymousKey=8cdd5a3095e264b52206a6eae87b962dd937b992
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
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Sanity check |3         |                                                            |no local variables                                |
|                                        |failed       |          |                                                            |                                                  |
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

Job is completed! View the results at https://prover.certora.com/output/925723/ab7adb5c3a984268adde4aad734a626a?anonymousKey=6e6ac5937f570d7ed544ddb7bfdd1ce3c930a14d
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
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |5         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/8d2014a1012742cab0e7bb73543100c7?anonymousKey=3835253dc9c7a09d5b056aae054ceec92d0fce60
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
|fixingUserZeroUserBalance               |Not violated |4         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |4         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |5         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/0a87669b80a444c68afa31d337836a2d?anonymousKey=b9a392b359530a70860519b49dec06ea4afeae49
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
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |4         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |4         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |5         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/2e9025df9ad34f289ecc3a9174ee92c4?anonymousKey=2dbf4a3112360533d199099e887dc982aaaa7bd8
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
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |5         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/2b5823a9284e48b18d9321f0f80d1d17?anonymousKey=9426a98eb0b9fb11a632a844a947a585bc4bc499
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
|repayBadDebtWithReservesSuccess         |Not violated |5         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |5         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |5         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |4         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |4         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |4         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |6         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 2m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/f88bc10ff4e3462bb9396f3f9cd976df?anonymousKey=05034afaf31c32bcd35a5a50079b033419b6883e
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
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |4         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/59da487d04c042aa9d7db76203a423ca?anonymousKey=b21ee8a89da6e4f65b5562ddd7669e8e41b6d864
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
|fixingUserZeroUserBalance               |Violated     |3         |Assert message: user balance should be zero after fix -     |MockERC20=MockERC20 (1)                           |
|                                        |             |          |certora/specs/SharePrice.spec line 65                       |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
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
|                                        |             |          |                                                            |startingLiquidatorBalance=0                       |
|                                        |             |          |                                                            |startingUserBalance=1                             |
|                                        |             |          |                                                            |user=0x2712                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/af143354cc7547c3ab018b7ec586a0eb?anonymousKey=257343e8176a6ad6fe74d0f601e8cfa86e89a66f
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
|fixingUserZeroUserBalance               |Violated     |5         |Assert message: user balance should be zero after fix -     |MockERC20=MockERC20 (1)                           |
|                                        |             |          |certora/specs/SharePrice.spec line 65                       |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
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
|                                        |             |          |                                                            |startingLiquidatorBalance=0                       |
|                                        |             |          |                                                            |startingUserBalance=1                             |
|                                        |             |          |                                                            |user=0x2714                                       |
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |4         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Not violated |6         |                                                            |no local variables                                |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on fixingUserZeroUserBalance:
Assert message: user balance should be zero after fix - certora/specs/SharePrice.spec line 65
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/1bb1267445dc4e57979760b7fd14c0b0?anonymousKey=2bb6a7dd43978c9e3b2216909e2495d22053d3f0
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
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Violated     |4         |Assert message: user balance should be zero after fix -     |MockERC20=MockERC20                               |
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
|                                        |             |          |                                                            |startingLiquidatorBalance=0x8000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000000000000000000000        |
|                                        |             |          |                                                            |startingUserBalance=1                             |
|                                        |             |          |                                                            |user=0x5fffffffffffffffffffffffffffffffffffffff   |
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |4         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/8b0b4d600f7f4172aa57a890890c699c?anonymousKey=7266a2589dbb999609de6b8e85f0e5034c86b9c8
Finished verification request
ERROR: Prover found violations:
[rule] fixingUserZeroUserBalance: FAIL
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
Results for all:
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
|Rule name                               |Verified     |Time (sec)|Description                                                 |Local vars                                        |
|----------------------------------------|-------------|----------|------------------------------------------------------------|--------------------------------------------------|
|envfreeFuncsStaticCheck                 |Not violated |0         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Violated     |3         |Assert message: user balance should be zero after fix -     |MockERC20=MockERC20 (9)                           |
|                                        |             |          |certora/specs/SharePrice.spec line 65                       |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(10)                                              |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0                                    |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x2712                                 |
|                                        |             |          |                                                            |startingLiquidatorBalance=1                       |
|                                        |             |          |                                                            |startingUserBalance=2                             |
|                                        |             |          |                                                            |user=0x2711                                       |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |3         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/9846fe65e7b64b3d9a61ed31cb668006?anonymousKey=02fe201d6a5e21cb2c22081c1ed53c39b491f2fb
Finished verification request
ERROR: Prover found violations:
[rule] fixingUserZeroUserBalance: FAIL
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
|fixingUserZeroUserBalance               |Violated     |4         |Assert message: user balance should be zero after fix -     |MockERC20=MockERC20 (0x2711)                      |
|                                        |             |          |certora/specs/SharePrice.spec line 65                       |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2712)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2715                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x2ffc                                 |
|                                        |             |          |                                                            |startingLiquidatorBalance=0                       |
|                                        |             |          |                                                            |startingUserBalance=1                             |
|                                        |             |          |                                                            |user=0x2ffb                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Not violated |2         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/919b1dc8a4b647fdae39565f95f88d93?anonymousKey=784315d97a9716a2eb6baae0f9b12c06cc90ec57
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
|                                        |             |          |                                                            |liquidator=0x2fb4                                 |
|                                        |             |          |                                                            |startingSharePrice=2                              |
|                                        |             |          |                                                            |user=0x2fb5                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Violated     |3         |Assert message: borrows bad debt incorrect -                |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 225                      |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/46ee04f0fa074f00abe86f591dc28c08?anonymousKey=7421660d124cc4981f8508721de5ccb12e2a7b70
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
|fixUserIncreasesBadDebt                 |Violated     |4         |Assert message: bad debt not increased from fixing a use... |MockERC20=MockERC20                               |
|                                        |             |          |- certora/specs/SharePrice.spec line 53                     |(0xbfffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |badDebt=initialized to unknown                    |
|                                        |             |          |                                                            |badDebtAfter=initialized to unknown               |
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
|                                        |             |          |                                                            |liquidator=MockMErc20DelegateFixer                |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |principle=0x7fffffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffff                        |
|                                        |             |          |                                                            |user=0x3fffffffffffffffffffffffffffffffffffffff   |
|fixingUserDoesNotChangeSharePrice       |Violated     |4         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2714)                      |
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
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |4         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |4         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtSymmetry                         |Violated     |4         |Assert message: borrows bad debt incorrect -                |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 225                      |                                                  |
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

Job is completed! View the results at https://prover.certora.com/output/925723/0da00716e47740eb8dee37ef54aee0b0?anonymousKey=5fbfa562a7871e48247c696fd9cd8ace8e0de54a
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
|fixUserIncreasesBadDebt                 |Violated     |3         |Assert message: bad debt not increased from fixing a use... |MockERC20=MockERC20                               |
|                                        |             |          |- certora/specs/SharePrice.spec line 53                     |(0xbfffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |badDebt=0x8000000000000000000000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000                          |
|                                        |             |          |                                                            |badDebtAfter=initialized to unknown               |
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
|                                        |             |          |                                                            |startingSharePrice=0xfffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffff7e52fe5afe40000               |
|                                        |             |          |                                                            |user=MockERC20 (0x2711)                           |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |3         |Assert message: borrows bad debt incorrect -                |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 225                      |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |2         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |2         |Assert message: bad debt should only increase when fixin... |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/849a533246554872b0cf14d3108bf52e?anonymousKey=99c8145f437f8238afd72119807ca81db979ce21
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
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserDoesNotChangeSharePrice       |Violated     |6         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2712)                      |
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
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |2         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRules                            |Violated     |4         |Assert message: share price should not change repaying b... |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/b472853d97984affbc3779cc8c94cd16?anonymousKey=80e2c1b5edcf6650be1a1db1f8c4f4604a767f0f
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
|fixingUserDoesNotChangeSharePrice       |Violated     |6         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2714)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2713)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2716                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x3149                                 |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|                                        |             |          |                                                            |user=0x314a                                       |
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |4         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |3         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |5         |Assert message: borrows bad debt incorrect -                |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 225                      |                                                  |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |4         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
|badDebtRulesCash                        |Not violated |4         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |6         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |1         |                                                            |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/781fd4e6a8db4582947954db3b452ff6?anonymousKey=fdd24d0250ece9819f4bebfc40c7fa59fc474935
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
|fixingUserDoesNotChangeSharePrice       |Violated     |5         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2711)                      |
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
|                                        |             |          |                                                            |liquidator=0x2712                                 |
|                                        |             |          |                                                            |startingSharePrice=0xde0b6b3a7640000              |
|                                        |             |          |                                                            |user=MockERC20 (0x2711)                           |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Violated     |3         |Assert message: borrows bad debt incorrect -                |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 225                      |                                                  |
|badDebtRulesCash                        |Not violated |2         |                                                            |no local variables                                |
|allBadDebtRulesCash                     |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtWithReservesDoesNotChangeSha|Not violated |3         |                                                            |no local variables                                |
|rePrice                                 |             |          |                                                            |                                                  |
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

Job is completed! View the results at https://prover.certora.com/output/925723/c834f61a6dc54cd199cbfe8bb48abe43?anonymousKey=9d13bb2666a1b327ed8cb397607fd83b99332176
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
|badDebtRulesCash                        |Violated     |3         |Assert message: bad debt should not increase when repayi... |MockERC20=MockERC20                               |
|                                        |             |          |- certora/specs/SharePrice.spec line 147                    |(0xbfffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x7fffffffffffffffffffffffffffffffffffffff)      |
|                                        |             |          |                                                            |amount=0x80000000000000000000000000000000000000000|
|                                        |             |          |                                                            |00000000000000000000000                           |
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
|                                        |             |          |                                                            |endingBadDebt=0x4000000000000000000000000000000000|
|                                        |             |          |                                                            |000000000000000000000000000000                    |
|                                        |             |          |                                                            |startingBadDebt=0xc0000000000000000000000000000000|
|                                        |             |          |                                                            |00000000000000000000000000000000                  |
|                                        |             |          |                                                            |startingCash=0x3ffffffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffffffffffffffe                     |
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |3         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (2)                           |
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
|                                        |             |          |                                                            |endingSharePrice=0x1bc16d674ec80000               |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|allBadDebtRulesCash                     |Violated     |5         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
|fixingUserDoesNotChangeSharePrice       |Violated     |5         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (0x2714)                      |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(0x2715)                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=MockERC20 (0x2714)                   |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0x2fb4                                 |
|                                        |             |          |                                                            |startingSharePrice=0x1bc16d674ec80000             |
|                                        |             |          |                                                            |user=0x2fb5                                       |
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |4         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |4         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |4         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on badDebtRulesCash:
Assert message: bad debt should not increase when repayi... - certora/specs/SharePrice.spec line 147
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on allBadDebtRulesCash:
Assert message: cash not correct - certora/specs/SharePrice.spec line 171
Violated for: 
repayBadDebtWithReserves(),
repayBadDebtWithCash(uint256)
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

Job is completed! View the results at https://prover.certora.com/output/925723/f66ec66663814fa4bb575648c82ce529?anonymousKey=ebce97ba22f2cc74710ecdb26ecf2358051af50e
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
|badDebtRulesCash                        |Violated     |3         |Assert message: bad debt should not increase when repayi... |MockERC20=MockERC20 (1)                           |
|                                        |             |          |- certora/specs/SharePrice.spec line 147                    |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(2)                                               |
|                                        |             |          |                                                            |amount=3                                          |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2711                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |endingBadDebt=2                                   |
|                                        |             |          |                                                            |startingBadDebt=5                                 |
|                                        |             |          |                                                            |startingCash=0                                    |
|allBadDebtRulesCash                     |Violated     |4         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
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
repayBadDebtWithReserves(),
fixUser(address,address),
repayBadDebtWithCash(uint256)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/f948b418da544257906512dd99ea1f11?anonymousKey=6adc2b13effce461d4633b14928c94a981a64931
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
|repayBadDebtWithReservesDoesNotChangeSha|Violated     |3         |Assert message: share price should remain unchanged -       |MockERC20=MockERC20 (2)                           |
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
|                                        |             |          |                                                            |endingSharePrice=0xf5e5a53f3df3e00000             |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|allBadDebtRulesCash                     |Violated     |3         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
|badDebtRulesCash                        |Violated     |2         |Assert message: bad debt should not increase when repayi... |MockERC20=MockERC20 (1)                           |
|                                        |             |          |- certora/specs/SharePrice.spec line 147                    |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(2)                                               |
|                                        |             |          |                                                            |amount=0                                          |
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
|                                        |             |          |                                                            |endingBadDebt=1                                   |
|                                        |             |          |                                                            |startingBadDebt=1                                 |
|                                        |             |          |                                                            |startingCash=0                                    |
|fixingUserDoesNotChangeSharePrice       |Violated     |4         |Assert message: share price should not change fixing use... |MockERC20=MockERC20 (2)                           |
|                                        |             |          |- certora/specs/SharePrice.spec line 78                     |MockMErc20DelegateFixer=MockMErc20DelegateFixer   |
|                                        |             |          |                                                            |(1)                                               |
|                                        |             |          |                                                            |e.block.basefee=0                                 |
|                                        |             |          |                                                            |e.block.coinbase=0                                |
|                                        |             |          |                                                            |e.block.difficulty=0                              |
|                                        |             |          |                                                            |e.block.gaslimit=0                                |
|                                        |             |          |                                                            |e.block.number=0                                  |
|                                        |             |          |                                                            |e.block.timestamp=0                               |
|                                        |             |          |                                                            |e.msg.sender=0x2715                               |
|                                        |             |          |                                                            |e.msg.value=0                                     |
|                                        |             |          |                                                            |e.tx.origin=0                                     |
|                                        |             |          |                                                            |liquidator=0                                      |
|                                        |             |          |                                                            |startingSharePrice=1                              |
|                                        |             |          |                                                            |user=0x2710                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
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
repayBadDebtWithReserves(),
fixUser(address,address),
repayBadDebtWithCash(uint256)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/f9709ecc65ba4f05bf4a0e7ecbd897af?anonymousKey=5e975a102793f2ebffc4728855e93d9d7d01ce81
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
|badDebtRulesCash                        |Violated     |2         |Assert message: bad debt should not increase when repayi... |MockERC20=MockERC20 (1)                           |
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
|                                        |             |          |                                                            |endingSharePrice=0xfffffffffffffffffffffffffffffff|
|                                        |             |          |                                                            |ffffffffffffffffff7e52fe5afe40000                 |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|allBadDebtRulesCash                     |Violated     |4         |Assert message: cash not correct -                          |no local variables                                |
|                                        |             |          |certora/specs/SharePrice.spec line 171                      |                                                  |
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
|                                        |             |          |                                                            |liquidator=0x352a                                 |
|                                        |             |          |                                                            |startingSharePrice=0                              |
|                                        |             |          |                                                            |user=0x352b                                       |
|repayBadDebtWithReservesSuccess         |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |2         |Assert message: share price should not change repaying b... |no local variables                                |
|                                        |             |          |- certora/specs/SharePrice.spec line 115                    |                                                  |
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Failures summary:
Failed on badDebtRulesCash:
Assert message: bad debt should not increase when repayi... - certora/specs/SharePrice.spec line 147
Failed on repayBadDebtWithReservesDoesNotChangeSharePrice:
Assert message: share price should remain unchanged - certora/specs/SharePrice.spec line 202
Failed on allBadDebtRulesCash:
Assert message: cash not correct - certora/specs/SharePrice.spec line 171
Violated for: 
repayBadDebtWithReserves(),
repayBadDebtWithCash(uint256)
Failed on fixingUserDoesNotChangeSharePrice:
Assert message: share price should not change fixing use... - certora/specs/SharePrice.spec line 78
Failed on badDebtRules:
Assert message: share price should not change repaying b... - certora/specs/SharePrice.spec line 115
Violated for: 
repayBadDebtWithReserves(),
fixUser(address,address),
repayBadDebtWithCash(uint256)
Done 1m
Done 1m
Event reporter: all events were sent without errors
[INFO]: Process returned with 100
[INFO]: updated '41948e68b910f69c3218ad74de39b67e9de06ffa0d3fbf733cc48950b19227c8-optimisticTrue-iterNone-None--certora-cli-6.3.1' cache

Job is completed! View the results at https://prover.certora.com/output/925723/dd6a1efc46dc4aba951d72ed939fcdbd?anonymousKey=645e7a42423b3a9150a16725000ce9f130abe448
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
|badDebtRulesCash                        |Violated     |3         |Assert message: bad debt should not increase when repayi... |MockERC20=MockERC20 (0x2711)                      |
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
|                                        |             |          |                                                            |endingSharePrice=1                                |
|                                        |             |          |                                                            |startingSharePrice=3                              |
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
|                                        |             |          |                                                            |liquidator=0x45df                                 |
|                                        |             |          |                                                            |startingSharePrice=0x6f05b59d3b20000              |
|                                        |             |          |                                                            |user=0x45e0                                       |
|repayBadDebtWithReservesSuccess         |Not violated |4         |                                                            |no local variables                                |
|fixingUserZeroUserBalance               |Not violated |3         |                                                            |no local variables                                |
|fixUserIncreasesBadDebt                 |Not violated |3         |                                                            |no local variables                                |
|repayBadDebtDecreasesBadDebt            |Not violated |2         |                                                            |no local variables                                |
|badDebtSymmetry                         |Not violated |3         |                                                            |no local variables                                |
|badDebtRules                            |Violated     |2         |Assert message: share price should not change repaying b... |no local variables                                |
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

Job is completed! View the results at https://prover.certora.com/output/925723/3c4cdb77986344a885c131de965acca7?anonymousKey=dcce29cd8cb587a3303e79ac3e39f64f15d95fac
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
