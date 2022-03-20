// SPDX-License-Identifier: MIT

pragma solidity >0.6.0;

/**
* Assembly code;
*/

contract IterableMapping
{
    function returnAssembly() public pure returns(uint)
    {
        uint c;
        assembly
        {
            c := add(5, 6)
        }

        return c;
    }
}