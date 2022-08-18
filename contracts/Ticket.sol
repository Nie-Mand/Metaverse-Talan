// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Ticket is ERC721URIStorage {
    uint public tokenCount;
    constructor() ERC721("SportTicket","Ticket"){

    }
    function mint(string memory _tokenURI)external returns(uint){
        tokenCount++;
        _safeMint(msg.sender,tokenCount);
        _setTokenURI(tokenCount,_tokenURI);
        return tokenCount;
    }


}