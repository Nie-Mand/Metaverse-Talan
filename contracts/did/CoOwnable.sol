// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

error CoOwnable__NotIssuer();
error CoOwnable__NotIdentifier();
error CoOwnable__NotOwner();
error CoOwnable__InvalidAddress();

abstract contract CoOwnable {
    address private _issuer;
    address private _identified;

    event IssuerTransferred(
        address indexed previousIssuer,
        address indexed newIssuer
    );

    constructor(address _identifiedAddress) validAddress(_identifiedAddress) {
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
        validAddress(_newIssuer)
    {
        emit IssuerTransferred(_issuer, _newIssuer);
        _issuer = _newIssuer;
    }

    modifier validAddress(address _address) {
        if (_address == address(0)) revert CoOwnable__InvalidAddress();
        _;
    }

    modifier onlyIssuer() {
        if (msg.sender != _issuer) revert CoOwnable__NotIssuer();
        _;
    }

    modifier onlyIdentifier() {
        if (msg.sender != _identified) revert CoOwnable__NotIdentifier();
        _;
    }

    modifier onlyOwners() {
        if (msg.sender != _issuer && msg.sender != _identified)
            revert CoOwnable__NotOwner();
        _;
    }
}
