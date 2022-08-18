// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract SampleContract {
    uint256 public v = 911;

    function set(uint256 _v) public {
        v = _v;
    }
}
