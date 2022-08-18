// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TicketsMarketplace is Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tiketsIds;
    Counters.Counter private _tiketsSold;

    //uint256 listingPrice = 0.00056 ether;

    mapping(uint256 => MarketItem) private idToMarketItem;

    struct MarketItem {
        uint256 tokenId;
        string matchId;
        uint256 gameWillfinishAfter;
        uint256 addedAt;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    event MarketItemCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    constructor() ERC721("Tickets Metaverse Tokens", "TICKET") Ownable() {}

    function createTickets(
        string memory tokenURI,
        uint256 _gameWillfinishAfter,
        uint256 price,
        uint256 number,
        string memory matchId
    ) public payable onlyOwner {
        for (uint256 i = 0; i < number; i++) {
            _tiketsIds.increment();
            uint256 newTokenId = _tiketsIds.current();
            _mint(msg.sender, newTokenId);
            _setTokenURI(newTokenId, tokenURI);
            createMarketItem(newTokenId, _gameWillfinishAfter, price, matchId);
        }
    }

    function createMarketItem(
        uint256 tokenId,
        uint256 _gameWillfinishAfter,
        uint256 price,
        string memory matchId
    ) private {
        require(price > 0, "Price must be at least 1 wei");

        idToMarketItem[tokenId] = MarketItem(
            tokenId,
            matchId,
            _gameWillfinishAfter,
            block.timestamp,
            payable(msg.sender),
            payable(address(this)),
            price,
            false
        );

        _transfer(msg.sender, address(this), tokenId);
        emit MarketItemCreated(
            tokenId,
            msg.sender,
            address(this),
            price,
            false
        );
    }

    function numberOfTicketById(string memory _matchId)
        public
        view
        returns (uint256)
    {
        return fetchMatchById(_matchId).length;
    }

    function fetchMatchById(string memory _matchId)
        public
        view
        returns (MarketItem[] memory)
    {
        uint256 totalItemCount = _tiketsIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (
                keccak256(abi.encodePacked(idToMarketItem[i + 1].matchId)) ==
                keccak256(abi.encodePacked(_matchId)) &&
                !idToMarketItem[i + 1].sold
            ) {
                itemCount += 1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (
                keccak256(abi.encodePacked(idToMarketItem[i + 1].matchId)) ==
                keccak256(abi.encodePacked(_matchId)) &&
                !idToMarketItem[i + 1].sold
            ) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    function buyTicketToAttendMatch(uint256 tokenId) public payable {
        uint256 price = idToMarketItem[tokenId].price;
        address seller = idToMarketItem[tokenId].seller;
        uint256 time = idToMarketItem[tokenId].gameWillfinishAfter +
            idToMarketItem[tokenId].addedAt;
        require(block.timestamp < time, "Game is over");
        require(
            msg.value == price,
            "Please submit the asking price in order to complete the purchase"
        );
        idToMarketItem[tokenId].owner = payable(msg.sender);
        idToMarketItem[tokenId].sold = true;
        idToMarketItem[tokenId].seller = payable(address(0));
        _tiketsSold.increment();
        _transfer(address(this), msg.sender, tokenId);
        //payable(owner).transfer(listingPrice);
        payable(seller).transfer(msg.value);
    }

    function BuyTicketAsCollection(uint256 tokenId) public payable {
        uint256 price = idToMarketItem[tokenId].price;
        address seller = idToMarketItem[tokenId].seller;
        uint256 time = idToMarketItem[tokenId].gameWillfinishAfter +
            idToMarketItem[tokenId].addedAt;
        require(block.timestamp > time, "Game is over");
        require(
            msg.value == price,
            "Please submit the asking price in order to complete the purchase"
        );
        idToMarketItem[tokenId].owner = payable(msg.sender);
        idToMarketItem[tokenId].sold = true;
        idToMarketItem[tokenId].seller = payable(address(0));
        _tiketsSold.increment();
        _transfer(address(this), msg.sender, tokenId);
        //payable(owner).transfer(listingPrice);
        payable(seller).transfer(msg.value);
    }

    function fetchMyTikets() public view returns (MarketItem[] memory) {
        uint256 totalItemCount = _tiketsIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == msg.sender) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == msg.sender) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    function get(uint256 tokenId) public view returns (uint256) {
        return idToMarketItem[tokenId].price;
    }

    function resellTicket(uint256 tokenId) public payable {
        uint256 time = idToMarketItem[tokenId].gameWillfinishAfter +
            idToMarketItem[tokenId].addedAt;
        require(block.timestamp < time, "Game is over");
        require(
            idToMarketItem[tokenId].owner == msg.sender,
            "Only item owner can perform this operation"
        );
        idToMarketItem[tokenId].sold = false;
        idToMarketItem[tokenId].price = idToMarketItem[tokenId].price;
        idToMarketItem[tokenId].seller = payable(msg.sender);
        idToMarketItem[tokenId].owner = payable(address(this));
        _tiketsSold.decrement();

        _transfer(msg.sender, address(this), tokenId);
    }

    function resellTicketAsNft(uint256 tokenId, uint256 _price) public payable {
        uint256 time = idToMarketItem[tokenId].gameWillfinishAfter +
            idToMarketItem[tokenId].addedAt;
        require(block.timestamp > time, "Game still going");
        require(
            idToMarketItem[tokenId].owner == msg.sender,
            "Only item owner can perform this operation"
        );
        idToMarketItem[tokenId].sold = false;
        idToMarketItem[tokenId].price = _price;
        idToMarketItem[tokenId].seller = payable(msg.sender);
        idToMarketItem[tokenId].owner = payable(address(this));
        _tiketsSold.decrement();

        _transfer(msg.sender, address(this), tokenId);
    }
}
