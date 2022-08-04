// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./structs.sol";
import "./libraries/CounterUtils.sol";

contract Counter {
    using CounterUtils for Structs.Counter;

    Structs.Counter counter;

    function increment() public {
        counter = counter.increment();
    }

    function decrement() public {
        counter = counter.decrement();
    }

    function get() public view returns (uint256) {
        return counter.get();
    }
}
