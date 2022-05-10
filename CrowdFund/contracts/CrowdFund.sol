// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

import "./Interfaces/IERC20.sol";
import "./Interfaces/PureMath.sol";

/*
 * @title: Crown Fund Smart Contract [Pledge code].
 * @author: Anthony (fps) https://github.com/fps8k .
 * @dev: reference [README.md]
*/

contract CrowdFund
{
    
    // Number of campaigns total;
    
    uint256 campaign_count;


    // Campaing struct with data.

    struct Campaign
    {
        address creator;
        address campaign_token;
        IERC20 token;
        uint256 target_amount;
        uint256 total_amount;

        bool started;
        bool ended;
        bool claimed;
    }

    
    // Mapping id to campaign and id to address that donated what amount to the campaign id.

    mapping(uint256 => Campaign) private campaign;
    mapping(uint256 => mapping(address => uint256)) private donors;



    // Events.

    event Launch(address, string, uint256);             // Address, launched, campaign_number.
    event Pledge(address, uint256, uint256);            // Address, campaign_number, amount.
    event Withdraw(address, uint256, uint256);          // Address, campaign_number, amount.
    event End(address, string, uint256);                // Address, ended, campaign_number.
    event Claim(address, address, uint256, uint256);    // Address, campaign_token, campaign_number, amount.




    // Starts a new campaign for that token.
    // 0x1aE0EA34a72D944a8C7603FfB3eC30a6669E454C, 1000

    function launch(address _token, uint _target) public
    {
        require(msg.sender != address(0), "Not Address");
        require(_target > 0, "Target < 0");

        IERC20 new_campaign_token = IERC20(_token);

        campaign_count += 1;

        campaign[campaign_count] = Campaign(
            msg.sender, 
            _token, 
            new_campaign_token, 
            _target, 
            0,
            true,
            false, 
            false
        );

        emit Launch(msg.sender, " launched ", campaign_count);
    }




    // Pledge

    function pledge(uint _campaign_number, uint256 _amount) public
    {
        Campaign storage this_campaign = campaign[_campaign_number];

        require(msg.sender != address(0), "Not Address");                         // Not zero address.
        require(this_campaign.started, "Not Started");                                           // The campaign has started.
        require(!this_campaign.ended, "Ended");                                 // The campaign has not ended.
        require(_amount > 0, "Amount < 0");                                     // Amount is > 0.

        
        this_campaign.token.transferFrom(msg.sender, address(this), _amount);
        this_campaign.total_amount += _amount;

        donors[_campaign_number][msg.sender] += _amount;

        emit Pledge(msg.sender, _campaign_number, _amount);
    }




    // Withdraw
    
    function withdraw(uint _campaign_number) public
    {
        Campaign storage this_campaign = campaign[_campaign_number];
        
        // Check:
        require(msg.sender != address(0), "Not Address");
        require(!this_campaign.ended, "Ended");
        require(donors[_campaign_number][msg.sender] > 0, "Did not pledge.");

        uint256 _pledge = donors[_campaign_number][msg.sender];

        campaign[_campaign_number].total_amount -= _pledge;
        donors[_campaign_number][msg.sender] = 0;

        this_campaign.token.transfer(msg.sender, _pledge);

        emit Withdraw(msg.sender, _campaign_number, _pledge);
    }




    // End a campaign.
    
    function end(uint _campaign_number) public
    {
        require(msg.sender != address(0), "Not Address");
        require(campaign[_campaign_number].started, "Not started");
        require(msg.sender == campaign[_campaign_number].creator, "Not Creator");

        campaign[_campaign_number].ended = true;

        emit End(msg.sender, " ended ", _campaign_number);
    }




    // Claim

    function claim(uint256 _campaign_number) public
    {
        require(msg.sender != address(0), "Not address");
        require(msg.sender == campaign[_campaign_number].creator, "Not creator");
        require(!campaign[_campaign_number].claimed, "Claimed");
        require(campaign[_campaign_number].ended, "Not ended.");
        // require(campaign[_campaign_number].total_amount >= campaign[_campaign_number].target_amount, "Not up to target, refund the funders.");

        campaign[_campaign_number].token.transfer(msg.sender, campaign[_campaign_number].total_amount);

        campaign[_campaign_number].claimed = true;

        emit Claim(msg.sender, campaign[_campaign_number].campaign_token, _campaign_number, campaign[_campaign_number].total_amount);
    }
}