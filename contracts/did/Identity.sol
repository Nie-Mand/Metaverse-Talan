// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./CoOwnable.sol";

contract Identity is CoOwnable {
    string private name;
    mapping(string => string) private metadata;

    event NameChanged(string oldName, string newName);
    event MetadataChanged(string key, string oldValue, string newValue);

    constructor(address _identified, string memory _name)
        CoOwnable(_identified)
    {
        name = _name;
    }

    function getName() public view returns (string memory) {
        return name;
    }

    function setName(string memory _name) public onlyIdentifier {
        name = _name;
        emit NameChanged(name, _name);
    }

    function setMetadata(string memory _k, string memory _v)
        public
        onlyIdentifier
    {
        metadata[_k] = _v;
        emit MetadataChanged(_k, _v, metadata[_k]);
    }

    function getMetadata(string memory _k) public view returns (string memory) {
        return metadata[_k];
    }
}
