// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

import "./USDT.sol";
import "../libraries/PureMath.sol";
import "./liquidity.sol";


/*
    * @title: Madcoin ($MAD) - An ERC-20 standard token.
    *
    * @section: Madcoin Transaction and Taxes.
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

contract Wallets
{

    using PureMath for uint;


    USDT f = USDT(address(0xd7Ca4e99F7C171B9ea2De80d3363c47009afaC5F));


    // Struct array of all token holders and how much they own.

    struct holders
    {
        address _holder;
        uint _amount;
    }

    holders[] _holders;




    // Struct array of all token holders' rewards.

    struct USDT_rewards
    {
        address _holder;
        uint _reward;
    }

    USDT_rewards[] _benefactors;


    // Mapping holders to usdt.

    mapping (address => uint) _dividends;




    // All taxes.

    uint usdt_rewards = 1.5 * 10;
    
    uint dev_rewards = 1.5 * 10;

    uint marketing_rewards = 1.5 * 10;

    uint environmental_causes_rewards = 1.5 * 10;

    uint liquidity_pool_rewards = 1 * 10;

    uint __decimals = 17;                     // This is set to 17, reference PureMath.sol set_perc() function.


    /*
    * @dev:
    *
    * {calculate_usdt_rewards()} calculates the usdt rewards and allocates it to every person on the `_holders` array.
    *
    */

    function calculate_usdt_rewards(uint amount) internal
    {

        // Tax

        uint usdt_tax = PureMath.set_perc(usdt_rewards, amount, 17);    // This is set to 17, reference PureMath.sol set_perc() will return 18 dp.


        // Loops through the holders and their rewards and stores an additional tax for them.

        for (uint i = 0; i < _holders.length; i ++)
        {
            _benefactors[i]._reward += usdt_tax;
        }
    }




    /*
    * @dev:
    *
    * {calculate_dev_rewards()}, {calculate_mkt_rewards()} and {calculate_env_rewards()} calculates the required rewards and returns the value.
    *
    */

    function calculate_dev_rewards(uint amount) internal view returns(uint)
    {

        // Dev rewards.

        uint dev_tax = PureMath.set_perc(dev_rewards, amount, 17);      // This is set to 17, reference PureMath.sol set_perc() will return 18 dp.
        return dev_tax;
    }




    function calculate_mkt_rewards(uint amount) internal view returns(uint)
    {

        // Marketing rewards.

        uint mkt_tax = PureMath.set_perc(marketing_rewards, amount, 17);      // This is set to 17, reference PureMath.sol set_perc() will return 18 dp.
        return mkt_tax;
    }




    function calculate_env_rewards(uint amount) internal view returns(uint)
    {
        // Environmental causes rewards.

        uint env_tax = PureMath.set_perc(environmental_causes_rewards, amount, 17);      // This is set to 17, reference PureMath.sol set_perc() will return 18 dp.
        return env_tax;
    }




    /*
    * @dev:
    * Withdrawals. HELP ME 🥺 🥺 🥺.
    */

    function withdraw_usdt(uint amount) public
    {
        require(msg.sender != address(0), "$MAD - Error :: Caller address is a 0 address, try passing a valid address.");
        
        require (_dividends[msg.sender] >= amount, "$MAD - Error :: Cannot withdraw this amount of dividends.");

        f.transfer(msg.sender, amount);
        _dividends[msg.sender] = _dividends[msg.sender].sub(amount);
    }
}