// SPDX-License-Identifier: MIT

pragma solidity >0.6.0;

/**
    I believe youve gone through the description.md file to know what a Merkle Tree is all about. Its pretty big innit?
*/

contract MerkleTree
{
    /**
        I will be needing some public functions, and i will avoid verification like i did on multi sig wallet

        Function 1 (Make_Transaction):

        - Make a transaction.
        - Hash the transaction.
        - Adds the hashed transaction to a list.



        Function 2 (Start_Merkle):

        - Performs the act explained in description.md


        Function 3 (Verify_Transaction (tx_hash)):

        -
    */


    address payable owner;

    // for reentrancy
    bool locked;

    // This array will be useful when we want to compute out merkle tree
    bytes32[][] merkle;

    // This array will be a storage for all our transactions
    bytes32[] all_transactions;


    constructor()
    {
        // first I will need to assign the owner to myself. 😌
        owner = payable(msg.sender);
    }

    modifier No_Reentrancy()
    {
        require(!locked, "You cant repeat this action");
        locked = true;
        _;
        locked =  false;
    }

    // I will have a function that allows us to make a transaction and will add the transaction to an array;
    function Make_Transaction(address receiver, uint amount) payable public No_Reentrancy
    {
        // payable(receiver).transfer(amount);
        payable(receiver).call{value: amount}("");

        
        // This string(abi.encodePacked(a, b, c)) will stringify all the actions done and add them to an array "all_transactions"
        all_transactions.push(keccak256(abi.encodePacked(msg.sender, receiver, amount)));
    }

    function Compute_Merkle() internal
    {
        // The most important thing, getting the length of the last array in the merkle
        bytes32[] memory this_merkle = merkle[merkle.length - 1];

        uint len_last_merkle_list = this_merkle.length;

        // if the length is one then it should stop
        if(len_last_merkle_list == 1)
        {
            return;
        }
        else
        {
            // if the length is greater than one, then some calculations would be needed.
            // We need to group them in twos and duplicate the last on if its odd
            // Then update the merkle list

            uint even_or_odd = len_last_merkle_list % 2;
            if(even_or_odd == 1)
            {
                uint new_length = (len_last_merkle_list / 2) + 1;
                bytes32[] memory append = new bytes32[](new_length);
                //  if its odd

                // Here we will consider the last list in the merkle because we are going to duplicate it.
                // if the index is not the last index of this_merkle

                for (uint x = 0; x < len_last_merkle_list; x+=2)
                {
                    // if x is not the last inde
                    if(x == (len_last_merkle_list - 1))
                    {
                        // this is the last one so should be hashed twice.
                        append[x] = keccak256(abi.encodePacked(this_merkle[x], this_merkle[x]));
                    }
                    else
                    {
                         // it should group them in twos and hash.
                        append[x] = keccak256(abi.encodePacked(this_merkle[x], this_merkle[x+1]));
                    }
                }

                merkle.push(append);
                Compute_Merkle();
            }
            else
            {
                // if the merkle length is even

                // develop the length of the new array from the length of the initial one i.e initial / 2;
                uint new_length = len_last_merkle_list / 2;

                // create a new array
                bytes32[] memory append = new bytes32[](new_length);

                // loop and group them into twos and hash
                for (uint x = 0; x < len_last_merkle_list; x+=2)
                {
                    // it should group them in twos and hash.
                    append[x] = keccak256(abi.encodePacked(this_merkle[x], this_merkle[x+1]));
                }
                merkle.push(append);
                Compute_Merkle();
            }
        }
    }

    function Start_Merkle() public
    {
        if(merkle.length > 0)
        {
            delete merkle;
        }

        // merkle computation starts here
        // first, we need to get the length of the transaction array and do a loop that calls a function.
        uint tx_length = all_transactions.length;
        
        require(tx_length > 1, "Cannot compute merkle length for this transaction records.");
        
        // first we loop through the all_transactions array to add them to the merkle as the base ot leafs.
        // this will generate the first array in out merkle array.

        // declare a new memory uint
        bytes32[] memory mem = new bytes32[](tx_length);
        for (uint i = 0; i < tx_length; i++)
        {
            mem[i] = all_transactions[i];
        }

        merkle.push(mem);
        // Compute_Merkle();
    }

    function Get_TX_Length() public view returns(uint)
    {
        return all_transactions.length;
    }

    function Get_Merke_Length() public view returns(uint)
    {
        return merkle.length;
    }
}