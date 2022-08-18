// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract MarketPlace is ReentrancyGuard {
address payable public immutable feeAccount;
uint public immutable feePercent;
uint public itemCount;
struct Item{
    uint itemId;
    IERC721 ticket;
    uint tokentId;
    uint price;
    address payable saller;
    bool sold;
} 
event Offered(
    uint itemId,
    address indexed ticket,
    uint tokenId,
    uint price,
    address indexed seller
);

event Bought(
    uint itemId,
    address indexed ticket,
    uint tokenId,
    uint price,
    address indexed seller,
    address indexed buyer
);

  mapping(uint => Item) public items;

    constructor( uint _freePercent){
        feeAccount=payable(msg.sender);
        feePercent=_freePercent; 
    }
    function makeItem(IERC721 _ticket, uint _tokenId, uint _price) external nonReentrant {
        require(_price >0 ,"Price must be greeter than zero");
        itemCount ++;
        _ticket.transferFrom(msg.sender, address(this) , _tokenId);
        items[itemCount] =Item (
            itemCount,
            _ticket,
            _tokenId,
            _price,
            payable(msg.sender),
            false
            );
        emit Offered(
            itemCount,
            address(_ticket),
            _tokenId,
            _price,
            payable (msg.sender)
        ); 
        
    }

    function purchaseItems(uint _itemId) external payable nonReentrant{
        uint _totalPrice = getTotalPrice(_itemId);
        Item storage item =items[_itemId];
        require(_itemId> 0 && _itemId <= itemCount, "item doesn't not exist");
        require(msg.value >= _totalPrice, "Not enough ether to cover item price and market fee");
        require(!item.sold, "item all ready sold");
        item.saller.transfer(item.price);
        feeAccount.transfer(_totalPrice-item.price);
        item.sold=true;
        item.ticket.transferFrom(address(this),msg.sender,item.tokentId);
    }

    function getTotalPrice(uint _itemId) view public returns(uint){
    return (items[_itemId].price*(100 + feePercent)/100 );
    }
    
}