// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./CoOwnable.sol";

contract Identity is CoOwnable {
    string private name;
    mapping(string => string) private metadata;

    event NameChanged(string oldName, string newName);
    event MetadataChanged(string key, string oldValue, string newValue);

    modifier notEqualTo(string storage _old, string memory _new) {
        require(
            keccak256(abi.encodePacked(_old)) !=
                keccak256(abi.encodePacked(_new)),
            "The new value must not be equal to the old value"
        );
        _;
    }

    constructor(address _identified, string memory _name)
        CoOwnable(_identified)
    {
        name = _name;
    }

    function getName() public view returns (string memory) {
        return name;
    }

    function setName(string memory _name)
        public
        onlyIdentifier
        notEqualTo(name, _name)
    {
        name = _name;
        emit NameChanged(name, _name);
    }

    function setMetadata(string memory _k, string memory _v)
        public
        onlyIdentifier
        notEqualTo(metadata[_k], _v)
    {
        metadata[_k] = _v;
        emit MetadataChanged(_k, _v, metadata[_k]);
    }

    function getMetadata(string memory _k) public view returns (string memory) {
        return metadata[_k];
    }
}
