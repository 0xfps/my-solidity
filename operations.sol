// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/*
    
*/
import "./libraries/PureMath.sol";

contract math
{
    // Test out operators listed in the operators.
    // using PureMath for uint;
    
    function add() public pure returns(uint)
    {
        uint[] memory t = new uint[](6);
        t[0] = 1;
        t[1] = 2;
        t[2] = 3;
        t[3] = 4;
        t[4] = 5;
        t[5] = 6;

        uint ans = PureMath.mul_arr(t);
        return ans;
    }
}