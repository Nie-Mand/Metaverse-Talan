// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../did/Identity.sol";
import "../structs.sol";

contract IdentityIssuer {
    mapping(address => address) identities;

    function login() public view returns (address) {
        require(
            identities[msg.sender] != address(0),
            "You do not have an identity"
        );

        return identities[msg.sender];
    }

    function signup(Structs.UserProfile memory _user) public {
        require(
            identities[msg.sender] == address(0),
            "You are already registered"
        );
        Identity identity = new Identity(msg.sender, _user.name);
        identities[msg.sender] = address(identity);
    }
}
