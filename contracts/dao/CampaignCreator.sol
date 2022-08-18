// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Campaign.sol";
import "./PrestigeToken.sol";
import "./PrestigeTokenFactory.sol";
import "./TimeLock.sol";
import "./TimeLockFactory.sol";
import "./TicketsMarketplaceFactory.sol";

contract CampaignFactory is Ownable {
    address public tokenFactory;
    address public timeLockFactory;
    address public ticketsMarketplaceFactory;
    uint256 public campainCreationFee = 0.001 ether;

    mapping(address => address) public campaignCreators;

    event CampainCreated(
        address indexed _creator,
        address indexed _campaign,
        string _reason
    );

    constructor(
        address _tokenFactory,
        address _timeLockFactory,
        address _ticketsMarketplaceFactory
    ) {
        tokenFactory = _tokenFactory;
        timeLockFactory = _timeLockFactory;
        ticketsMarketplaceFactory = _ticketsMarketplaceFactory;
    }

    function setCampainCreationFee(uint256 _newFee) public onlyOwner {
        campainCreationFee = _newFee;
    }

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
        require(_target > 0, "Invalid target");
        require(_maxTokensToBuy > 0, "Invalid max tokens to buy");
        require(
            msg.value >= campainCreationFee,
            "You don't have enough ether to create a campaign"
        );

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
        (
            address token,
            address timelock,
            address ticketsMarketplace,
            PrestigeTokenFactory _tokenFactory
        ) = _beforeCreateCampaign(_tokenPrice, _maxTokensToBuy, _delay);

        PrestigeToken finalToken = PrestigeToken(token);
        TimeLock finalTimelock = TimeLock(payable(timelock));

        Campaign campaign = new Campaign(
            finalToken,
            finalTimelock,
            _quorumPercentage,
            _period,
            _delay
        );

        _afterCreateCampaign(
            campaign,
            ticketsMarketplace,
            _reason,
            _target,
            _tokenFactory
        );
        emit CampainCreated(msg.sender, address(campaign), _reason);
    }

    function _beforeCreateCampaign(
        uint256 _tokenPrice,
        uint256 _maxTokensToBuy,
        uint256 _delay
    )
        private
        returns (
            address,
            address,
            address,
            PrestigeTokenFactory
        )
    {
        PrestigeTokenFactory _tokenFactory = PrestigeTokenFactory(tokenFactory);
        _tokenFactory.create(_tokenPrice, _maxTokensToBuy);
        address token = _tokenFactory.tokens(address(this));

        TimeLockFactory _timeLockFactory = TimeLockFactory(timeLockFactory);
        _timeLockFactory.create(_delay);
        address timelock = _timeLockFactory.addresses(address(this));

        TicketsMarketplaceFactory _ticketsMarketplaceFactory = TicketsMarketplaceFactory(
                ticketsMarketplaceFactory
            );
        _ticketsMarketplaceFactory.create();
        address ticketsMarketplace = _ticketsMarketplaceFactory.marketplaces(
            address(this)
        );

        return (token, timelock, ticketsMarketplace, _tokenFactory);
    }

    function _afterCreateCampaign(
        Campaign _campaign,
        address _ticketsMarketplace,
        string memory _reason,
        uint256 _target,
        PrestigeTokenFactory _tokenFactory
    ) private {
        _campaign.initStateBecauseSolidityDoesntAllowManyArgs(
            _ticketsMarketplace,
            _target,
            _reason
        );
        _tokenFactory.transferAllTokens(address(_campaign));
    }
}
