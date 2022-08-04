// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../structs.sol";

library CounterUtils {
    function increment(Structs.Counter memory _c)
        public
        pure
        returns (Structs.Counter memory)
    {
        _c.count++;
        return _c;
    }

    function decrement(Structs.Counter memory _c)
        public
        pure
        returns (Structs.Counter memory)
    {
        _c.count--;
        return _c;
    }

    function get(Structs.Counter memory _c) public pure returns (uint8) {
        return _c.count;
    }

    function set(Structs.Counter memory _c, uint8 _count)
        public
        pure
        returns (Structs.Counter memory)
    {
        _c.count = _count;
        return _c;
    }
}
