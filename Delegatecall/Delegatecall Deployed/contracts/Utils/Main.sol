// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;
import "./Store.sol";

/*
 * @title: 
 * @author: Anthony (fps) https://github.com/fps8k .
 * @dev: 
*/

contract Main is Store
{
    function add(uint _a, uint _b) public
    {
        total = _a + _b;
    }
}