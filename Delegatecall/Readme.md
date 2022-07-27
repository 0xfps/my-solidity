# Upgradable contracts with DelegateCall.

## Contents.
- [ ] [Store.sol](https://github.com/0xfps/my-solidity/blob/main/Delegatecall/Delegatecall%20Source/Utils/Store.sol)
- [ ] [Admin.sol](https://github.com/0xfps/my-solidity/blob/main/Delegatecall/Delegatecall%20Source/Utils/Admin.sol)
- [ ] [Main.sol](https://github.com/0xfps/my-solidity/blob/main/Delegatecall/Delegatecall%20Source/Utils/Main.sol)
- [ ] [Proxy.sol](https://github.com/0xfps/my-solidity/blob/main/Delegatecall/Delegatecall%20Source/Proxy.sol)

<br/>

## Definitions.

### [Store.sol](https://github.com/0xfps/my-solidity/blob/main/Delegatecall/Delegatecall%20Source/Utils/Store.sol)

> This contract stores all the state variables, so it is easy for the Proxy and the Main contracts to inherit the same storage stack.
> This contract is inherited by the Main and the Proxy.

<br/>

### [Admin.sol](https://github.com/0xfps/my-solidity/blob/main/Delegatecall/Delegatecall%20Source/Utils/Admin.sol)

> This contract sets and changes the address of the Main contract whenever it is upgraded, it might be ownable with owner set to a particular address for Main contract deployement address change abilities.
> This contract is inherited by the Proxy.

<br/>


### [Main.sol](https://github.com/0xfps/my-solidity/blob/main/Delegatecall/Delegatecall%20Source/Utils/Main.sol)

> This contract is where the main logic occurs, it reads and modifies the state variables of the Proxy via delegatecall.
> This contract is not inherited.

<br/>

### [Proxy.sol](https://github.com/0xfps/my-solidity/blob/main/Delegatecall/Delegatecall%20Source/Proxy.sol)

> This is the contract that uses it's delegatecall function to get the Main to run it's logic using the state variables in it [Proxy].
> This contract is not inherited.
```
      /// @dev Address of Main.
      address cont = current_contract;
      /// @dev Delegatecall using that address.
      /// @return bool.
      /// @return bytes memory.
      (bool sent, ) = cont.delegatecall(
            abi.encodeWithSignature(
                "add(uint256,uint256)", 
                _a, 
                _b
            )
        );
      /// @dev Ensure that the Delegatecall was successful.
      require(sent, "Delegatecall, failed");
```

<br/>

## How To Deploy.
- [x] Deploy Main first.
- [x] Deploy Proxy
- [x] Set the delegate call address to Main's deployment address.

---
