// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/*
    
*/
import "./libraries/PureMath.sol";

contract math
{
    // Test out operators listed in the operators.
    uint j = 9;
}

contract f is math
{
    function show() public view returns(uint)
    {
        return math.j;
    }
}