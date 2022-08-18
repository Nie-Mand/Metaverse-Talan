// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PrestigeToken is Ownable, ERC20Votes {
    uint256 public s_maxSupply = 6666666666;
    uint256 public tokenPrice;
    uint256 public maximumTokenToBuy;

    constructor(uint256 _tokenPrice, uint256 _maximumTokenToBuy)
        Ownable()
        ERC20("PrestigeToken", "$PRESTIGE")
        ERC20Permit("PrestigeToken")
    {
        tokenPrice = _tokenPrice;
        maximumTokenToBuy = _maximumTokenToBuy;
        _mint(msg.sender, s_maxSupply);
    }

    function setTokenPrice(uint256 _tokenPrice) public onlyOwner {
        tokenPrice = _tokenPrice;
    }

    function setMaximumTokenToBuy(uint256 _maximumTokenToBuy) public onlyOwner {
        maximumTokenToBuy = _maximumTokenToBuy;
    }

    // he said they should be overriden, so I just did
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal override(ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20Votes)
    {
        super._burn(account, amount);
    }
}

abstract contract IPrestigeToken {
    function tokenPrice() public virtual returns (uint256);

    function maximumTokenToBuy() public virtual returns (uint256);

    function transfer(address to, uint256 amount) public virtual returns (bool);

    function balanceOf(address account) public view virtual returns (uint256);
}
