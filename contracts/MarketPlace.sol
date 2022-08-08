// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract MarketPlace is ReentrancyGuard {
address payable public immutable feeAccount;
uint public immutable feePercent;
uint public itemCount;
    constructor( uint _freePercent){
        feeAccount=payable(msg.sender);
        feePercent=_freePercent;
    }
}