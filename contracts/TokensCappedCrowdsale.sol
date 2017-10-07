pragma solidity ^0.4.11;

import "zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";


// Crowdsale capped by number of minted tokens
contract TokensCappedCrowdsale is Crowdsale {

    uint256 public tokensCap;

    function TokensCappedCrowdsale(uint256 _tokensCap) {
        require(_tokensCap > 0);
        tokensCap = _tokensCap;
    }

    // overriding Crowdsale#validPurchase to add extra tokens cap logic
    // @return true if investors can buy at the moment
    function validPurchase() internal constant returns (bool) {
        uint256 tokens = token.totalSupply().add(msg.value.mul(rate));
        bool withinCap = tokens <= tokensCap;
        return super.validPurchase() && withinCap;
    }

    // overriding Crowdsale#hasEnded to add tokens cap logic
    // @return true if crowdsale event has ended
    function hasEnded() public constant returns (bool) {
        bool capReached = token.totalSupply() >= tokensCap;
        return super.hasEnded() || capReached;
    }

}