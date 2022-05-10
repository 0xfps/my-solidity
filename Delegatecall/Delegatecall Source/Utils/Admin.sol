// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/*
 * @title: 
 * @author: Anthony (fps) https://github.com/fps8k .
 * @dev: 
*/

contract Admin
{
    address public current_contract; // Address of Main.
    mapping(address => bool) public admins;

    modifier isAdmin()
    {
        require(admins[msg.sender], "Not an admin");
        _;
    }

    function acceptAdmin(address _address) public isAdmin
    {
        require(_address != address(0), "Zero address");
        require(!admins[_address], "Already an admin");

        admins[_address] = true;
    }

    function revokeAdmin(address _address) public isAdmin
    {
        require(_address != address(0), "Zero address");
        require(admins[_address], "Not an admin");

        admins[_address] = true;
        // require(_address != current_contract, "Same address");
        // current_contract = new_contract;
    }

    function upgrade(address new_contract) public isAdmin
    {
        require(new_contract != address(0), "Zero address");
        require(new_contract != current_contract, "Same address");
        current_contract = new_contract;
    }
}