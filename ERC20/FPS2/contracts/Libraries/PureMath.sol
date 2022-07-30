// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/*
    @title: PureMath.
    @author: Anthony (fps) https://github.com/0xfps.
    @dev: A library for basic math works. This will constantly be updated.
*/
library PureMath {
    // Decimal setting
    /*
        @notice: This decimals is used for fixed calculations in cases where decimals are not specified.
        See functions {perc()} and {set_perc()} for use cases of this decimal.
        See functions {div()} and {set_div()} for use cases of this decimal.
    */
    uint8 internal constant DECIMAL = 4;

    /*
        @dev: {try_add()} function.

        * Takes in numbers and tries to add and returns true or false.
    */
    function try_add(uint a, uint b) internal pure returns(bool, uint) {
        uint total = a + b;
        return (true, total);
    }

    /*
        @dev: {try_sub()} function.

        * Takes in numbers and tries to subtrace and returns true or false.
    */
    function try_sub(uint a, uint b) internal pure returns(bool, uint){
        if (b > a) {
            return (false, 0);
        } else {
            uint left = a - b;
            return (true, left);
        }
    }

    /*
        @dev: {try_mul()} function.

        * Tries to multiply two numbers.
    */
    function try_mul(uint a, uint b) internal pure returns(bool, uint) {
        uint prod = a * b;
        return (true, prod);
    }

    /*
        @dev: {try_div()} function.

        * Tries to divide two numbers.
    */
    function try_div(
        uint a, 
        uint b, 
        string memory message
    ) internal pure returns(
            bool, 
            uint, 
            string memory
        )
    {
        if (b == 0) {
            return(false, 0, message);
        } else {
            uint _div = a / b;
            return (true, _div, message);
        }
    }
    
    /*
        @dev: {try_mod()} function.

        * Tries to get the modulus of two numbers.
    */
    function try_mod(
        uint a, 
        uint b, 
        string memory message
    ) internal pure returns(
            bool, 
            uint, 
            string memory
        )
    {
        if (b == 0) {
            return(false, 0, message);
        }
        else {
            uint _mod = a % b;
            return (true, _mod, message);
        }
    }

    /*
        @dev: {add()} function.

        * Takes in two numbers and returns the total.
    */
    function add(uint a, uint b) internal pure returns(uint) {
        uint total = a + b;
        return total;
    }

    /*
        @dev: {sub()} function.

        * Takes in two numbers and returns the difference on the grounds that the second is less than the first.
        * Tries to do `a` - `b`.
    */
    function sub(uint a, uint b) internal pure returns(uint) {
        require(a >= b, "Library error: Second parameter should be less or equal to the first.");
        uint left = a - b;
        return left;
    }

    /*
        @dev: {mul()} function.

        * Takes in two numbers and returns the product, while making sure that the product doesn't overflow the uint256 limit.
    */
    function mul(uint a, uint b) internal pure returns(uint) {
        require((a * b) <= ((2 ** 256) - 1), "Library Error, Number overflow.");
        uint prod = a * b;
        return prod;
    }

    /*
        @dev: {div()} function.

        * Takes in two numbers and returns the division.

        @notice: When working with the division, for all numbers, it returns the number to 4 decimal places...
        Meaning that doing `6 / 3` will return `20_000` which should be read as `200`...
        Also doing `1 / 2` will return `500` which will be read as `0.5`...

    */
    // This makes sure that for ever division with an unset decimal, the denominator won't be larger than the numerator.
    modifier divisor_control(uint a, uint b) {
        uint control = a * (10 ** DECIMAL);
        require(b <= control, "Syntax Error: This is out of place.");
        _;
    }
    
    function div(uint a, uint b) internal pure divisor_control(a, b) returns(uint) {
        require(b > 0, "Library Error, Zero division error.");
        uint rem = (a * (10 ** DECIMAL)) / b;
        return rem;
    }

    /*
        @dev: {set_div()} function.

        * Takes in two numbers and its decimal place that is desired to be returned in and returns the boolean division.
        * It applies the same algorithm as {div()} function.

    */
    // This makes sure that for ever division with an set decimal, the denominator won't be larger than the numerator.
    modifier set_divisor_control(
        uint a, 
        uint b, 
        uint _d
    )
    {
        uint control = a * (10 ** _d);
        require(b <= control, "Syntax Error: This decimal is out of place.");
        _;
    }

    function set_div(
        uint a, 
        uint b, 
        uint _decimal
    ) internal pure set_divisor_control(
            a, 
            b, 
            _decimal
        ) returns(bool, uint)
    {
        require(b > 0, "Library Error, Zero division error.");
        require(_decimal > 0, "Library Error, Decimal place error.");
        uint rem = (a * (10 ** _decimal)) / b;
        return (true, rem);
    }

    /*
        @dev: {exp()} function.

        * Takes in two numbers and returns the exponent.
    */
    function exp(uint a, uint b) internal pure returns(uint) {
        require((a ** b) <= ((2 ** 256) - 1), "Library Error, Number overflow.");
        uint prod = a ** b;
        return prod;
    }
    
    /*
        @dev: {mod()} function.

        * Takes in two numbers and returns the remainder gotten when the first is divided by the second.
        * Does `a` mod `b`.
    */
    function mod(uint a, uint b) internal pure returns(uint) {
        require(b > 0, "Library Error, Zero division error.");
        //if b > a, logically, 3 % 4 == 3.
        if (b > a) {
            return a;
        } else {
            uint modulus = a % b;
            return modulus;
        }
    }

    /*
        @dev: {add_arr()} function.

        * Takes in an array of numbers and adds them and returns the cumultative total
    */
    function add_arr(uint[] memory arr) internal pure returns(uint) {
        uint total = 0;
        
        for (uint i = 0; i < arr.length; i++) {
            total += arr[i];
        }

        return total;
    }

    /*
        @dev: {mul_arr()} function.

        * Takes in an array of numbers and adds them and returns the cumultatve product.
    */
    function mul_arr(uint[] memory arr) internal pure returns(uint) {
        uint prod = 1;

        for (uint i = 0; i < arr.length; i++) {
            prod *= arr[i];
        }

        return prod;
    }

    /*
        @dev: {perc()} function.

        * Calculates the a% of b i.e (a*b / 100) but it returns in the default 4 decimal places with a modifier in place to make sure that the numerator...
        * Does not overflow the denominator.
    */

    modifier valid_percentage() {
        require(DECIMAL >= 2, "Syntax Error: This is out of place.");
        _;
    }

    function perc(uint a, uint b) internal pure valid_percentage() returns(uint) {
        require(b > 0, "Library Error, Zero division error.");
        uint perc_val = (a * b * (10 ** DECIMAL)) / 100;
        return perc_val;
    }

    /*
        @dev: {set_perc()} function.

        * Calculates the a% of b i.e (a*b / 100) but it returns in the decimal place passed with a modifier in place to make sure that the numerator...
        *
        *
        *
        *
        * This should be used when calculating decimal percentages of whole numbers e.g 1.5% of 8.
        *
        * Solution: This should return `0.12` on a normal calculator, but Solidity is different.
        *
        * 1. Pick the decimal places you want to return it in, say 5. 
        * 2. To get 1.55 to the nearest whole integer == 1.55 * 100. Take note, 100 == 10 ** 2.
        * 3. The function will return the solution, in the decimal place of 5 + (the power of 10 that makes the decimal a nearest whole, i.e, 2) == 7;
        * 4. Answer is in 7 dp.
        * 4. 1200000 divided by 10 ** 7 == 0.12, there you go.
        *
        *
        * Does not overflow the denominator.
    */
    modifier set_valid_percentage(uint _d){
        require(_d >= 2, "Syntax Error: This is out of place.");
        _;
    }

    function set_perc(
        uint a, 
        uint b, 
        uint _decimal
    )   
        internal 
        pure 
        set_valid_percentage(_decimal) 
        returns(uint)
    {
        require(b > 0, "Library Error, Zero division error.");
        uint perc_val = (a * b * (10 ** _decimal)) / 100;
        return perc_val;
    }
}
