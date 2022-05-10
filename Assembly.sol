// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Box {
    uint256 private _value;

    event NewValue(uint256 newValue);

    function store(uint256 newValue) public {
        _value = newValue;
        emit NewValue(newValue);
    }

    function retrieve() public view returns (uint256) {
        return _value;
    }
}