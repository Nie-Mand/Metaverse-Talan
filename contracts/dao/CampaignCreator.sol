// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Campaign.sol";
import "./PrestigeToken.sol";
import "./PrestigeTokenFactory.sol";
import "./TimeLock.sol";
import "./TimeLockFactory.sol";

contract CampaignFactory is Ownable {
    address public tokenFactory;
    address public timeLockFactory;

    mapping(address => address) public campaignCreators;

    constructor(address _tokenFactory, address _timeLockFactory) {
        tokenFactory = _tokenFactory;
        timeLockFactory = _timeLockFactory;
    }

    uint256 campainCreationFee = 0.001 ether;

    function setCampainCreationFee(uint256 _newFee) public onlyOwner {
        campainCreationFee = _newFee;
    }

    event CampainCreated(address indexed _creator, address indexed _campaign);

    function createCampaign(
        string memory _reason,
        uint256 _delay,
        uint256 _period,
        uint256 _quorumPercentage,
        uint256 _tokenPrice,
        uint256 _target,
        uint256 _maxTokensToBuy
    ) public payable {
        require(_delay > 0, "Invalid delay");
        require(_period > 0, "Invalid period");
        require(
            _quorumPercentage > 0 && _quorumPercentage <= 100,
            "Invalid quorum percentage"
        );
        require(_tokenPrice > 0, "Invalid token price");
        require(msg.value == campainCreationFee, "Invalid amount");

        _createCampaign(
            _tokenPrice,
            _maxTokensToBuy,
            _delay,
            _quorumPercentage,
            _period,
            _reason,
            _target
        );
    }

    function _createCampaign(
        uint256 _tokenPrice,
        uint256 _maxTokensToBuy,
        uint256 _delay,
        uint256 _quorumPercentage,
        uint256 _period,
        string memory _reason,
        uint256 _target
    ) private {
        PrestigeTokenFactory _tokenFactory = PrestigeTokenFactory(tokenFactory);
        _tokenFactory.create(_tokenPrice, _maxTokensToBuy);
        address token = _tokenFactory.tokens(address(this));

        TimeLockFactory _timeLockFactory = TimeLockFactory(timeLockFactory);
        _timeLockFactory.create(_delay);
        address timelock = _timeLockFactory.addresses(address(this));

        PrestigeToken finalToken = PrestigeToken(token);
        TimeLock finalTimelock = TimeLock(payable(timelock));

        Campaign campaign = new Campaign(
            finalToken,
            finalTimelock,
            _quorumPercentage,
            _period,
            _delay,
            _target,
            _reason
        );
        _tokenFactory.transferAllTokens(address(campaign));
        // finalToken.transfer(address(campaign), finalToken.s_maxSupply());
        emit CampainCreated(msg.sender, address(campaign));
    }
}
