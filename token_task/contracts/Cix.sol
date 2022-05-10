// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/*
 * @title: Cix, an ERC-20 standard token see README.md.
 *
 * @author: Anthony (fps), https://github.com/fps8k.
 *
 * @dev: 
*/

import "./IERC20.sol";
import "./Liquidity.sol";
import "./libraries/PureMath.sol";
import "./Taxes.sol";

contract Cix is IERC20, Taxes
{
    /*
        - All getter functions. // Here.
        - 6 IERC20 functions. // Here.
        - Tax functions. // Taxes.
        - Tax change functions. // Taxes.
        - Liquidity functions. // Liquidities.
    */

    using PureMath for uint256;


    // Mapping addresses to balances.

    mapping(address => uint256) private _balances;


    // Array of token holders.

    // address[] private _holders;


    // Mapping of allowances.

    mapping(address => mapping (address => uint256)) private _allowances;


    // Mapping accounts that own at least a token to a boolean.

    mapping(address => bool) private _is_owning_tokens;


    // Token details.

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    address private _owner;


    IUniswapV2Router02 private uniswap_v2_router;
    address private factory; 
    address private uniswap_pair;


    address private dev = 0x0000000000000000000000000000000000000000;
    address private env = 0x0000000000000000000000000000000000000000;
    address private mkt = 0x0000000000000000000000000000000000000000;

    address private usdt_address = 0x770861CdcdDF8319C6C86ef8EF91C4A922fc12aC;



    constructor()
    {

        _name = "Cix";
        _symbol = "CIX";
        _decimals = 18;
        _totalSupply = 1_000_000_000 * (10 ** _decimals);
        _owner = 0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593;


        // Initialize the token to the different addresses.

        uint256 power = uint64(10 ** _decimals);

        // Token owner share

        _balances[_owner] = 500_000_000 * power;


        // Dev, marketing and environmental causes wallet.

        _balances[dev] = 100_000_000 * power;
        _balances[env] = 100_000_000 * power;
        _balances[mkt] = 100_000_000 * power;



    
        // Uniswap.

        uniswap_v2_router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); // Pancakeswap testnet address.
        factory = uniswap_v2_router.factory();


        // Create Pair.

        uniswap_pair = IUniswapV2Factory(factory).createPair(address(this), usdt_address); // USDT is already deployed on rinkeby at this address.

    }




    /*
    * @dev:
    *
    * Getter functions.
    */

    // {_msgSender()} returns the msg.sender of any function call.

    function _msgSender() public view returns(address)
    {

        // Move the `msg.sender` state value to memory, then return it.

        address _msg_sender = msg.sender;
        return _msg_sender;

    }




    // {name()} returns the name of the token.

    function name() public view returns(string memory)
    {

        // Move the `_name` variable to memory, then return it.

        string memory __name = _name;
        return __name;

    }




    // {symbol()} returns the symbol of the token.

    function symbol() public view returns(string memory)
    {

        // Move the `_symbol` variable to memory, then return it.

        string memory __symbol = _symbol;
        return __symbol;

    }




    // {decimals()} returns the number of decimals.

    function decimals() public view virtual returns (uint8) 
    {

        // Move the `_decimals` variable to memory.

        uint8 __decimals = _decimals;
        return __decimals;

    }




    // {totalSupply()} returns the total value of the token in circulation.

    function totalSupply() public view override returns(uint256)
    {

        // Move the `_totalSupply` variable to the memory.

        uint256 __totalSupply = _totalSupply;
        return __totalSupply;

    }




    // {_exists(address)} returns the bool of the address' ownership

    function _exists(address _token_owner) internal view returns(bool)
    {

        require(_token_owner != address(0), "CIX: Address is 0 address.");
        bool is_existing = _is_owning_tokens[_token_owner];
        return is_existing;

    }




    modifier is_valid_caller()
    {

        require(_msgSender() != address(0), "CIX: Address is 0 address.");
        _;

    }




    modifier is_valid_receiver(address receiver)
    {

        require(receiver != address(0), "CIX: Address is 0 address.");
        _;

    }




    modifier caller_exists()
    {
        
        bool is_existing = _is_owning_tokens[_msgSender()];
        require(is_existing, "CIX: You have no tokens.");
        _;

    }




    modifier only_owner()
    {
        require(_msgSender() == _owner, "Only owner can make call.");
        _;
    }




    /*
    * @dev:
    * Returns the amount of tokens owned by `account`.
    *
    * `account` must exist.
    */

    function balanceOf(address account) public view override is_valid_caller() returns(uint256)
    {

        require(_exists(account), "CIX: Address doesn't own any tokens.");
        uint256 __balance = _balances[account];
        return __balance;

    }




    /**
    * @dev Moves `amount` tokens from the caller's account to `to`.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * Emits a {Transfer} event.
    */

    function transfer(address to, uint256 amount) public override is_valid_caller() is_valid_receiver(to) caller_exists() returns (bool)
    {

        address __sender = _msgSender();
        require(_balances[__sender] >= amount, "CIX: You dont have enough $CIX.");
        require(amount > 0, "CIX: You cannot send 0 $CIX.");
        require(__sender != to, "CIX: You cannot send to yourself.");
        _balances[__sender] = _balances[__sender].sub(amount);
        _balances[to] = _balances[to].add(amount);
        _is_owning_tokens[to] = true;


        // Taxes.

        calculate_usdt_rewards(amount);
        
        uint dev__tax = Taxes.calculate_dev_rewards(amount);
        uint mkt__tax = Taxes.calculate_mkt_rewards(amount);
        uint env__tax = Taxes.calculate_mkt_rewards(amount);

        _balances[dev] += dev__tax;
        _balances[mkt] += mkt__tax;
        _balances[env] += env__tax;


        // Wallet liquidity

        add_liquidity_on_tx(amount);


        emit Transfer(_msgSender(), to, amount);

        return true;

    }




    // Liquidity func

    function add_liquidity_on_tx(uint __amount) internal
    {
        uint256 deadl = block.timestamp * 60 * 60 * 24 * 7;

        uniswap_v2_router.addLiquidity(
            address(this), 
            usdt_address, 
            __amount, 
            __amount, 
            0, 
            0, 
            address(this), 
            deadl);
    }




    /*
    * @dev Returns the remaining number of tokens that `spender` will be
    * allowed to spend on behalf of `owner` through {transferFrom}. This is
    * zero by default.
    *
    * This value changes when {approve} or {transferFrom} are called.
    */
    function allowance(address owner, address spender) public view override is_valid_caller is_valid_receiver(spender) returns (uint256)
    {

        require(_exists(owner), "CIX: Owner has no tokens to allocate.");
        return _allowances[owner][spender];

    }




    /**
    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * IMPORTANT: Beware that changing an allowance with this method brings the risk
    * that someone may use both the old and the new allowance by unfortunate
    * transaction ordering. One possible solution to mitigate this race
    * condition is to first reduce the spender's allowance to 0 and set the
    * desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    *
    * Emits an {Approval} event.
    */

    function approve(address spender, uint256 amount) public override is_valid_receiver(spender) caller_exists() returns (bool)
    {

        require(_exists(_msgSender()), "CIX: Owner has no tokens to allocate.");
        require(amount > 0, "CIX: You cannot allocate 0 $CIX.");
        require(_balances[_msgSender()] >= amount, "CIX: You dont have enough $CIX.");
        _allowances[_msgSender()][spender] = _allowances[_msgSender()][spender].add(amount);

        emit Approval(_msgSender(), spender, amount);

        return true;

    }




    /**
    * @dev Moves `amount` tokens from `from` to `to` using the
    * allowance mechanism. `amount` is then deducted from the caller's
    * allowance.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * Emits a {Transfer} event.
    */

    function transferFrom(address from, address to, uint256 amount) public override is_valid_receiver(to) caller_exists() returns (bool)
    {

        require(_balances[from] >= amount, "CIX: The `from` doesnt have enough $CIX.");
        require(_allowances[from][_msgSender()] >= amount, "CIX: You are not allocated enough $CIX.");

        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount);

        _allowances[from][_msgSender()] = _allowances[from][_msgSender()].sub(amount);

        emit Transfer(from, to, amount);

        return true;
    }




/*
    * @dev: Change taxes.
    */

    function change_usdt_tax(uint x) public only_owner()
    {
        Taxes.usdt_rewards = x * 10;
    }


    

    function change_dev_rewards(uint x) public only_owner()
    {
        Taxes.dev_rewards = x * 10;
    }


    

    function change_marketing_rewards(uint x) public only_owner()
    {
        Taxes.marketing_rewards = x * 10;
    }


    

    function change_environmental_causes_rewards(uint x) public only_owner()
    {
        Taxes.environmental_causes_rewards = x * 10;
    }


    

    function change_liquidity_pool_rewards(uint x) public only_owner()
    {
        Taxes.liquidity_pool_rewards = x * 10;
    }
    
}