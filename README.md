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

<br/>

###

## **3. Dutch Auction**

**Dutch auction for NFT**

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

###

<br/>

## **5. Delegatecall**

> - An upgradable smart contract project implementing the delegatecall functionality.
> - It includes the 3 necessary contracts an upgradable contract should have.
[x] [Proxy.sol](https://github.com/fps8k/my-solidity/blob/main/Delegatecall/Delegatecall%20Source/Proxy.sol): The contract to interact with the upgradable contract.
[x] [Store.sol](https://github.com/fps8k/my-solidity/blob/main/Delegatecall/Delegatecall%20Source/Utils/Store.sol): The contract holding the storage variables.
[x] [Main.sol](https://github.com/fps8k/my-solidity/blob/main/Delegatecall/Delegatecall%20Source/Utils/Main.sol): The actual contract that handles the logic.
[ ] [Admin.sol](https://github.com/fps8k/my-solidity/blob/main/Delegatecall/Delegatecall%20Source/Utils/Admin.sol): Contract with admin roles. This is optional.

[Proxy contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0xDC4Ddd0324C86C7167ECc906b9FbF4a1055F40fa)

###

<br/>

## **6. ERC-20 ($FPS)**

> - ERC-20 Token.

[Deployed contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0x9af84a56B0b2444Fa2367C13862B652567CD0A1b)

###

<br/>

## **7. New Faucet**

> - Modified [Faucet](https://github.com/fps8k/my-solidity/tree/main/Faucet) contract.

###

<br/>

## **8. USDT**

> - $USDT, a copy of the ERC-20 token on Rinkeby USDT for token testings on development network.

[Deployed contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0x788b76Ee23FAa205F3d4991C9977618Cc7c6a019f3b5F7f319EDF7C)<br/>
[Deployed contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0x770861CdcdDF8319C6C86ef8EF91C4A922fc12aC)

###

<br/>

## **9. Address Book**

> - A basic contract that works like a phone book. Allowing users to map names to addresses, and retrieving it when needed.

[Deployed contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0x93a9b149A40490d03aA37de469105A8049932e30)

###

<br/>

## **10. $AGU**

> - ERC-20 Token.

[Deployed contract on Rinkeby Etherscan (1).](https://rinkeby.etherscan.io/address/0x183A9aA20E1596669BD81EacCDCe17E6705449f5)
[Deployed contract on Rinkeby Etherscan (2).](https://rinkeby.etherscan.io/address/0x2DFA0332E058c4FcC9d1b8C165eFf1CF52368d03)

###

<br/>

## **11. $AGU 2**

> - A modified [$AGU](https://github.com/fps8k/my-solidity/tree/main/erc20%20-%20%24AGU)

###

<br/>

## **12. ERC-721**

> - Legio, an ERC-721 NFT project.

[Deployed contract on Rinkeby Etherscan (1).](https://rinkeby.etherscan.io/address/0x251568c2ba92a7CD30CF1f5a6c27dD42b167011A)<br/>
[Deployed contract on Rinkeby Etherscan (2).](https://rinkeby.etherscan.io/address/0xbc71d1049d984f261663c3b46c1F443C622852EF)<br/>
[Deployed contract on Rinkeby Etherscan (3).](https://rinkeby.etherscan.io/address/0xD17E6E1daB2d1E778278f5358ca68D572b713cdF)

###

<br/>

## **13. Ether Wallet**

> - EtherWallet, a crowdfunding smart contract.
> - This is a simple Solidity program that allows anyone to send ether to a wallet then allowing only the owner to withdraw.
> - This was my FIRST Solidity Smart Contract task, and I am so proud of it ❤🕊.

[Deployed contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0x72a8422a0E0098eF770A0dfdA312Ec1bd44fdB44)

###

<br/>

## **14. Iterable Mapping**

> - A contract that communicates between a mapping and an array stored on the contract.

[Deployed contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0x1A09e937AB84b5434a70aDaBC69b9884B85ED123d0d0EC2)

###

<br/>

## **15. Libraries**

> - A bunch of libraries I wrote for math, experimenting.

###

<br/>

## **16. Liquidity**

> - Uniswap's liquidity contracts I studied.

###

<br/>

## **17. Merkle Tree**

> - A contract that calculates the merkle tree from an array of transactions made with the contract.
> - _Hint: I bugged this contract 😉._

[Deployed contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0x7fF08E0dd90bBf3B22008fB1b28Bb4B037a8B79D)

###

<br/>

## **18. Multi-Sig Wallet**

> - A contract that approves pending transactions made on the contract on the condition that ((1/2) + 1) of the users of the contract has approved it.

[Deployed contract on Rinkeby Etherscan.](https://rinkeby.etherscan.io/address/0x14C6Bb868EB71cAaDf19601699C760926511578F)

###

<br/>

## **19. Token Task**

###

<br/>

## **20. StoreEmitAndRetrieve.sol**

###

<br/>

## **21. Create2Factory**

Practical contract applying the create 2 functionality to pre-calculate the deploy address of a particular contract with its constructor parameters and salt.
