// SPDX-License-Identifier: MIT

pragma solidity >0.6.0;

import "./interfaces/IERC721.sol";
import "./interfaces/IERC165.sol";
import "./interfaces/IERC721Receiver.sol";
import "./utils/IERC721Receiver.sol";

contract MyNFT
{

    // Mapping of the tokenids to the addresses.
    

    function _msgSender() internal view returns(address)
    {
        return msg.sender;
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