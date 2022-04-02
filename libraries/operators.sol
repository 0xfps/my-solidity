// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/*
    @title: Math Operations.
    @author: Anthony (fps).
    @dev: A library for basic math works. This will constantly be updated.
*/

library operations
{
    // Decimal setting
    uint8 internal constant DECIMAL = 4;

    modifier divisor_control(uint a, uint b)
    {
        uint control = a * (10 ** DECIMAL);
        require(b <= control, "Syntax Error: This is out of place.");
        _;
    }

    /*
        @dev: {try_add()} function.

        * Takes in an array of numbers and tries to add and returns true or false
    */
    function try_add(uint a, uint b) internal pure returns(bool, uint)
    {
        uint total = a + b;
        return (true, total);
    }




    /*
        @dev: {add_arr()} function.

        * Takes in an array of numbers and tries to multiply them
    */
    function try_mul(uint a, uint b) internal pure returns(bool, uint)
    {
        uint prod = a * b;
        return (true, prod);
    }




    /*
        @dev: {try_div()} function.

        * Takes in an array of numbers and adds them and returns the total
    */
    function try_div(uint a, uint b, string memory message) internal pure returns(bool, uint, string memory)
    {
        if (a == 0 || b == 0)
        {
            return(false, 0, message);
        }
        else
        {
            uint _div = a / b;
            return (true, _div, message);
        }
    }




    /*
        @dev: {add()} function.

        * Takes in two numbers and returns the total.
    */
    function add(uint a, uint b) internal pure returns(uint)
    {
        uint total = a + b;
        return total;
    }



    /*
        @dev: {sub()} function.

        * Takes in two numbers and returns the difference on the grounds that the second is less than the first.
    */
    function sub(uint a, uint b) internal pure returns(uint)
    {
        require(a >= b, "Library error: Second parameter should be less or equal to the first.");
        uint left = a - b;
        return left;
    }



    /*
        @dev: {mul()} function.

        * Takes in two numbers and returns the product.
    */
    function mul(uint a, uint b) internal pure returns(uint)
    {
        require((a * b) <= ((2 ** 256) - 1), "Library Error, Number overflow.");
        uint prod = a * b;
        return prod;
    }



    
    /*
        @dev: {div()} function.

        * Takes in two numbers and returns the division.

        @notice: When working with the division, for all numbers, it returns the number to 18 decimal places...
        Meaning that doing `6 / 3` will return `200` which should be read as `2.000 000 000 000 000 000`...
        Also doing `1 / 2` will return `500 000 000 000 000 000` which will be read as `0.500 000 000 000 000 000`...

    */
    function div(uint a, uint b) internal pure divisor_control(a, b) returns(uint)
    {
        require(b > 0, "Library Error, Zero division error.");

        uint rem = (a * (10 ** DECIMAL)) / b;
        return rem;
    }




    
    /*
        @dev: {exp()} function.

        * Takes in two numbers and returns the exponent.
    */
    function exp(uint a, uint b) internal pure returns(uint)
    {
        require((a ** b) <= ((2 ** 256) - 1), "Library Error, Number overflow.");
        uint prod = a ** b;
        return prod;
    }

    
    /*
        @dev: {mod()} function.

        * Takes in two numbers and returns the remainder gotten when the first is divided by the second.
    */

    function mod(uint a, uint b) internal pure returns(uint)
    {
        require(b > 0, "Library Error, Zero division error.");

        //if b > a, logically, 3 % 4 == 0.

        if(b > a)
        {
            return 0;
        }
        else
        {
            uint modulus = a % b;
            return modulus;
        }
    }



    
    /*
        @dev: {add_arr()} function.

        * Takes in an array of numbers and adds them and returns the cumultative total
    */
    function add_arr(uint[] memory arr) internal pure returns(uint)
    {
        uint total = 0;
        for (uint i = 0; i < arr.length; i++)
        {
            total += i;
        }

        return total;
    }




    /*
        @dev: {mul_arr()} function.

        * Takes in an array of numbers and adds them and returns the cumultatve product.
    */
    function mul_arr(uint[] memory arr) internal pure returns(uint)
    {
        uint prod = 1;
        for (uint i = 0; i < arr.length; i++)
        {
            prod *= i;
        }

        return prod;
    }


    

    /*
        @dev: {f_exp()} function.

        * Short for force exponent, these functions with f_ prepended will make sure both values are >= 1 before making their calculations
    */
}
