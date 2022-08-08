// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Identity.sol";
import "../structs.sol";
import "./interfaces.sol";

contract IdentityIssuer is IIdentityIssuer {
    mapping(address => address) identities;

    event IdentityRegistered(address indexed _user, address indexed _identity);

    function register(Structs.UserProfile memory _user) external {
        require(
            identities[msg.sender] == address(0),
            "You are already registered"
        );
        Identity identity = new Identity(msg.sender, _user.name);
        identities[msg.sender] = address(identity);
        emit IdentityRegistered(msg.sender, address(identity));
    }

    function whoami() external view returns (address) {
        require(
            identities[msg.sender] != address(0),
            "You do not have an identity"
        );

        return identities[msg.sender];
    }

    function lookup(address _user) external view returns (address) {
        require(
            identities[_user] != address(0),
            "He does not have an identity"
        );

        return identities[msg.sender];
    }
}
