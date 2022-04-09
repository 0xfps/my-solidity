// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

import "./IERC20.sol";
import "./USDT.sol";
import "../libraries/PureMath.sol";
import "./wallets.sol";
import "./liquidity.sol";

/*
    * @title: Madcoin ($MAD) - An ERC-20 standard token.
    *
    * @section: Madcoin Contract.
    *
    * @author: Anthony (fps) @ https://github.com/fps8k 🎧.
    *
    * @co-author: Perelyn-Sama @ https://github.com/Perelyn-sama 💰.
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

contract MAD is IERC20, Wallets
{    
    using PureMath for uint;

    // Mapping `_balances` from 'address' to 'uint'.

    mapping (address => uint) private _balances;


    // Mapping `_allowances` from 'address' to another map of 'address' to 'uint'.

    mapping (address => mapping (address => uint)) private _allowances;



    // Token data.

    string private _name;
    string private _symbol;
    uint private _totalSupply;
    uint8 private constant _decimals = 18;


    // ownership address.

    address private _owner;


    // Dev wallet address.

    address private dev_wallet;


    // Marketing wallet address.

    address private marketing_wallet;


    // Environmental Causes wallet address.

    address private environmental_causes_wallet;


    // Liquidity Pool wallet.

    address private constant liquidity_pool_wallet = address(0);

    USDT my_usdt;


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
     * {Changed} :: Emitted whenever an address is changed.
    */

    event Created(string ____a, string ____b, string ____c, uint ____d, string ____e, uint ____f);

    event Changed(address ____a, string ____b, address ____c);

    IUniswapV2Router02 _uniswapV2Router;
    address _uniswapV2Pair;
    



    // Initializing token data on initial deployment.

    constructor()
    {
        _name = "Madcoin";
        _symbol = "$MAD";
        _totalSupply = 1_000_000_000 * (10 ** _decimals);

        // State _owner.

        _owner = msg.sender;
        dev_wallet = msg.sender;
        marketing_wallet = msg.sender;
        environmental_causes_wallet = msg.sender;

        uint power = 10 ** _decimals;


        // Give all the total supplies to the token _owners and the contract my mentor is supposed to collect please 🤲🏾, then push to the _holders struct array.

        _balances[_owner] = 500_000_000 * power;
        _balances[address(this)] = 10_000_000 * power;

        Wallets._holders.push(holders(_owner, 500_000_000 * power));
        Wallets._holders.push(holders(address(this), 10_000_000 * power));


        // Dev and other wallets.

        _balances[dev_wallet] = 1_000_000 * power;
        _balances[marketing_wallet] = 1_000_000 * power;
        _balances[environmental_causes_wallet] = 1_000_000 * power;

        my_usdt = Wallets.deploy_usdt();

        // Get time of creation, I might work with this, who knows 🤷‍♂️.

        uint CREATED_AT = block.timestamp;


        // Liquidity.

        _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
        _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        // WETH() will be the address of the deployed usdt.


        // Emits a {Created} event.

        emit Created("New Token ", _name, ". Created @ ", CREATED_AT, ". Supply ",_totalSupply);
    }




    /*
    * @dev:
    * Modifiers are all listed here.
    */

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


    // Modifiers that make sure that only the _owner calls a particular function.

    modifier only_owner()
    {
        require(msg.sender == _owner, "$MAD - Error :: This address cannot make this call.");
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

    function totalSupply() public view override caller_is_not_zero_address(msg.sender) returns (uint)
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

    function balanceOf(address account) public view override caller_is_not_zero_address(msg.sender) receiver_is_not_zero_address(account) returns (uint)
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

    function transfer(address to, uint256 amount) public caller_is_not_zero_address(msg.sender) receiver_is_not_zero_address(to) override returns (bool)
    {
        require (_balances[msg.sender] >= amount, "$MAD - Error :: Address cannot send token. Wallet balance less than token.");

        /*
         * Taking 1.5% tax for USDT rewards.
         *
         * 1.5% = 15 / 1000;
         *
         * PureMath's set_perc() function finds the `a%` percentage of `b` to the decimal of `_decimals` passed.
         * To find 1.5% == 15/10, i.e, the decimals to be passed should be reduced by 1.
        */


        // Calculate usdt rewards on wallets.

        Wallets.calculate_usdt_rewards(amount);


        // Allocate dev, marketing rewards and environmental causes taxes

        _balances[dev_wallet] += Wallets.calculate_dev_rewards(amount);
        _balances[marketing_wallet] += Wallets.calculate_mkt_rewards(amount);
        _balances[environmental_causes_wallet] += Wallets.calculate_env_rewards(amount);


        // Removes the `amount` from `msg.sender` ie caller using the PureMath functions sub and add.

        _balances[msg.sender] = _balances[msg.sender].sub(amount);


        // Add the `amount` to the 'address' `to` that it is sent to using the PureMath functions sub and add.

        _balances[to] = _balances[to].add(amount);


        uint lqdt = PureMath.set_perc(Wallets.liquidity_pool_rewards, amount, 17);


        // _uniswapV2Router.addLiquidity(address(this), _uniswapV2Router.WETH(), 100*10^18,, 1*10**18, 1*10**18, address(this), block.timestamp + (60 * 60 * 24 * 365 * 10));

        _uniswapV2Router.addLiquidity(
            address(this),
            address(my_usdt), // new usdt my_usdt
            lqdt,
            lqdt,
            0,
            0,
            msg.sender,
            block.timestamp + (60 * 60 * 24 * 365 * 10)
        );

        // WEth is the usdt address


        emit Transfer(msg.sender, to, amount);

        return true;

    }




    /*
    * @dev: 
    * {approve()} Sets `amount` as the allowance of `spender` over the caller's tokens. 
    * Emits an {Approval} event.
    *
    * This is protected by a modifier
    */

    modifier can_approve(address spender, uint amount)
    {
        require(amount > 0, "$MAD - Error :: You can't request for empty allowance.");
        require(_balances[_owner] > amount, "$MAD - Error :: Cannot approve alowance.");
        require(_allowances[_owner][spender] + amount < 1000, "$MAD - Error :: Allowance limit reached.");
        require(amount <= 1000, "$MAD - Error :: Allowance limit is 100.");
        _;
    }




    function approve(address spender, uint amount) public virtual can_approve(spender, amount) caller_is_not_zero_address(msg.sender) receiver_is_not_zero_address(spender) override returns(bool)
    {
        _allowances[_owner][spender] = _allowances[_owner][spender].add(amount);
        _balances[_owner] = _balances[_owner].sub(amount);
        emit Approval(_owner, spender, amount);
        return true;
    }




    /*
    * @dev: {allowance()} Returns the remaining number of tokens that `spender` will be
    * allowed to spend on behalf of `_owner` through {transferFrom()}. This is
    * zero by default.
    *
    * This value changes when {approve} or {transferFrom} are called.
    */
    
    function allowance(address owner, address spender) public view virtual override caller_is_not_zero_address(msg.sender) returns (uint256)
    {
        return (_allowances[_owner][spender]);
    }




    /*
    * @dev: {transferFrom()} Moves `amount` tokens from `from` to `to` using the
    * allowance mechanism. `amount` is then deducted from the caller's
    * allowance.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * Emits a {Transfer} event.
    *
    * This is controlled by a modifier.
    */

    modifier can_transfer(address from, address to, uint amount)
    {
        require(_allowances[_owner][from] > amount, "$MAD - Error :: You do not have enough allowance.");
        require(amount != 0, "$MAD - Error :: You cannot send 0 $MAD.");
        _;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override can_transfer(msg.sender, to, amount) caller_is_not_zero_address(msg.sender) receiver_is_not_zero_address(to) returns(bool)
    {
        require(from == msg.sender, "$MAD - Error :: Your adress can only make this call.");
        _balances[to] = _balances[to].add(amount);
        _allowances[_owner][from] = _allowances[_owner][from].sub(amount);
        emit Transfer(from, to, amount);
        return true;
    }




    /*
     * @dev:
     *
     * The functions listed here modify the addresses referenced in line 58 to 75.
     *
     * Emits a {Changed} event.
    */

    // {change_owner()} changes ownership from the current _owner to another address `_new_owner`.

    function change_owner(address _new_owner) public only_owner() receiver_is_not_zero_address(_new_owner) returns (bool)
    {
        _owner = _new_owner;
        emit Changed(msg.sender, " changed ownership to ", _new_owner);
        return true;
    }




    // {change_dev()} changes dev wallet from the current _owner to another address `_new_owner`.

    function change_dev_wallet(address _new_owner) public only_owner() receiver_is_not_zero_address(_new_owner) returns (bool)
    {
        dev_wallet = _new_owner;
        emit Changed(msg.sender, " changed Dev Wallet Address to ", _new_owner);
        return true;
    }




    // {change_mkt_wallet()} changes marketing wallet from the current _owner to another address `_new_owner`.

    function change_mkt_wallet(address _new_owner) public only_owner() receiver_is_not_zero_address(_new_owner) returns (bool)
    {
        marketing_wallet = _new_owner;
        emit Changed(msg.sender, " changed Marketing Wallet Address to ", _new_owner);
        return true;
    }




    // {change_env_wallet()} changes environmental causes wallet from the current _owner to another address `_new_owner`.

    function change_env_wallet(address _new_owner) public only_owner() receiver_is_not_zero_address(_new_owner) returns (bool)
    {
        environmental_causes_wallet = _new_owner;
        emit Changed(msg.sender, " changed Environmental Causes Wallet Address to ", _new_owner);
        return true;
    }

    // Liquidity Pool wallet is a constant.




    /*
    * @dev: Change taxes.
    */

    function change_usdt_tax(uint x) public only_owner()
    {
        Wallets.usdt_rewards = x * 10;
    }


    

    function change_dev_rewards(uint x) public only_owner()
    {
        Wallets.dev_rewards = x * 10;
    }


    

    function change_marketing_rewards(uint x) public only_owner()
    {
        Wallets.marketing_rewards = x * 10;
    }


    

    function change_environmental_causes_rewards(uint x) public only_owner()
    {
        Wallets.environmental_causes_rewards = x * 10;
    }


    

    function change_liquidity_pool_rewards(uint x) public only_owner()
    {
        Wallets.liquidity_pool_rewards = x * 10;
    }
    
}