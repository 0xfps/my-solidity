# my-solidity
My Solidity projects.

## **1. English auction for NFT.**

> - Seller of NFT deploys this contract.
> - Auction lasts for 7 days.
> - Participants can bid by depositing ETH greater than the current highest bidder.
> - All bidders can withdraw their bid if it is not the current highest bid.

<br/>

## After the auction:

> - Highest bidder becomes the new owner of NFT.
> - The seller receives the highest bid of ETH.

[Deployed contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0x8816cd156792F4Fd9A081f14548D7Fa6040DfCf0)

###

<br/>

## **2. Crowd Fund**

**Crowd fund ERC20 token**

> - User creates a campaign with a particular token.
> - Users can pledge, transferring their token to a campaign.
> - After the campaign ends, campaign creator can claim the funds if total amount pledged is more than the campaign goal.
> - Otherwise, campaign did not reach it's goal, users can withdraw their pledge.

[Deployed contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0x579df29C056e4Bb9CD548EdEEB4b80CB4679b1Ec)

###

## **3. Dutch Auction**

# Dutch auction for NFT.

- Auction
> - Seller of NFT deploys this contract setting a starting price for the NFT.
> - Auction lasts for 7 days.
> - Price of NFT decreases over time.
> - Participants can buy by depositing ETH greater than the current price computed by the smart contract.
> - Auction ends when a buyer buys the NFT.

[Deployed contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0x56aA4d97DA83b93372B6366482b929B86580452a)

###

<br/>

## **4. Faucet**

> - A simple Rinkeby Ethereum faucet that transfers 0.2 ether to addresses that request for it.
> - Ether can be transferred to addresses as long as the interval is 12 hours.
> - Faucet funders are recorded and are public.
> - Faucet funders can only transfer 1 ether to the faucet.
> - On any transfers of more than 1 ether, the balance is sent back to the funder, and 1 ether is taken in by the contract.

[Deployed contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0x196ca425A223C5325d63e7245C93a284B6D5EA3c)
