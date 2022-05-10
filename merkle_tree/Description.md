

/**
    M E R K L E   T R E E

    --- What is a Merkle Tree? ---

    - A Merkle tree is a hash-based data structure that is a generalization of the hash list.
    - It is a tree structure in which each leaf node is a hash of a block of data.
    - Each non-leaf node is a hash of its children. 
    - Typically, Merkle trees have a branching factor of 2, meaning that each node has up to 2 children.

    - Merkle trees are used in distributed systems for efficient data verification. 
    - They are efficient because they use hashes instead of full files. 
    - Hashes are ways of encoding files that are much smaller than the actual file itself. 
    - Currently, their main uses are in peer-to-peer networks such as Tor, Bitcoin, and Git.



    --- How to build a MerkleTree? ---

    - We need to first have a list of transactions that we will. It is advisable that the transactions used for a Merkle Tree
    should be in powers of 2, or should be even, i.e, the number of the transactions should be in 2^n. But should the number be odd, we need to 
    duplicate the last transaction to make it even.

    - Then we pair up the transactions in 2s and hash them, and the resulting hashes, we pair them again and hash them again.

    - In the end: 👇🏾👇🏾👇🏾
 

                                                     ________________                                                     
                                                     |              |                                                     
                                                     | Tx 1,2, 3, 4 |  
                                                     |______________|   
                                                            |                                                                   
                                                            |                                                                   
                                                            |                                                                   
                                                            |      
                            _____________________________________________________________________
                            |                                                                   |
                            |                                                                   |
                            |                                                                   |
                            |                                                                   |
                      ______________                                                     ______________
                      |            |                                                     |            |
                      |   Tx 1,2   |                                                     |    Tx 3,4  |
                      |____________|                                                     |____________|
                            |                                                                   |
                            |                                                                   |
                            |                                                                   |
                            |                                                                   |
         ______________________________________                              ______________________________________
         |                                    |                              |                                    |
         |                                    |                              |                                    |
         |                                    |                              |                                    |
         |                                    |                              |                                    |
    ______________                    ______________                    ______________                    ______________
    |            |                    |            |                    |            |                    |            |
    |    Tx 1    |                    |    Tx 2    |                    |     Tx 3   |                    |    Tx 4    |
    |____________|                    |____________|                    |____________|                    |____________|
*/