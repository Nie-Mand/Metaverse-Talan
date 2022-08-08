// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract MetaDaoToken is ERC20Votes {
    uint256 public s_maxSupply = 6666666666;

    constructor() ERC20("MetaDaoToken", "META") ERC20Permit("MetaDaoToken") {
        _mint(msg.sender, s_maxSupply);
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
