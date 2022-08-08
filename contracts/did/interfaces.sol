// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../structs.sol";

interface IIdentityIssuer {
    // @dev: This function registers a new identity for the given profile.
    function register(Structs.UserProfile memory _user) external;

    // @dev: This function returns the address of the identity of the caller.
    function whoami() external view returns (address);

    // @dev: This function returns the address of the identity of the given user.
    function lookup(address _user) external view returns (address);
}

interface IIdentity {
    // @dev: This function returns the name of the identified user.
    function getName() external view returns (string memory);

    // @dev: This function sets the name of the identified user.
    function setName(string memory _name) external;

    // @dev: This function sets the metadata of the identified user.
    function setMetadata(string memory _k, string memory _v) external;

    // @dev: This function returns the metadata of the identified user.
    function getMetadata(string memory _k)
        external
        view
        returns (string memory);
}

interface ICoOwnable {
    // @dev: This function returns the issuer of the contract (the contract creator).
    function issuer() external view returns (address);

    // @dev: This function returns the owner of the contract.
    function identified() external view returns (address);

    // @dev: This function checks if the caller is the issuer of the identity.
    function isIssuer() external view returns (bool);

    // @dev: This function checks if the caller is the identified user of the contract.
    function isIdentified() external view returns (bool);

    // @dev: This function transfers the role `issuer` of the contract to the given address.
    function transferIssue(address _newIssuer) external;
}
