// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

import "./Interfaces/IERC721.sol";
import "./Interfaces/SafeMath.sol";

/*
 * @title: DutchAuction Smart Contract [Modified].
 * @author: Anthony (fps) https://github.com/0xfps.
 * @dev: Reference [README.md].
 * @notice: Same as Auction [reference ./ Auction/Auction.sol] but with some differences.
*/
contract DutchAuction {
    // Use SafeMath for all uint256.
    using SafeMath for uint256;
    // Time of deployment.
    uint256 private deploy_time;
    // Time span of the contract, it reduces with time.
    uint256 private bid_time_span = 7 days;
    // Bool for still bidding.
    bool private still_bidding;
    // Depreciation interval, the time at which the price reduces.
    uint256 private interval_for_depreciation;
    // Time for last depreciation
    uint256 private last_depreciation;
    // Variable containing the price gone?
    uint256 private price_gone;
    // Bool to show that the bidding is locked.
    bool locked;
    // Nft address.
    IERC721 private nft;
    // Id of the nft to be sold.
    int256 private nft_id;
    // Starting bid for the nft.
    uint256 private starting_bid;
    // Seller of the nft, or whoever deploys the contract.
    address private seller;
    // The value of the depreciation.
    uint256 private depreciation;

    /*
    * @dev:
    *
    * Deploys the contract and sets the money used in the deployment as the base bidding price.
    *
    *
    * @param:
    *
    * address _nft_address -> Address of the nft to be deployed.
    * uint256 _nft_id -> Id of the nft you want to buy.
    */
    constructor(address _nft_address, uint256 _nft_id) payable {
        // Initialize the nft.
        nft = IERC721(_nft_address);
        // Set the nft id.
        nft_id = int(_nft_id);
        // Starting bid for the nft.
        starting_bid = msg.value;
        // Set the owner or seller of the nft.
        seller = msg.sender;
        // Depreciation value set [Reference line 47], the value is or 0.001 ether.
        depreciation = 1_000_000 gwei;
        // Set interval for depreciation
        // interval_for_depreciation = 1 days;
        interval_for_depreciation = 5 seconds;
        // Set the last depreciation to the current time so that subsequent depreciations can be calculated.
        last_depreciation = block.timestamp;
        // Deploy time.
        deploy_time = block.timestamp;
        // Still bidding boolean value.
        still_bidding = true;
    }

    receive() payable external {}
    fallback() payable external {}

    /* 
    * @dev:
    *
    * Validates that the address calling the function is a valid address and also not the seller.
    * Returns true if true, otherwise, false.
    */
    function checkAddress() private view returns(bool) {
        return (msg.sender != address(0)) && ((msg.sender != seller));
    }

    /*
    * @dev:
    *
    * This calculates and updates the new price of the item.
    */
    function getPrice() private returns(uint256) {
        // First, get the time that has passed since the last depreciation till the time that this function is called.
        uint256 time_gone = block.timestamp - last_depreciation;
        // Assuming time gone is 100 seconds, and interval for depreciation is 10 seconds.
        // If it depreciates at 0.001 ether every interval, then total price gone will be (0.001 ether * (100secs/10secs)).
        price_gone = depreciation * (time_gone / interval_for_depreciation);
        
        // If the price gone is for some reasons, greater than the starting bid, meaning that tha price has floored.
        if(price_gone >= starting_bid) {
            // Set starting bid to 0.
            starting_bid = 0;
        } else {
            // Try to remove the price gone from the starting bid.
            (, uint256 j) = starting_bid.trySub(price_gone);
            // Set the new starting bid.
            starting_bid = j;
        }
        
        // Reset last depreciation to the current time.
        last_depreciation = block.timestamp;
        // Return the price gone.
        return price_gone;
    }
    
    /*
    * @dev:
    *
    * Buy the nft.
    */
    function buy() public payable {
        // Makes sure that the bidding is still on,
        require(still_bidding, "Bid closed");
        // Get updated price.
        uint256 price = getPrice();
        // Makes sure address is legit.
        require(checkAddress(), "Bid cant be made by this address");
        // Make sure that ether sent is greater than listed price of nft.
        require(msg.value >= price, "Bid < Starting bid.");
        // Transfer NFT to new owner.
        nft.transferFrom(seller, msg.sender, uint(nft_id));
        // Calculate refunds.
        uint256 refund = msg.value - price;
        
        // If the refund is > 0.
        if(refund > 0) {
            // Refund the buyer.
            payable(msg.sender).transfer(refund);
        }
        
        // Reset nft address and destroy the nft id.
        nft_id = nft_id - (nft_id + 5);
    }
}
