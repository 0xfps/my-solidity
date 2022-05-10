// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/*
 * @title: AddressBook contract.
 * @author: Anthony (fps) https://github.com/fps8k .
 * @dev: 
*/

contract AddressBook
{

    // Mapping the name to the addresses.

    mapping(address => mapping(string => address)) private book;


    // Events.

    event Add(string, address);                                 // Name, Address.
    event Remove(string, address);                              // Name, Address.
    event ChangeName(string, string, address);                  // Old name, New name, Old address, New address.
    event ChangeAddress(string, address, address);              // Old name, New name, Old address, New address.
    



    modifier isValidSender()
    {
        require(msg.sender != address(0), "!Address");
        _;
    }




    function exists(string memory _search) private view returns(bool)
    {
        return book[msg.sender][_search] != address(0);
        // Returns true if the name is saved.
    }



    
    function add(string memory _name, address _address) public isValidSender
    {
        require(bytes(_name).length > 0, "Empty");
        require(_address != address(0), "!Address");
        require(!exists(_name), "Name Exists");


        book[msg.sender][_name] = _address;

        emit Add(_name, _address);
    }




    function remove(string memory _name) public isValidSender
    {
        require(bytes(_name).length > 0, "Empty");
        require(exists(_name), "Name !Exists");

        address _address = book[msg.sender][_name];
        delete book[msg.sender][_name];

        emit Remove(_name, _address);
    }




    function updateAddress(string memory _name, address _address) public isValidSender
    {
        require(bytes(_name).length > 0, "Empty");
        require(_address != address(0), "!Address");
        require(!exists(_name), "Name Exists");

        address old_address = book[msg.sender][_name];
        book[msg.sender][_name] = _address;

        emit ChangeAddress(_name, old_address, _address);
    }




    function updateName(string memory _name, string memory new_name) public isValidSender
    {
        require(bytes(_name).length > 0, "Empty");
        require(bytes(new_name).length > 0, "New Name Empty");
        require(exists(_name), "Name !Exists");
        require(!exists(new_name), "New Name Exists");
        
        address _address = book[msg.sender][_name];

        book[msg.sender][new_name] = _address;
        delete book[msg.sender][_name];

        emit ChangeName(_name, new_name, _address);
    }




    function getAddress(string memory _name) public view isValidSender returns(address)
    {
        require(bytes(_name).length > 0, "Empty");
        require(exists(_name), "Name !Exists");

        return book[msg.sender][_name];
    }

}