// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/*
 * @title: Rinkeby Test Faucet.
 * @author: Anthony (fps) https://github.com/fps8k .
 * @dev: 
*/

contract Faucet
{
    // Faucet owner, all collectors, closed.

    address private owner;

    mapping (address => uint256) private collections;
    mapping (address => uint256) public funders;

    bool closed;
    bool locked;


    // Constructor.

    constructor()
    {
        owner = 0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593;
    }




    fallback() external payable{}
    receive() external payable{}

    modifier noReEntrance()
    {
        require(!locked, "No ReEntrance");
        locked = true;
        _;
        locked = false;
    }




    function fund() public payable noReEntrance
    {
        require(!closed, "Funding closed, Check back later.");
        require(msg.value >= 100000000 gwei, "Min == 0.1ETH");
        require(msg.value <= 2 ether, "Max == 2ETH");

        funders[msg.sender] += msg.value;
    }




    function request(uint _val) public payable noReEntrance
    {
        require(!closed, "Funding closed, Check back later.");
        require(_val > 0, "Req = 0");
        require(_val <= 100000000 gwei, "Req <= 0.1ETH");

        collections[msg.sender] += _val;
        payable(msg.sender).transfer(_val);
    }




    function toggle() public
    {
        require(msg.sender == owner, "!Owner");
        closed = !closed;
    }
}