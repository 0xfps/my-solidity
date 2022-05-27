# my-solidity
My Solidity projects.

- ## 1. English auction for NFT.

- Seller of NFT deploys this contract.
- Auction lasts for 7 days.
- Participants can bid by depositing ETH greater than the current highest bidder.
- All bidders can withdraw their bid if it is not the current highest bid.

<br/>

## After the auction:

- Highest bidder becomes the new owner of NFT.
- The seller receives the highest bid of ETH.

###

<br/>

- ## 2. Crowd Fund

**Crowd fund ERC20 token**

- User creates a campaign with a particular token.
- Users can pledge, transferring their token to a campaign.
- After the campaign ends, campaign creator can claim the funds if total amount pledged is more than the campaign goal.
- Otherwise, campaign did not reach it's goal, users can withdraw their pledge.

###

## **3. Dutch Auction**

# Dutch auction for NFT.

- Auction
> - Seller of NFT deploys this contract setting a starting price for the NFT.
> - Auction lasts for 7 days.
> - Price of NFT decreases over time.
> - Participants can buy by depositing ETH greater than the current price computed by the smart contract.
> - Auction ends when a buyer buys the NFT.
