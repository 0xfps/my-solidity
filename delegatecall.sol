// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/*
    * @title: Delegatecall function test.
    *
    * @author: Anthony (fps) @ https://github.com/fps8k 🎧.
*/
contract A
{
    uint a;
    uint b;
    address c;

    function addup(uint inp) public
    {
        a = inp * 2;
    }

    function show() public view returns(uint)
    {
        return a;
    }
}





contract B
{
    uint a;
    uint b;
    address c;

    function addup(address _add) public
    {
        (bool sent, ) = _add.delegatecall(abi.encodeWithSelector(A.addup.selector, 8));
        // _add.delegatecall(abi.encodeWithSignature("addup()", 8));
        require(sent, "Function not called");
    }

    function show() public view returns(uint)
    {
        return a;
    }
}