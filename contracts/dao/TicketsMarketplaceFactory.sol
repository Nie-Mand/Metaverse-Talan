// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./TicketsMarketplace.sol";

contract TicketsMarketplaceFactory {
    mapping(address => address) public marketplaces;

    event TicketsMarketplaceCreated(
        address indexed _address,
        address indexed _marketplace
    );

    function create() public {
        TicketsMarketplace marketplace = new TicketsMarketplace();
        marketplaces[msg.sender] = address(marketplace);
        emit TicketsMarketplaceCreated(msg.sender, address(marketplace));
    }
}
