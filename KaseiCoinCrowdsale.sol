pragma solidity ^0.5.5;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract KaseiCoinCrowdsale is
    Crowdsale,
    MintedCrowdsale,
    CappedCrowdsale,
    TimedCrowdsale,
    RefundablePostDeliveryCrowdsale
{
    constructor(
        uint256 rate,
        address payable wallet,
        KaseiCoin token,
        uint256 goal,
        uint256 open,
        uint256 close
    )
        public
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
    {
        // constructor can stay empty
    }
}

contract KaseiCoinCrowdsaleDeployer {
    address public kasei_token_address;
    address public kasei_crowdsale_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet,
        uint256 goal
    ) public {
        // Create a new instance of the KaseiCoin contract.
        KaseiCoin kasei_token = new KaseiCoin(name, symbol, 0);

        // Assign the token contract’s address to the `kasei_token_address` variable.
        kasei_token_address = address(kasei_token);

        // Create a new instance of the `KaseiCoinCrowdsale` contract
        KaseiCoinCrowdsale kasei_crowdsale = new KaseiCoinCrowdsale(
            1,
            wallet,
            kasei_token,
            goal,
            now,
            now + 24 weeks
        );

        // Aassign the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable.
        kasei_crowdsale_address = address(kasei_crowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        kasei_token.addMinter(kasei_crowdsale_address);

        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        kasei_token.renounceMinter();
    }
}
