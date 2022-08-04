// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

abstract contract CoOwnable {
    address private _issuer;
    address private _identified;

    event IssuerTransferred(
        address indexed previousIssuer,
        address indexed newIssuer
    );

    modifier validAddress(address _address, string memory _errorMessage) {
        require(_address != address(0), _errorMessage);
        _;
    }

    modifier onlyIssuer() {
        require(
            msg.sender == _issuer,
            "Only the issuer can perform this action"
        );
        _;
    }

    modifier onlyIdentifier() {
        require(
            msg.sender == _identified,
            "Only the identifier can perform this action"
        );
        _;
    }

    modifier onlyOwners() {
        require(
            msg.sender == _issuer || msg.sender == _identified,
            "Only the issuer or identifier can perform this action"
        );
        _;
    }

    constructor(address _identifiedAddress)
        validAddress(_identifiedAddress, "Identified address is not valid")
    {
        _issuer = msg.sender;
        _identified = _identifiedAddress;
        emit IssuerTransferred(address(0), _issuer);
    }

    function issuer() public view returns (address) {
        return _issuer;
    }

    function identified() public view returns (address) {
        return _identified;
    }

    function isIssuer() public view returns (bool) {
        return msg.sender == _issuer;
    }

    function isIdentified() public view returns (bool) {
        return msg.sender == _identified;
    }

    function transferIssue(address _newIssuer)
        public
        onlyIssuer
        validAddress(_newIssuer, "New issuer address is not valid")
    {
        emit IssuerTransferred(_issuer, _newIssuer);
        _issuer = _newIssuer;
    }
}
