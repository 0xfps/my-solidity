# **my-solidity**

Over my course of learning Solidity, I have embarked on some projects which help me understand and implement the concepts of the Solidity programming language ❤.
I this repository, I have compiled them all, each one has its own branch and after the commits, it is merged with the main.

<br/>

**@notice:**
  These projects are divided into 2 parts, the `major` and the `minor` projects.

<br/>

  M A J O R   P R O J E C T S :
    These ones are the ones that will be deployed on the Rinkeby Etherscan network, and they will have their addresses attached to them.

<br/>

  M I N O R   P R O J E C T S :
    These will not be deployed on the Rinkeby Etherscan but are contracts that I will write everyday to keep my glued and make the smart contract syntax a part of me 😌...
    While I study about and write the major projects...
    Where as major commits will span for some days, giving me time to learn, understand, write, test and deploy the major ones 🤗.

  Each one of these projects are hosted on the Rinkeby Etherscan network 🚀, and I shall do well to link them properly.
  Each one of these uses the low-level call method for ease of tests. (They are not and should not be used for live implementations).
  .transfer() might be added 😉.

---

#**M I N O R   C O N T R A C T S :** 

<br/>


> - 1: **PureMath:**

<br/>

https://github.com/fps8k/my-solidity/tree/main/libraries/PureMath.sol

A math library for basic calculations including percentages.

---

<br/><br/>

#**M A J O R   C O N T R A C T S :**

<br/>


> - **1. Ether Wallet:**

<br/>

https://github.com/fps8k/my-solidity/tree/main/ether_wallet

This is a simple Solidity program that allows anyone to send ether to a wallet then allowning only the owner to withdraw.

Deployment address: https://rinkeby.etherscan.com/addresses/0x63D20e6810927977aE7c16DD8f3b5F7f319EDF7C

##

> - **2. Multi - Sig - Wallet**

<br/>

https://github.com/fps8k/my-solidity/tree/main/multi_sig_wallet

This is also the second simple Solidity program that allows the transfer of value (ether) within tests accounts registered on the contract. An unregistered account cannot transfer or receive any ether. In the end, the transactions are pending until they are being confirmed by >1/2 of the total registered accounts in the contract.

Deployment address: https://rinkeby.etherscan.com/addresses/0x126065c1DF6bb579E7D9590bf07C28D1db519286

##

> - **3. Merkle Tree**

<br/>

https://github.com/fps8k/my-solidity/tree/main/merkle_tree

This program builds a merkle tree from the hashes of transactions done on the contract. Due to extreme high gas fees, the merkle tree is compiled from only the first 2 transactions.
The Description.md file in the repository (https://github.com/fps8k/my-solidity/blob/main/merkle_tree/Description.md) does more justice to the definition of the merkle tree and the algorithm behind it.

Deployment address: https://rinkeby.etherscan.com/addresses/0x7fF08E0dd90bBf3B22008fB1b28Bb4B037a8B79D

##

> - **4. Iterable Mapping**

<br/>
https://github.com/fps8k/my-solidity/tree/main/iterable_mapping

A project that simply takes the hashes of any complete transaction and adds it to an array, then maps the hash to the address that made the transaction. Hence, you can get the address of a particular hash by simply spotting their index on the array, then with the hash value at that index, grab the address.

Deployment address: https://rinkeby.etherscan.com/addresses/0x1A09e937AB84b5434a70aDaBC69b9884B85ED123d0d0EC2

##

> - **5. ERC-20 Token (Aguia -> $AGU):**

<br/>

https://github.com/fps8k/my-solidity/tree/main/erc20%20-%20%24AGU

This is my first ERC-20 standard token, named Aguia (Portuguese for "Eagle") with symbol $AGU. It has 1,000,000 tokens in supply with the ability to mint (add) or burn (reduce the number of) more tokens. It was hosted on the rinkeby etherscan network with token contract address : 0x2DFA0332E058c4FcC9d1b8C165eFf1CF52368d03

Deployment address: https://rinkeby.etherscan.io/address/0x2DFA0332E058c4FcC9d1b8C165eFf1CF52368d03

##


