# my-solidity

Over my course of learning Solidity, I have embarked on some projects which help me understand and implement the concepts of the Solidity programming language.
I this repository, I have compiled them all, each one has its own branch and after the commits, it is merged with the main.

@notice:
  Each one of these projects are hosted on the Rinkeby Etherscan network, and I shall do well to link them properly.
  Each one of these uses the low-level call method for ease of tests. (They are not and should not be used for live implementations).


They are:


> - 1. Ether Wallet:

https://github.com/fps8k/my-solidity/tree/main/ether_wallet

This is a simple Solidity program that allows anyone to send ether to a wallet then allowning only the owner to withdraw.

Deployment address: https://rinkeby.etherscan.com/addresses/0x63D20e6810927977aE7c16DD8f3b5F7f319EDF7C



> - 2. Multi - Sig - Wallet

https://github.com/fps8k/my-solidity/tree/main/multi_sig_wallet

This is also the second simple Solidity program that allows the transfer of value (ether) within tests accounts registered on the contract. An unregistered account cannot transfer or receive any ether. In the end, the transactions are pending until they are being confirmed by >1/2 of the total registered accounts in the contract.

Deployment address: https://rinkeby.etherscan.com/addresses/0x126065c1DF6bb579E7D9590bf07C28D1db519286



> - 3. Merkle Tree

https://github.com/fps8k/my-solidity/tree/main/merkle_tree

This program builds a merkle tree from the hashes of transactions done on the contract. Due to extreme high gas fees, the merkle tree is compiled from only the first 2 transactions.
The Description.md file in the repository (https://github.com/fps8k/my-solidity/blob/main/merkle_tree/Description.md) does more justice to the definition of the merkle tree and the algorithm behind it.

Deployment address: https://rinkeby.etherscan.com/addresses/0x7fF08E0dd90bBf3B22008fB1b28Bb4B037a8B79D



> - 4. Iterable Mapping

https://github.com/fps8k/my-solidity/tree/main/iterable_mapping

A project that simply takes the hashes of any complete transaction and adds it to an array, then maps the hash to the address that made the transaction. Hence, you can get the address of a particular hash by simply spotting their index on the array, then with the hash value at that index, grab the address.

Deployment address: https://rinkeby.etherscan.com/addresses/0x1A09e937AB84b5434a70aDaBC69b9884B85ED123d0d0EC2



> - 5. ERC-20 Token (Aguia -> $AGU)

https://github.com/fps8k/my-solidity/tree/main/erc20%20-%20%24AGU

This is my first ERC-20 standard token, named Aguia (Portuguese for "Eagle") with symbol $AGU. It has 1,000,000 tokens in supply with the ability to mint (add) or burn (reduce the number of) more tokens. It was hosted on the rinkeby etherscan network with token contract address : 0x2DFA0332E058c4FcC9d1b8C165eFf1CF52368d03

Deployment address: https://rinkeby.etherscan.io/address/0x2DFA0332E058c4FcC9d1b8C165eFf1CF52368d03
