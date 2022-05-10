// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;
import "./Utils/Store.sol";
import "./Utils/Admin.sol";

/*
 * @title: 
 * @author: Anthony (fps) https://github.com/fps8k .
 * @dev: 
*/

contract Proxy is Store, Admin
{
    function add(uint _a, uint _b) public
    {
        address cont = current_contract;
        (bool sent, ) = cont.delegatecall(abi.encodeWithSignature("add(uint256,uint256)", _a, _b));
        require(sent, "Delegatecall, failed");
    }

    function getTotal() public view returns(uint)
    {
        return total;
    }

    function gt() public view returns(address)
    {
        return current_contract;
    }
}