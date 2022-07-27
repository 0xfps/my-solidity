// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @dev Contract to be deployed with Create2.
contract DeployWithCreate2 {
    address public owner;
    uint public f;

    constructor (address _owner, uint e) {
        owner = _owner;
        f = e;
    }

    function selfDestruct() public {
        selfdestruct(payable(msg.sender));
    }
}

/// @dev Contract deploying with Create2.
contract Create2Factory {
    event Deploy(address addr);
    address public _add;

    /**
    * @dev  Deploy using any salt of user choice.
    *       When deployed with this function using a
    *       particular salt, and that same salt is used
    *       again, this throws an error.
    *       Also, when deployed with this function using 
    *       a particular salt, and that same salt is used
    *       in the deployWithAssemblyCreate2, it also 
    *       throws an error.
    *
    * @param _salt A random uint256.
    */
    function deploy(uint256 _salt) public {
        DeployWithCreate2 _contract = new DeployWithCreate2 {
            salt: bytes32(_salt)
        }(msg.sender, 6);
        emit Deploy(address(_contract));
    }

    /**
    * @dev  Returns the pre-calculated address of the contract
    *       to be deployed using Create2.
    *       
    * @param bytecode   Compiled bytecode of contract to be 
    *                   deployed.
    * @param _salt      A random uint256.
    *
    * @return address Pre-calculated address.
    */
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

    /**
    * @dev  Returns the bytecode of the contract to be deployed
    *       along with its constructor parameters.
    *
    * @return bytecode Contract bytecode.
    */
    function getBytecode() public view returns(bytes memory bytecode) {
        bytes memory cCode = type(DeployWithCreate2).creationCode;
        bytecode = abi.encodePacked(cCode, abi.encode(msg.sender, 6));
        // bytecode = abi.encodePacked(cCode, abi.encode(msg.sender), abi.encode(6));
    }

    /** @dev    Deploys with assembly create 2.
    *           THIS IS THE PERK:
    *           When this function is called first time,
    *           the contract is deployed successfully,
    *           returning and storing the address of the 
    *           deployed contract to `_add`.
    *           Calling the deploy function above will throw
    *           an error.
    *
    *           However, after this function is called first
    *           time and the above happens, storing the address
    *           in the `_add` variable, when it is called again,
    *           the transaction is successful, meaning a new 
    *           contract is deployed, but now, the new address
    *           and the addresses of other subsequent deploys is
    *           now a 0 address. Hence, the address in the `_add`
    *           variable is replaced with a 0 address.
    *
    * @notice   Address after first deployement with _salt as 6:
    *           0x9138AcCfF44091B80C53F35678188f90dc5494fb.
    *           Address after calling the function a second time:
    *           0x0000000000000000000000000000000000000000.
    */
    function deployWithAssemblyCreate2(uint256 _salt) public {
        bytes memory cCode = type(DeployWithCreate2).creationCode;
        bytes memory bytecode = abi.encodePacked(cCode, abi.encode(msg.sender, 6));
        bytes32 salt = bytes32(_salt);
        address _address;
        assembly {
            _address := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        _add = _address;
    }

    /// @dev Destruct the deployed contract.
    function destroy(address _a) public {
        DeployWithCreate2(_a).selfDestruct();
        _add = address(0);
    }
}
