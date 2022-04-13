// SPDX-License-Identifier: MIT

pragma solidity >0.6.0;

import "./interfaces/IERC721.sol";
import "./interfaces/IERC165.sol";
import "./interfaces/IERC721Receiver.sol";
import "./utils/String.sol";

abstract contract Legio is IERC165, IERC721, IERC721Receiver
{
    using Strings for uint256;

    // Mapping the token ids to their owners.

    mapping(uint256 => address) private _owners;


    // Mapping the addresses to the number of tokens they own.

    mapping(address => uint256) private _balances;

    
    // Token to approved address to manage.

    mapping(uint256 => address) private _token_approvals;
    

    // Owner => (Operator => Bool).

    mapping(address => mapping(address => bool)) private _operator_approvals;


    string private _name;
    string private _symbol;
    address private _owner;


    constructor()
    {
        _name = "Legio";
        _symbol = "LEGIO";
        _owner = 0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593;
    }




    // Function for name return.

    function name() public view returns(string memory)
    {
        return _name;
    }



    // Function for symbol return.

    function symbol() public view returns(string memory)
    {
        return _symbol;
    }




    // Return sender.

    function _msgSender() internal view returns(address)
    {
        return msg.sender;
    }




    // This function checks if a token exists and returns true.

    function token_exists(uint256 __tokenId) internal view returns(bool)
    {
        return _owners[__tokenId] != address(0);
    }




    // Function to check the approval of `msg.sender` over `__tokenId` returns bool.
    // Function to check if the __operator is generally approved to manage __caller's tokens.

    function is_approved_person(uint256 __tokenId, address __operator) internal view returns(bool)
    {
        return (_token_approvals[__tokenId] == __operator);
    }

    function is_generally_approved(address __caller, address __operator) internal view returns(bool)
    {
        return (_operator_approvals[__caller][__operator]);
    }




    /*
    * @dev:
    *
    * {balalnceOf()} returns the number of tokens owned by `address`.
    *
    * REQUIREMENTS:
    * Address `address` is not a 0 address.
    */

    modifier is_valid_address(address _test)
    {
        require(_test != address(0), "Address invalid.");
        _;
    }




    function balanceOf(address owner) public view override is_valid_address(owner) returns(uint256)
    {
        return _balances[owner];
    }




    /*
    * @dev:
    *
    * {ownerOf()} returns the owner of `tokenId`.
    *
    */

    function ownerOf(uint256 tokenId) public view override is_valid_address(msg.sender) returns(address)
    {
        address token_owner = _owners[tokenId];
        require(token_owner != address(0), "Token is not owned.");
        return token_owner;
    }




    /**
    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
    *
    * Requirements:
    *
    * - `from` cannot be the zero address.
    * - `to` cannot be the zero address.
    * - `tokenId` token must exist and be owned by `from`.
    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
    *
    * Emits a {Transfer} event.
    */

    function safeTransferFrom(address from, address to, uint256 tokenId) public override is_valid_address(msg.sender) is_valid_address(from) is_valid_address(to)
    {
        require(token_exists(tokenId), "Non-existent token.");
        require((_msgSender() == from) || is_approved_person(tokenId, _msgSender()) || is_generally_approved(from, _msgSender()), "You cannot manage this token.");

        _owners[tokenId] = to;
        _balances[from] -= 1;
        _balances[to] += 1;
        _token_approvals[tokenId] = to;

        _checkOnERC721Received(from, to, tokenId, "");

        emit Transfer(from, to, tokenId);
    }




    /**
    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
    * The approval is cleared when the token is transferred.
    *
    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
    *
    * Requirements:
    *
    * - The caller must own the token or be an approved operator.
    * - `tokenId` must exist.
    *
    * Emits an {Approval} event.
    */

    function approve(address to, uint256 tokenId) public override is_valid_address(msg.sender) is_valid_address(to)
    {
        require(token_exists(tokenId), "Non-existent token.");
        require(_owners[tokenId] == _msgSender(), "You do not own this token.");
        require(_token_approvals[tokenId] == address(0), "You have assigned this token. Disprove it first.");

        _token_approvals[tokenId] = to;
        emit Approval(_msgSender(), to, tokenId);
    }




    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
    */

    function setApprovalForAll(address operator, bool _approved) public override is_valid_address(msg.sender) is_valid_address(operator)
    {
        require(operator != _msgSender(), "You cannot approve yourself.");

        _operator_approvals[_msgSender()][operator] = _approved;

        emit ApprovalForAll(_msgSender(), operator, _approved);
    }




    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
    */

    function getApproved(uint256 tokenId) public view override is_valid_address(msg.sender) returns(address)
    {
        require(token_exists(tokenId), "Non-existent token.");
        return _token_approvals[tokenId];
    }




    /**
    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
    *
    * See {setApprovalForAll}
    */

    function isApprovedForAll(address owner, address operator) public view override is_valid_address(msg.sender) is_valid_address(owner) is_valid_address(operator) returns(bool)
    {
        return _operator_approvals[owner][operator];
    }




    // Extra functions.

    function getURL(uint256 tokenId) public view is_valid_address(msg.sender) returns(string memory)
    {
        require(token_exists(tokenId), "Non-existent token.");
        string memory baseURI = "";
        string memory endURI = tokenId.toString();

        string memory fullURL = string(abi.encodePacked(baseURI, endURI));

        return fullURL;
    }




    function mint(uint256 tokenId) public is_valid_address(msg.sender)
    {
        require(!token_exists(tokenId), "Token already exists.");

        _owners[tokenId] = _owner;
        _balances[_owner] += 1;
    }




    function burn(uint256 tokenId) public is_valid_address(msg.sender)
    {
        require(token_exists(tokenId), "Token inexistent.");
        require(_owners[tokenId] == _owner, "Token owned by another.");

        delete _owners[tokenId];
        delete _token_approvals[tokenId];
        _balances[_owner] -= 1;
    }




    /**
     * Copied.
     *
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) 
    {
        if (isContract(to))
        {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) 
            {
                return retval == IERC721Receiver.onERC721Received.selector;
            } 
            catch (bytes memory reason) 
            {
                if (reason.length == 0) 
                {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } 
                else 
                {
                    assembly 
                    {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } 
        else 
        {
            return true;
        }
    }

    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }
}