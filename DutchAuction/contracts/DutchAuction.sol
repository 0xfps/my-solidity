// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

import "./Interfaces/IERC721.sol";
import "./Interfaces/SafeMath.sol";

/*
 * @title: DutchAuction Smart Contract.
 * @author: Anthony (fps) https://github.com/fps8k .
 * @dev: Reference [README.md].
 * @notice: Same as Auction [reference ./ Auction/Auction.sol] but with some differences.
*/

contract DutchAuction
{
    using SafeMath for uint256;

    // Creating necessary state variables.
    // Time of deployment and time span of the bidding and the time of the last depreciation.

    uint256 private deploy_time;
    uint64 private bid_time_span = 7 days;
    bool private still_bidding;
    uint private interval_for_depreciation;
    uint private last_depreciation;
    uint private price_gone;
    bool locked;
    


    // NFT Details for constructor.

    IERC721 private nft;
    uint256 private nft_id;
    uint256 private starting_bid;
    address private seller;
    uint private depreciation;


    constructor(address _nft_address, uint256 _nft_id) payable
    {
        nft = IERC721(_nft_address);
        nft_id = _nft_id;
        starting_bid = msg.value;
        seller = msg.sender;
        depreciation = 1_000_000 gwei;
        // interval_for_depreciation = 1 days;
        last_depreciation = block.timestamp;

        deploy_time = block.timestamp;
        still_bidding = true;
    }

    fallback() payable external {}
    receive() payable external {}


    /* 
    * @dev:
    * {bid()} function allows the caller to make a fresh bid.
    *
    * Conditions:
    * - Caller cannot be a 0 address.
    * - Caller cannot be the `seller` of the token.
    * - `msg.value` must be greater than the `starting_bid`.
    * - It must be still the validity of the bid.
    * - `msg.value` sent for the bid, must be unique.
    *
    * - If the new bid is higher than the current highest bid, then, it replaces the value.
    */
    // 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 34

    function checkAddress() internal view returns(bool)
    {
        return (msg.sender != address(0)) && ((msg.sender != seller));
    }

    
    function getPrice() internal returns(uint256)
    {
        uint time_gone = block.timestamp - last_depreciation;

        price_gone = depreciation * (time_gone / interval_for_depreciation); // 10 gwei * (100secs/10secs)

        if(price_gone >= starting_bid)
        {
            starting_bid = 0;
        }
        else
        {
            starting_bid = starting_bid - price_gone;
        }

        last_depreciation = block.timestamp;
        
        return price_gone;
    }
    

    function buy() public payable
    {
        
        require(still_bidding, "Bid closed");

        uint price = getPrice(); // to renew prices;

        require(checkAddress(), "Bid cant be made by this address");
        require(msg.value >= price, "Bid < Starting bid.");

        nft.transferFrom(seller, msg.sender, nft_id);

        uint refund = msg.value - price;

        if(refund > 0)
        {
            payable(msg.sender).transfer(refund);
        }

        seller = address(0);
        nft_id = 0;
    }
}