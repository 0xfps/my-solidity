// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/*
 * @title: EtherWallet, a crowdfunding smart contract.
 * @author: Anthony (fps) https://github.com/fps8k .
 * @dev: Ether Wallet: https://github.com/fps8k/my-solidity/tree/main/ether_wallet
 * This is a simple Solidity program that allows anyone to send ether to a wallet then allowing only the owner to withdraw.
*/
contract EtherWallet {
    // Declare owner, deploy time, ended, and locking.
    address owner;
    uint256 deploy_time;
    bool ended;
    bool locked;

    // Events.
    event Deployed(address, uint256);           // owner, deploy_time.
    event Funded(address, uint256);             // msg.sender, msg.value.
    event Withdraw(address, uint256);           // owner, address(this).balance.

    constructor() {
        owner = msg.sender;             // Set the owner of the contract to the deployer.
        deploy_time = block.timestamp;  // Set time of deployment.
        ended = false;                  // Ended to control the funding.
        emit Deployed(owner, deploy_time);
    }

    modifier NoReentrance() {
        require(!locked, "You cannot redo this action.");
        locked = true;
        _;
        locked = false;
    }

    function fund() public payable NoReentrance {
        require(msg.sender != address(0), "!Address");
        require(msg.sender != owner, "Owner !Send");
        emit Funded(msg.sender, msg.value);
    }

    function viewFunds() public view returns(uint256 balance) {
        require(msg.sender == owner, "!Owner");
        balance = address(this).balance;
    }

    function withdrawFunds() public payable NoReentrance {
        require(msg.sender == owner, "!Owner");
        uint256 bal = address(this).balance;
        payable(owner).transfer(address(this).balance);
        emit Withdraw(msg.sender, bal);
    }
}
