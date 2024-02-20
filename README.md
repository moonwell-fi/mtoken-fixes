# mToken Fixes and Collateral Sweeping - Proposal #2

This proposal will remove all Nomad collateral from .mad mTokens, sending the underlying to the community multisig, and zero all borrows from users with bad debt.

In order to allow mToken collateral sweeping and bad debt write offs, the mTokens will have their implementations upgraded.

This will stop further issues and to allow the exchange rates of the assets to stay the same post proposal. Interest Rate Models may need to be changed in order to stop rate spikes due to changes in supply and borrow amounts.

See [this](https://forum.moonwell.fi/t/request-for-proposal-rfp-redemption-and-reallocation-of-nomad-collateral-and-protocol-reserves-for-frax-market-enhancement/746/3) forum post for additional information.
