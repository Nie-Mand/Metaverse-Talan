// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./TimeLock.sol";

contract TimeLockFactory {
    mapping(address => address) public addresses;

    event TimeLockCreated(
        address indexed _address,
        address indexed _timeLockAddress
    );

    function create(uint256 _minDelay) public {
        address[] memory empty = new address[](0);
        TimeLock _timeLockAddress = new TimeLock(_minDelay, empty, empty);
        addresses[msg.sender] = address(_timeLockAddress);
        emit TimeLockCreated(msg.sender, address(_timeLockAddress));
    }
}
