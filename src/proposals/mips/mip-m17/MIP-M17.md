# MIP-M22: Strategic Reallocation of Collateral for FRAX Market Stability

Following the consensus reached in the recent [snapshot vote](https://snapshot.org/#/moonwell-governance.eth/proposal/0xe30b2ec324ad04397eb864dd464d3f57f44c63ccf684c9a126f9dd34908fd5c7) for FRAX market liquidity enhancement, as well as the passage of [MIP-16](https://moonwell.fi/governance/proposal/moonbeam?id=70), we're now ready to move forward with the second and final onchain vote. This plan outlines the next steps for bolstering our FRAX market's resilience and stability by leveraging dormant .mad collateral.

## Proposal Details

This proposal aims to:

- Transfer all .mad mToken collateral into our community-controlled [multisig wallet](https://multisig.moonbeam.network/settings/setup?safe=mbeam%3A0x949D6a0E3b1064d498D529a388B953b344CD13F7).
- Clear bad debt from the ledger by reallocating assets and adjusting contract mechanisms.

To achieve this, two types of mToken upgrades will occur with implementations being swapped out, enabling the smooth transition of assets and ensuring that the exchange rates remain unaffected post-upgrade. Adjustments to the Interest Rate Models may also be necessary to prevent sudden spikes in rates following these changes.

## Implementation Steps

- mToken Upgrades: Upgrade mToken implementations to allow for the below changes while preserving key protocol invariants and exchange rates.
- Bad Debt Resolution: Introduction of an [MErc20DelegateFixer](https://moonbeam.moonscan.io/address/0x47dffebef33719315bd5a91db6bfb81691347914#code) contract for [mFRAX](https://moonscan.io/address/0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C) and [mxcDOT](https://moonscan.io/address/0xd22da948c0ab3a27f5570b604f3adef5f68211c3), facilitating the repayment and write-off of bad debts, halting further interest accumulation.
- Nomad Collateral Reallocation: Introduction of an [MErc20DelegateMadFixer](https://moonbeam.moonscan.io/address/0xf19b9e20c24c8304b89373dec84b7c017e98b4fc#code) contract for .mad mTokens, enabling the seamless transfer of Nomad collateral to the community wallet, safeguarding the system’s balance and functionality.

### Community Multisig Wallets
To ensure the safety and security of assets, as described in the [original RFP](https://forum.moonwell.fi/t/request-for-proposal-rfp-redemption-and-reallocation-of-nomad-collateral-and-protocol-reserves-for-frax-market-enhancement/746/3), we've created Gnosis Safe multisig wallets on both Ethereum and Moonbeam networks at these addresses with a proposal threshold of 2 out of 3 signers required to execute transactions:

Ethereum: https://app.safe.global/home?safe=eth:0x949D6a0E3b1064d498D529a388B953b344CD13F7

Moonbeam: https://multisig.moonbeam.network/settings/setup?safe=mbeam%3A0x949D6a0E3b1064d498D529a388B953b344CD13F7

The signers of these wallets are trusted Moonwell community members and contributors, including [Curly](https://forum.moonwell.fi/u/curly/summary) and [Elliot](https://forum.moonwell.fi/u/elliot/summary) from Solidity Labs, alongside the Moonwell pause guardian multisig, which ensures a third and final signature should one of the other signers become inaccessible.

### Security Measures
Extensive security steps were taken to ensure mToken share prices stayed the same and these changes did not have unintended downstream effects or other unforeseen effects on the system. Employed security measures include:


- [Integration Testing](https://github.com/moonwell-fi/mtoken-fixes/blob/main/test/integration/proposals/mips/mip-m17/mip-m17.t.sol)
- [Mutation Testing](https://github.com/moonwell-fi/mtoken-fixes/blob/main/MutationTestOutput/Result.md)
- [Formal Verification](https://github.com/moonwell-fi/mtoken-fixes/blob/main/certora/specs/SharePrice.spec)
- Static Analysis
- Manual code reviews, walking through the code line by line with Solidity Labs engineers
- Review of changes by one of the founding engineers from Compound Labs
- [Audit by Halborn](https://github.com/moonwell-fi/moonwell-contracts-v2/blob/main/audits/Moonwell_MToken_Fixes_Audit.pdf), no medium or high issues were discovered in this review.
- [Code competition by Codehawks](https://www.codehawks.com/submissions/clt7ewpli0001w7f6ol2yojki?page=1&filterValidated=%7B%22value%22%3A%22all%22%2C%22label%22%3A%22All%22%7D&filterDone=%7B%22value%22%3A%22all%22%2C%22label%22%3A%22-%22%7D&filterSelectedForReport=%7B%22value%22%3A%22all%22%2C%22label%22%3A%22-%22%7D&filterSeverity=%5B%7B%22value%22%3A%22high%22%2C%22label%22%3A%22High%22%2C%22disabled%22%3Afalse%7D%2C%7B%22value%22%3A%22medium%22%2C%22label%22%3A%22Medium%22%2C%22disabled%22%3Afalse%7D%2C%7B%22value%22%3A%22low%22%2C%22label%22%3A%22Low%22%2C%22disabled%22%3Afalse%7D%2C%7B%22value%22%3A%22unknown%22%2C%22label%22%3A%22Unknown%22%2C%22disabled%22%3Afalse%7D%5D&filterTags=%255B%255D&filterCommunityJudgingDecision=%5B0%2C100%5D&filterCommunityJudgingMinVotes=0), this turned up [one medium issue](https://www.codehawks.com/submissions/clt7ewpli0001w7f6ol2yojki/100) our team had not foreseen around rewards not being paid to users with bad debt, however we accepted this issue and will not fix.
A workaround for this reward issue will be implemented: prior to execution of this successful proposal, claimRewards will be called on behalf of all Nomad bad debt accounts, and any rewards they were entitled to will be sent to their wallet.

### Fund Transfer and Management
This proposal will send the underlying .mad assets to the community multisig, however due to lack of support for smart contract wallets for Coinlist’s redemption process, it will not be possible to use the Nomad Bridge with the Gnosis Safe wallet on Moonbeam. 

To address this, Elliot Friedman of Solidity Labs has nominated himself to perform the following steps: 


- Transfer funds from the Moonbeam multisig to a corporate wallet
- Redeem the .mad assets for the corresponding underlying assets on Ethereum mainnet
- Transfer underlying assets to the community multisig on mainnet
- Use the multisig to swap the underlying assets for FRAX using an aggregator like Defi Llama to determine the best execution price and enforce minimum required slippage parameters.
- Bridge funds back to Moonbeam through the FRAX Ferry
- Call repayBadDebt with cash on the Frax market, transferring the proceeds of the redemption to the Frax market, bolstering liquidity, and reducing the bad debt

Note that Elliot is a fully doxxed US person and will be using a hardware wallet from a highly secure computer. The funds will only reside in this EOA for the process of unbridging from Moonbeam to Ethereum.

## Conclusion

By approving this proposal, the Moonwell community will take a significant step towards resolving the issues caused by the Nomad bridge exploit, restoring stability and liquidity to the FRAX market, and strengthening the protocol's resilience. The combination of mToken upgrades, .mad collateral reallocation, and bad debt write-offs will help ensure the long term health and sustainability of Moonwell’s deployment on Moonbeam network.

I encourage all WELL tokenholders to thoroughly review this proposal and participate in the onchain vote. Together, we can overcome this challenge and emerge stronger as a community and protocol.

*Please note: Due to the current limitations of the Moonwell Governor contract, which allows a proposal author to have only one Moonwell Improvement Proposal in flight at a time, I have requested that Moonwell delegate Coolhorsegirl submit MIP-M22 on my behalf.*
