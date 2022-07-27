// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

import "./Interfaces/IERC20.sol";
import "./Interfaces/PureMath.sol";


library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }
}


/*
 * @title: Crown Fund Smart Contract [Pledge code][Modified code].
 * @author: Anthony (fps) https://github.com/0xfps.
 * @dev: reference [README.md]
*/
contract CrowdFund {
    // Using SafeMath.
    using SafeMath for uint256;
    // Number of campaigns total.   
    uint256 campaign_count;
    
    // Campaing struct with data.
    struct Campaign {
        // Campaign creator.
        address creator;
        // Token used in the campaign.
        address campaign_token;
        // IERC20 implementation of the token.
        IERC20 token;
        // The target amount of the funding.
        uint256 target_amount;
        // The total amount funded so far.
        uint256 total_amount;
        // Boolean for campaign started.
        bool started;
        // Boolean for campaign ended.
        bool ended;
        // Boolean for campaign claimed.
        bool claimed;
    }
    
    // Mapping unique number to Campaigns.
    mapping(uint256 => Campaign) private campaign;
    // Mapping campaign number to a mapping of address to another number, that is a map of campaign id to address to amount donated.
    mapping(uint256 => mapping(address => uint256)) private donors;

    // Emitted when a new campaign is launched.
    event Launch(address, string, uint256);             // Address, launched, campaign_number.
    // Emitted when an address donates to a particular campaign.
    event Pledge(address, uint256, uint256);            // Address, campaign_number, amount.
    // Emitted when an address withdraws whatever they have donated to a particular campaign.
    event Withdraw(address, uint256, uint256);          // Address, campaign_number, amount.
    // Emitted whenever a campaign is ended.
    event End(address, string, uint256);                // Address, ended, campaign_number.
    // Emitted when the user claims his campaign funds.
    event Claim(address, address, uint256, uint256);    // Address, campaign_token, campaign_number, amount.

    /*
    * @dev:
    *
    * The user starts a new campaign with a particular token.
    * Only that token can be pledged to this campaign.
    *
    *
    * @param:
    *
    * address _token -> Token that the user wants to start the camnpaign with.
    * uint _target -> The fund goal that is to be met.
    * 0x1aE0EA34a72D944a8C7603FfB3eC30a6669E454C, 1000
    */
    function launch(address _token, uint _target) public {
        // Makes sure that the token sender is not a 0 address.
        require(msg.sender != address(0), "Not Address");
        // Makes sure that the target funding is not 0.
        require(_target > 0, "Target < 0");
        // Initialize a new token, so calling it can be easier from the struct itself.
        IERC20 new_campaign_token = IERC20(_token);
        // Increment the campaign count.
        campaign_count += 1;
        // Use the inceremented campaign count as new campaign id.
        campaign[campaign_count] = Campaign(
            msg.sender, _token, new_campaign_token, _target, 
            0, true, false, false
        );
        // Emit lauch event.
        emit Launch(msg.sender, " launched ", campaign_count);
    }

    /*
    * @dev:
    *
    * This function allows the caller to pledge some tokens to the campaign owner.
    * The tokens must be of the same type as the one used in the campaign creation.
    *
    *
    * @param:
    *
    * uint _campaign_number -> The campaign number the caller wants to donate to.
    * uint256 _amount -> The amount of tokens the caller wants to send.
    */
    function pledge(uint _campaign_number, uint256 _amount) public {
        // Get campaign into the storage, so I can work on it.
        Campaign storage this_campaign = campaign[_campaign_number];
        // Require that the msg.sender is not a 0 address.
        require(msg.sender != address(0), "Not Address");
        // Require that the campaign in question has already started.
        require(this_campaign.started, "Not Started");
        // Require that this campaign has not ended.
        require(!this_campaign.ended, "Ended");
        // Require that the amount to be sent is > 0
        require(_amount > 0, "Amount < 0");
        // Transfer the tokens to the contract.
        // The caller must have approved this contract to spend some of caller's tokens.
        this_campaign.token.transferFrom(msg.sender, address(this), _amount);
        // Increment the total amount seen by this campaign and assign it to a random variable.
        (, uint256 j) = this_campaign.total_amount.tryAdd(_amount);
        // Update the total amount of the campaign.
        this_campaign.total_amount = j;
        // Record the donor to this campaign.
        donors[_campaign_number][msg.sender] += _amount;
        // Emit the Pledge event.
        emit Pledge(msg.sender, _campaign_number, _amount);
    }

    /*
    * @dev:
    *
    * This allows any donor to take back the funds he has transferred to the contract, as long as the campaign has not ended.
    *
    *
    * @param:
    *
    * uint _campaign_number -> The campaign id of the campaign you pledged or donated to.
    */    
    function withdraw(uint _campaign_number) public {
        // Get the campaign id.
        Campaign storage this_campaign = campaign[_campaign_number];
        // Validates that the caller is no a zero address.
        require(msg.sender != address(0), "Not Address");
        // Makes sure that the current campaign hasn't ended yet.
        require(!this_campaign.ended, "Ended");
        // Makes sure that the caller acually donated to that campaign.
        require(donors[_campaign_number][msg.sender] > 0, "Did not pledge.");
        // Gets the amount that the caller pledged to the campaign.
        uint256 _pledge = donors[_campaign_number][msg.sender];
        // Remove the amount from the total amount of the campaign.
        (, uint j) = campaign[_campaign_number].total_amount.trySub(_pledge);
        // Update the total amount of the campaign.
        campaign[_campaign_number].total_amount = j;
        // Reset the amount pledged to the campaign to 0.
        donors[_campaign_number][msg.sender] = 0;
        // Transfer tokens held by this contract to the pledger who is the caller.
        this_campaign.token.transfer(msg.sender, _pledge);
        // Emit the withdraw event.
        emit Withdraw(msg.sender, _campaign_number, _pledge);
    }

    /*
    * @dev:
    *
    * Ends the campaign for that particular token.
    * Only the campaign creator can call this function.
    *
    *
    * @param:
    *
    * uint _campaign_number -> The campaign id of the campaign to be ended.
    */    
    function end(uint _campaign_number) public {
        // Makes sure that the caller is not a 0 address.
        require(msg.sender != address(0), "Not Address");
        // Makes sure that the campaign has started.
        require(campaign[_campaign_number].started, "Not started");
        // Ensures that the caller is the creator of the campaign.
        require(msg.sender == campaign[_campaign_number].creator, "Not Creator");
        // Makes sure that the campaign hasn't ended already.
        require(!campaign[_campaign_number].ended, "Ended.");
        // Ends the campaign by setting the ended to true.
        campaign[_campaign_number].ended = true;
        // Emit the End event.
        emit End(msg.sender, " ended ", _campaign_number);
    }

    /*
    * @dev:
    *
    * The campaign owner can then call this function when the campaign has ended to claim the pledged tokens.
    *
    *
    * @param:
    *
    * uint _campaign_number -> The campaign id of the campaign to be ended.
    */    
    function claim(uint256 _campaign_number) public {
        // Makes sure that the caller is not a 0 address.
        require(msg.sender != address(0), "Not address");
        // Ensures that the caller is the creator of the campaign.
        require(msg.sender == campaign[_campaign_number].creator, "Not creator");
        // Makes sure that the campaign has not been claimed.
        require(!campaign[_campaign_number].claimed, "Claimed");
        // Makes sure that the campaign has ended.
        require(campaign[_campaign_number].ended, "Not ended.");
        // require(campaign[_campaign_number].total_amount >= campaign[_campaign_number].target_amount, "Not up to target, refund the funders.");
        // Transfer the total amount in the campaign id from the contract to the campaign creator.
        campaign[_campaign_number].token.transfer(msg.sender, campaign[_campaign_number].total_amount);
        // Set claimed to true, so he wont claim again.
        campaign[_campaign_number].claimed = true;
        // Set campaign total amount to 0.
        campaign[_campaign_number].total_amount = 0;
        // Emit Claim event.
        emit Claim(msg.sender, campaign[_campaign_number].campaign_token, _campaign_number, campaign[_campaign_number].total_amount);
    }
}
