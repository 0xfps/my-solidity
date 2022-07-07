// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

/*
* @title: Signed Message.
* @author: Anthony (fps) https://github.com/fps8k.
* @dev: Sign and Verify Message.
*/

contract Signed
{
    address public addr;

    function hashMessage() public pure returns(bytes32) {
        return(keccak256("I sent a transaction"));
    }

    function signMessage() public pure returns(bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hashMessage()));
    }

    function splitSignature(bytes32 sig) 
        private 
        pure 
        returns(
            bytes32 r, 
            bytes32 s, 
            uint8 v
        )
    {
        assembly {
            /*
            First 32 bytes stores the length of the signature

            add(sig, 32) = pointer of sig + 32
            effectively, skips first 32 bytes of signature

            mload(p) loads next 32 bytes starting at the memory address p into memory
            */

            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }
    }

    function verify() public {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(signMessage());
        addr = ecrecover(
            hashMessage(), 
            v, 
            r, 
            s
        );
    }
}
