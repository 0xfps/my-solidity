// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/**
* @title MultiSig Wallet.
* @author Anthony (fps) https://github.com/0xfps.
* @dev 
* D E S C R I P T I O N
* A basic solidity program that allows the creation of a wallet in the contract.
* Wallet owners can:
* 1. Submit a transaction.
* 2. Approve and revoke a pending transaction.
* 3. Anyone can execute a transaction after enough owners has approved it.
*/
contract MultiSigWallet {
    struct Data {
        address wallet_owner;
        uint256 funds;
        uint256 deposit_to_receiver;
        address receiver;
        int256 approve_count;
    }

    mapping(address => Data) private owners;
    uint256 public wallets;

    function createWallet(address _creator) public payable {
        require(msg.sender != address(0), "!Address");
        require(_creator != address(0), "!Creator Address");
        require(owners[_creator].wallet_owner == address(0), "Wallet created already.");
        require(msg.value > 0, "Creation fund == 0");
        owners[_creator] = Data(_creator, msg.value, 0, address(0), 0);
        wallets ++;
    }

    function getFunds(address acc) private view returns(uint funds) {
        funds = owners[acc].funds;
    }

    function fundWallet() public payable {
        require(msg.sender != address(0), "!Address"); // Valid address.
        require(owners[msg.sender].wallet_owner == msg.sender, "Wallet !Created");
        owners[msg.sender].funds += msg.value;
        // Funds the contract on his behalf but has a record of how much he has deposited.
    }

    function makeTransaction(address _receiver, uint _amount) public {
        require(msg.sender != address(0), "!Address"); // Valid address.
        require(_receiver != address(0), "!Receiver Address"); // Valid receiver.
        require(_receiver != msg.sender, "Sender ! Receiver");
        require(owners[msg.sender].wallet_owner != address(0), "Wallet !Created");
        require(owners[msg.sender].receiver == address(0), "There is a pending txn"); // There is no pending transaction.
        require(owners[_receiver].wallet_owner != address(0), "Receiver !created.");
        require(getFunds(msg.sender) > _amount, "Funds < value");
        owners[msg.sender].receiver = _receiver;
        owners[msg.sender].funds -= _amount;
        owners[msg.sender].deposit_to_receiver += _amount;
    }
    
    function confirmTransaction(address _txn_maker) public {
        require(msg.sender != address(0), "!Address"); // Valid address.
        require(owners[msg.sender].wallet_owner != address(0), "Wallet !Created");
        require(msg.sender != owners[_txn_maker].wallet_owner, "!Approve");
        require(owners[_txn_maker].wallet_owner != address(0), "Wallet !Created");
        require(owners[_txn_maker].receiver != address(0), "!Receiver in this txn");
        owners[_txn_maker].approve_count += 1;
    }

    function revokeTransaction(address _txn_maker) public {
        require(msg.sender != address(0), "!Address"); // Valid address.
        require(owners[msg.sender].wallet_owner != address(0), "Wallet !Created");
        require(owners[_txn_maker].wallet_owner != address(0), "Wallet !Created");
        require(msg.sender != owners[_txn_maker].wallet_owner, "!Revoke");
        require(owners[_txn_maker].receiver != address(0), "!Receiver in this txn");
        owners[_txn_maker].approve_count -= 1;
    }

    function finishTransaction(address _txn_maker) public payable {
        require(msg.sender != address(0), "!Address"); // Valid address.
        require(owners[_txn_maker].wallet_owner != address(0), "Wallet !Created");
        require(msg.sender == owners[_txn_maker].wallet_owner, "!Finish");
        require(owners[_txn_maker].receiver != address(0), "!Receiver in this txn");
        require(owners[_txn_maker].approve_count > int256(wallets / 2), "Not approved yet.");
        uint256 temp_bal = owners[_txn_maker].deposit_to_receiver;
        address _receiver_wallet = owners[_txn_maker].receiver;
        payable(_receiver_wallet).transfer(temp_bal);
        owners[_txn_maker].deposit_to_receiver = 0;
        delete owners[_txn_maker].receiver;
    }
}
