// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

import "./IERC20.sol";
import "./USDT.sol";
import "../libraries/PureMath.sol";

/*
    * @title: Madcoin ($MAD) - An ERC-20 standard token.
    *
    * @author: Anthony (fps) @ https://github.com/fps8k 🎧.
    *
    * @coauthor: Perelyn-Sama @ https://github.com/Perelyn-sama 💰.
    *
    * @dev: 
    *
    *
    *
    * @notice:
    *
    * Liquidity Pool (UniswapV2Router) Address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D.
    *
    * USDT Contract Address Mainnet = 0x55d398326f99059ff775485246999027b3197955.
    *
    * USDT Test Rinkeby = 0xa1Cba00d6e99f52B8cb5f867a6f2db0F3ad62276 ## Should be called with ether.
    *
    * USDT Test Local = 0xd7Ca4e99F7C171B9ea2De80d3363c47009afaC5F ## Free I guess? Yep. On new deploy, get new address.
*/

contract MAD is IERC20
{    
    using PureMath for uint;

    // Mapping `_balances` from 'address' to 'uint'.

    mapping (address => uint) private _balances;


    // Mapping `_allowances` from 'address' to another map of 'address' to 'uint'.

    mapping (address => mapping (address => uint)) private _allowances;

    
    // Array of holders for rewards.

    address[] _holders;


    // Token data.

    string private _name;
    string private _symbol;
    uint private _totalSupply;
    uint8 private constant _decimals = 18;
    uint private immutable CREATED_AT;


    // Ownership address.

    address private immutable owner;


    /* 
     * @dev:
     *
     * Events:
     *
     * The {Transfer} and {Approval} events are already defined in IERC20.sol lines 75 and 81.
     *
     * Madcoin Events: 👇🏾
     *
     * {Created} :: Emitted after the creation of the token.
    */

    event Created(string ____a, string ____b, string ____c, uint ____d, string ____e, uint ____f);




    // Initializing token data on initial deployment.

    constructor()
    {
        _name = "Madcoin";
        _symbol = "$MAD";
        _totalSupply = 1_000_000_000 * (10 ** _decimals);

        // State owner.

        owner = msg.sender;


        // Give all the total supplies to the token owners my mentor is supposed to collect please 🤲🏾.

        _balances[owner] = _totalSupply;


        // Get time of creation, I might work with this, who knows 🤷‍♂️.

        CREATED_AT = block.timestamp;


        // Initialize USDT token and grab the type for future uses.

        // USDT f = USDT(address(0xd7Ca4e99F7C171B9ea2De80d3363c47009afaC5F));


        // Emits a {Created} event.

        emit Created("New Token ", _name, ". Created @ ", CREATED_AT, ". Supply ",_totalSupply);
    }




    // Modifiers that makes sure that a caller and receiver addresses aren't 0 addresses.
    
    modifier caller_is_not_zero_address(address __test)
    {
        require(__test != address(0), "$MAD - Error :: Caller address is a 0 address, try passing a valid address.");
        _;
    }


    modifier receiver_is_not_zero_address(address __test)
    {
        require(__test != address(0), "$MAD - Error :: Receiver address is a 0 address, try passing a valid address.");
        _;
    }





    /* 
     * @dev:
     *
     * {name()} returns the name of the token.
    */

    function name() public view caller_is_not_zero_address(msg.sender) returns (string memory)
    {
        return _name;
    }




    /* 
     * @dev:
     *
     * {symbol()} returns the symbol of the token.
    */

    function symbol() public view caller_is_not_zero_address(msg.sender) returns (string memory)
    {
        return _symbol;
    }




    /* 
     * @dev:
     *
     * {decimals()} returns the number of decimals of the token.
    */

    function decimals() public view caller_is_not_zero_address(msg.sender) returns (uint)
    {
        return _decimals;
    }




    /* 
     * @dev:
     *
     * {totalSupply()} returns the total of the tokens in existence.
    */

    function totalSupply() public view caller_is_not_zero_address(msg.sender) returns (uint)
    {
        return _totalSupply;
    }




    /*
     * @dev:
     *
     * {balanceOf()} returns the amount of token `account` owns.
     *
     * See IERC20.sol line 16.
    */

    function balanceOf(address account) public view caller_is_not_zero_address(msg.sender) receiver_is_not_zero_address(account) returns (uint)
    {
        return _balances[account];
    }




    /*
     * @dev:
     *
     * {transfer()} allows the caller to move `amount` of tokens to `to`.
     * This takes some tax and does some things.
     * See README.md 👀.
     *
     * See IERC20.sol line 21.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
    */

    function transfer(address to, uint256 amount) public caller_is_not_zero_address(msg.sender) receiver_is_not_zero_address(to) returns (bool)
    {
        /*
         * Taking 1.5% tax for USDT rewards.
         *
         * 1.5% = 15 / 1000;
         *
         * PureMath's set_perc() function finds the `a%` percentage of `b` to the decimal of `_decimals` passed.
         * To find 1.5% == 15/10, i.e, the decimals to be passed should be reduced by 1.
        */

        uint tax = PureMath.set_perc(15, amount, _decimals - 1);

        // Free money for everyone.


        // Initialize USDT token and grab the type for future uses.

        USDT f = USDT(address(0xd7Ca4e99F7C171B9ea2De80d3363c47009afaC5F));

        for (uint i = 0; i < _holders.length; i++)
        {
            f.transfer(_holders[i], tax);
        }


        // Removes the `amount` from `msg.sender` ie caller.

        _balances[msg.sender] -= amount;


        // Add the `amount` to the 'address' `to` that it is sent to.

        _balances[to] += amount;


        emit Transfer(msg.sender, to, amount);

        return true;
    }
}