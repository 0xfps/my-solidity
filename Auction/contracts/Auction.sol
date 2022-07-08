// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

import "./Interfaces/IERC721.sol";

/*
 * @title: Auction Smart Contract [Modified, what you'd see on Rinkeby is an old version of this contract].
 * @author: Anthony (fps) https://github.com/fps8k.
 * @dev: Reference [README.md].
*/

contract MyAuction {

    // Time of deployment and time span of the bidding.
    uint256 private deploy_time;
    // Time span of the bid.
    uint64 private bid_time_span = 7 days;
    // Bool to check if the bidding is still going on.
    bool private still_bidding;
    // Boolean to check for re-entrancy.
    bool locked;
    // Highest bidder price.
    uint256 private highest_bid;
    // Mapping amount bidded to address. No two bidders can have the same bid.
    mapping(uint256 => address) private price_to_bidder;
    // So a bidder can't bid twice.
    mapping(address => uint256) private bidder_to_price;
    // Array of bidders.
    address[] private bidders;
    // NFT Details for constructor.
    IERC721 private nft;
    // NFT id that the deployer wants to auction.
    uint256 private nft_id;
    // Starting bid.
    uint256 private starting_bid;
    // Address of the seller.
    address private seller;

    /*
    * @dev:
    *
    * Deployed with an nft address and the id of the nft you want to auction.
    * The contract must be approved by the nft owner to handle the sale of the nft.
    * Amount paid to deploy the contract is the starting bid, no matter how small, I think I was following some rules, I don't remember.
    * 
    *
    * @param:
    * 
    * address _nft_address -> Address of the nft contract holding your nft token.
    * uint256 _nft_id -> Id of the nft you want to auction.
    */
    constructor(address _nft_address, uint256 _nft_id) payable {
        // Initialize nft address.
        nft = IERC721(_nft_address);
        // Get the nft id.
        nft_id = _nft_id;
        // The eth value used to deploy the contract is the starting bid.
        starting_bid = msg.value;
        // The seller is the person who has deployed the contract.
        seller = msg.sender;
        // Time of deployment.
        deploy_time = block.timestamp;
        // Set the bidding to be still ongoing.
        still_bidding = true;
    }
    
    receive() payable external {}
    fallback() payable external {}
    
    /*
    * @dev:
    * 
    * This function returns the sender of the message.
    * For some reasons, I was taught that moving the state variables to memory would save gas.
    * Hence the need for this function in this contract was born.
    * Also, throughout this contract, I have pushed a lot of variables from storage to memory, so pardon, there are a lot of them.
    */
    function getMessageSender() private view returns(address) {
        // Push state msg.sender to memory variable.
        address _msg_sender = msg.sender;
        // Return memory variable.
        return _msg_sender;
    }
    
    /*
    * @dev:
    *
    * This modifier validates that the EOA or person who has called a function is actually a valid address.
    */
    modifier isValidCaller() {
        // Validate that the address returned by the function on line 91 is not a 0 address.
        require(getMessageSender() != address(0), "Invalid calling address.");
        _;
    }

    // Protects from re-entrancy hack.
    modifier noReEntrance() {
        // Makes sure the current bool is false.
        require(!locked, "No re-entrancy");
        // Sets it to true and locks it.
        locked = true;
        // Execute code.
        _;
        // Unlocks it again to be called.
        locked = false;
    }

    /*
    * @dev:
    *
    * Since the time limit of every bid is 7 days, this function checks if the time is over and sets the still_bidding variable to false.
    * This stops any new bids.
    */
    modifier withinTime() {
        // Get the current time.
        uint256 time_now = block.timestamp;
        // Get the time of deploy.
        uint256 _deploy_time = deploy_time;
        // Get the time span of the bid.
        uint256 _bid_time_span = bid_time_span;
        // The expiration date of the contract.
        uint256 expiration_date = _deploy_time + _bid_time_span;

        /*
        * @dev:
        *
        * Basic simple math here.
        * If the time now is >= (the time the contract was deployed + the time span of the bid).
        * i.e The contract is older than the time span.
        * Set the contract still bidding value to false.
        */
        if (time_now >= expiration_date) {
            // Set still bidding to false.
            still_bidding = false;
        }

        // Makes sure that the time now is less than when the contract will expire.
        require(time_now < expiration_date, "Auction expired.");
        // Execute code.
        _;
    }
   
    //  Returns the highest bid submitted for the auction.
    function getHighestBid() private view returns(uint256) {
        // Move highest bid from state to memory.
        uint256 _highest_bid = highest_bid;
        // Return memory variable.
        return _highest_bid;
    }

    /*
    * @dev:
    *
    * Checks to make sure that the price is unique and no two persons can bid the same amount.
    *
    *
    * @param:
    * price -> user's bid.
    */
    function isUniquePrice(uint256 price) private view returns(bool is_unique_price) {
        // Returns true if the address mapped to the price in the price to bidder is a 0 address, otherwise, return false.
        is_unique_price = ( price_to_bidder[price] == address(0) );
        // Return value.
        return is_unique_price;
    }

    // Prevents the user from bidding twice.
    function hasMadeABid() private view returns (bool) {
        // Returns true if the amount mapped to the address is != 0.
        bool has_made_bid = bidder_to_price[getMessageSender()] != 0;
        // Return value.
        return has_made_bid;
    }

    /* 
    * @dev:
    *
    * {bid()} function allows the caller to make a fresh bid.
    *
    * Conditions:
    * - Caller cannot be a 0 address.
    * - Caller cannot be the `seller` of the token.
    * - `msg.value` must be greater than the `starting_bid`.
    * - It must still be within time of bid.
    * - It must be still the validity of the bid.
    * - `msg.value` sent for the bid, must be unique.
    *
    * - If the new bid is higher than the current highest bid, then, it replaces the value.
    */
    function bid() public payable isValidCaller withinTime {
        // Push the seller address to memory.
        address _seller = seller;
        // Push the starting bid value to memory.
        uint256 _starting_bid = starting_bid;
        // Require that the bidding is still going on.
        require(still_bidding, "Auction expired.");
        // If the bidder is the seller, he cannot bid his own nft.
        require(getMessageSender() != _seller, "You can't bid your nft.");
        // If the ether bid is less than the starting bid, revert, it must be >= the starting bid.
        require(msg.value >= _starting_bid, "Price lower than minimum bid.");
        // Push the msg.sender to value.
        uint256 bid_price = msg.value;
        // Check if anyone has made a bid with that price before.
        require(isUniquePrice(bid_price), "Bid taken, make a unique bid.");

        // If the bid the caller makes is greater than the current highest bid, then it shall take it's place as the highest bid.
        if (bid_price > getHighestBid()) {
            // Set new highest bid.
            highest_bid = bid_price;
        }

        // Map the current bid value to the address of the bidder.
        price_to_bidder[bid_price] = getMessageSender();
        // Map the address of the current bidder to the price he has bid.
        bidder_to_price[getMessageSender()] = bid_price;
    }

    /* 
    * @dev:
    *
    * {withdraw()} function allows anyone who is not the highest bidder to withdraw his funds.
    *
    * Conditions:
    * - Caller cannot be a 0 address.
    * - Caller cannot be the `seller` of the token.
    * - Caller cannot be the highest bidder.
    *
    * - After paying, deletes the relevant records for the caller.
    */
    function withdraw() public payable isValidCaller noReEntrance {
        // Push seller address to memory.
        address _seller = seller;
        // Require that the address calling is not the seller of the nft.
        require(getMessageSender() != _seller, "You can't withdraw or bid your nft.");
        // Require that the address calling has made a bid.
        require(hasMadeABid(), "You have not made a bid.");
        // If the withdrawer is the highest bidder, revert, you cannot withdraw. It is the law.
        require(price_to_bidder[getHighestBid()] != getMessageSender(), "You are the highest bidder, you cannot withdraw.");
        // Move the caller address to memory.
        address payto_address = getMessageSender();
        // Fetch the amount that that caller address bid.
        uint256 _bid_return_price = bidder_to_price[payto_address];
        // Transfer it to the caller.
        payable(payto_address).transfer(_bid_return_price);
        // Delete the mapping of the caller to his price.
        delete bidder_to_price[getMessageSender()];
        // Delete the mapping of the price to the caller.
        delete price_to_bidder[_bid_return_price];
    }

    /* 
    * @dev:
    *
    * {end()} function allows the seller to end the auction and send the nft to the highest bidder.
    *
    * Conditions:
    * - Caller cannot be a 0 address.
    * - Caller must be the `seller` of the token.
    * - Highest bid cannot be 0.
    *
    * - It sets `still_bidding` to false, stopping any new bids.
    */
    function end() public payable isValidCaller noReEntrance {
        // Get the seller of the nft and move to memory.
        address _seller = seller;
        // Require that the caller is the seller.
        require(getMessageSender() == _seller, "You cannot call this function.");
        // Move the highest bid to memory.
        uint256 __highest_bid = getHighestBid();
        // Makes sure that the highest bid is > 0.
        require(__highest_bid > 0, "No one bid your nft.");
        // Get the address that the highest bid is mapped to.
        address _winner = price_to_bidder[__highest_bid];
        // Transfer the nft to the highest bidder.
        nft.safeTransferFrom(_seller, _winner, nft_id);
        // Send the owner the highest bid.
        payable(seller).transfer(__highest_bid);
        // Delete the entry of the highest bidder and his highest bid, so that payback won't pay him.
        delete bidder_to_price[_winner];
        // Delete the entry of the highest price.
        delete price_to_bidder[__highest_bid];
        
        // Payback the other bidders.
        for (uint i = 0; i < bidders.length; i++) {
            // Move the address in the array to memory.
            address to = bidders[i];
            // Pay.
            payback(to);
        }
        
        // Close the biding.
        still_bidding = false;
    }

    /*
    * @dev:
    *
    * Pays back any bidder.
    */
    function payback(address _a) private noReEntrance {
        // Get the bid of the address passed.
        uint this_bid = bidder_to_price[_a];
        
        // If the bid is > 0, then payback.
        if (this_bid > 0) {
            // Pay.
            payable(_a).transfer(this_bid);
        }
    }   
}
