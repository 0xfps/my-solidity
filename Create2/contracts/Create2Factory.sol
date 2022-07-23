// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeployWithCreate2 {
    address public owner;
    uint public f;

    constructor (address _owner, uint e) {
        owner = _owner;
        f = e;
    }
}


contract Create2Factory {
    event Deploy(address addr);
    address public _add;

    function deploy(uint256 _salt) public {
        DeployWithCreate2 _contract = new DeployWithCreate2 {
            salt: bytes32(_salt)
        }(msg.sender, 6);
        emit Deploy(address(_contract));
    }

    function getAddress(bytes memory bytecode, uint256 _salt) public view returns(address) {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                _salt,
                keccak256(bytecode)
            )
        );

        return address(uint160(uint(hash)));
    }

    function getBytecode() public view returns(bytes memory bytecode) {
        bytes memory cCode = type(DeployWithCreate2).creationCode;
        bytecode = abi.encodePacked(cCode, abi.encode(msg.sender, 6));
        // bytecode = abi.encodePacked(cCode, abi.encode(msg.sender), abi.encode(6));
    }

    function getAddressWithAssembly(uint256 _salt) public {
        bytes memory cCode = type(DeployWithCreate2).creationCode;
        bytes memory bytecode = abi.encodePacked(cCode, abi.encode(msg.sender, 6));
        bytes32 salt = bytes32(_salt);
        address _address;
        assembly {
            _address := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        _add = _address;
    }
}
