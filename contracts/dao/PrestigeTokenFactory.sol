// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./PrestigeToken.sol";

contract PrestigeTokenFactory {
    mapping(address => address) public tokens;

    event PrestigeTokenCreated(
        address indexed _address,
        address indexed _token
    );

    function create(uint256 _tokenPrice, uint256 _maximumTokenToBuy) public {
        PrestigeToken token = new PrestigeToken(
            _tokenPrice,
            _maximumTokenToBuy
        );
        tokens[msg.sender] = address(token);
        emit PrestigeTokenCreated(msg.sender, address(token));
    }

    function transferAllTokens(address _newOwner) public {
        PrestigeToken token = PrestigeToken(tokens[msg.sender]);
        tokens[_newOwner] = tokens[msg.sender];
        tokens[msg.sender] = address(0);
        token.transfer(_newOwner, token.s_maxSupply());
    }
}
