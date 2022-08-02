// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

import "./Interfaces/IERC20.sol";
import "./Libraries/PureMath.sol";

/*
 * @title: Aguia 2.0 ($AGU) An re-write of the ERC-20 token, $AGU ref[https://github.com/fps8k/my-solidity/tree/Aguia-2.0/erc20%20-%20%24AGU].
 * @author: Anthony (fps) https://github.com/0xfps.
 * @dev: 
*/
contract Aguia is IERC20 {
    using PureMath for uint256;
    // Token data.
    string private _name;                                                               // Aguia 2.
    string private _symbol;                                                             // $AGU.
    uint256 private _totalSupply;                                                       // 1_000_000.
    uint8 private _decimals;                                                            // 18.
    // Owner address and a mapping of owners that can perform actions with the token.
    address private _owner = 0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593;            	  // My Ethereum wallet address for production.
    // address private _owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;               // My Fake Remix wallet address for development.
    mapping(address => bool) private _approved_owners;
    // Token holders and allowances.
    mapping(address => uint256) private _balances;                                       // Change to private on production.
    mapping(address => mapping(address => uint256)) private _allowances;
    
    // Events
    event Create(address, uint256, string, uint256);                                    // Address, time, name, supply.
    event Mint(address, uint256, uint256);                                              // Address, time, supply.
    event Burn(address, uint256, uint256);                                              // Address, time, supply.
    event Change(address, uint256, address);                                            // Old address, time, new address.

    // Constructor
    constructor() {
        _name = "Aguia 2.0";
        _symbol = "$AGU";
        _decimals = 18;
        _totalSupply = 1000000000 * (10 ** _decimals);
        // Give the owner all the token.
        _balances[_owner] = _totalSupply;
        _approved_owners[_owner] = true;
        emit Create(_owner, block.timestamp, _name, _totalSupply);
    }

    function name() public view returns (string memory __name) {
        __name = _name;
    }

    function symbol() public view returns(string memory __symbol) {
        __symbol = _symbol;
    }

    function decimals() public view returns(uint8 __decimals) {
        __decimals = _decimals;
    }

    function totalSupply() public view override returns(uint256 __totalSupply) {
        __totalSupply = _totalSupply;
    }

    function exists(address _account) private view returns(bool) {
        return _approved_owners[_account];
    }

    /*
    * @dev Returns the amount of tokens owned by `account`.
    */
    function balanceOf(address account) public view override returns(uint256) {
        // require(msg.sender != address(0), "!Address");
        require(exists(account), "Account !Exists");
        uint256 _balance_of = _balances[account];
        return _balance_of;
    }

    function isOneOfTheTwo(address __owner, address __spender) private view returns(bool) {
        return((msg.sender == __owner) || msg.sender == __spender);
    }

    /**
    * @dev Moves `amount` tokens from the caller's account to `to`.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * Emits a {Transfer} event.
    */
    function transfer(address to, uint256 amount) public override returns(bool) {
        require(msg.sender != address(0), "!Address");                              // Sender's address is not 0 address.
        require(exists(msg.sender), "Account !Exists");                             // Sender exists in the records, even if he has 0 tokens.
        require(to != address(0), "Receiver !Address");                             // Receiver isn't 0 address.
        require(amount > 0, "Amount == 0");                                         // Can't send empty token.
        require(_balances[msg.sender] >= amount, "Wallet funds < amount");          // Sender has more than he can send.
        _balances[msg.sender] = _balances[msg.sender].sub(amount);                  // Subtract from sender.
        _balances[to] = _balances[to].add(amount);                                  // Add to receiver.
        _approved_owners[to] = true;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    /**
    * @dev Returns the remaining number of tokens that `spender` will be
    * allowed to spend on behalf of `owner` through {transferFrom}. This is
    * zero by default.
    *
    * This value changes when {approve} or {transferFrom} are called.
    */
    function allowance(address owner, address spender) public view override returns(uint256) {
        require(msg.sender != address(0), "!Address");
        require(owner != address(0), "!Owner");
        require(spender != address(0), "!Spender");
        require(exists(owner), "!Owner");
        require(exists(spender), "!Spender");
        require(isOneOfTheTwo(owner, spender), "!Owner && !Spender)");
        uint256 _allowance = _allowances[owner][spender];
        return _allowance;
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
    function approve(address spender, uint256 amount) public override returns(bool) {
        // msg.sender == the address of the caller.
        require(msg.sender != address(0), "!Address");
        require(spender != address(0), "!Spender");
        require(exists(msg.sender), "!Account Exists");
        require(msg.sender != spender, "Caller == Spender");
        require(_balances[msg.sender] >= amount, "Balance < Amount");
        _allowances[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
    * @dev Moves `amount` tokens from `from` to `to` using the
    * allowance mechanism. `amount` is then deducted from the caller's
    * allowance.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * The person calling transferFrom doesn't need to own tokens.
    *
    * Emits a {Transfer} event.
    */
    function transferFrom(address from, address to, uint256 amount) public override returns(bool) {
        require(msg.sender != address(0), "!Address");
        require(from != address(0), "!From");
        require(to != address(0), "!To");
        require(exists(from), "From !Exists");
        require(exists(to), "To !Exists");
        require(_allowances[from][msg.sender] >= amount, "Balance < Amount");
        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount);
        _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(amount);
        emit Transfer(from, to, amount);
        return true;
    }

    /*
    * @dev: {mint()} adds more tokens to the `_totalSupply`.
    */
    function mint(uint256 amount) public {
        require(msg.sender == _owner, "!Owner");
        uint256 _supply = amount * (10 ** _decimals);
        _totalSupply = _totalSupply.add(_supply);
        emit Mint(msg.sender, block.timestamp, _supply);
    }
    
    /*
    * @dev: burn() removes from the token
    */
    function burn(uint256 amount) public {
        require(msg.sender == _owner, "!Owner");
        uint256 _supply = amount * (10 ** _decimals);
        _totalSupply = _totalSupply.sub(_supply);
        emit Burn(msg.sender, block.timestamp, _supply);
    }

    /*
    * @dev: {changeOwner()} changes owner of token
    */
    function changeOwner(address new_owner) public {
        require(msg.sender == _owner, "!Owner");
        require(new_owner != _owner, "New Owner == Old owner");
        _owner = new_owner;
        emit Change(msg.sender, block.timestamp, new_owner);
    }
}
