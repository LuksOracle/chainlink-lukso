// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';

contract twitterAddressTweet is ChainlinkClient {

    using Chainlink for Chainlink.Request;

    uint public addressFromTweetMatches;

    constructor()  {
        setChainlinkToken(0xbFB26279a9D28CeC1F781808Da89eFbBfE2c4268);
        setChainlinkOracle(0x401ae6Bfb89448fB6e06CE7C9171a8A0366d02d0);
    }

    function requestTempData(string calldata twitter_id, string calldata address_owner) public returns (bytes32 requestId) {
       
        // require(msg.sender == address_owner, "YOU MUST HAVE THE ADDRESS OWNER TO DO THIS");
       
        Chainlink.Request memory req = buildChainlinkRequest("13a2fe212bcf40978d8c0d52b8d96e4d", address(this), this.fulfill.selector);
        req.add("twitter_id", twitter_id); // Chainlink nodes 1.0.0 and later support this format
        req.add("address_owner", address_owner);
        return sendChainlinkRequest(req, 1 ether);
    }

    function fulfill(bytes32 _requestId, uint _addressFromTweetMatches) public recordChainlinkFulfillment(_requestId) {
        addressFromTweetMatches = _addressFromTweetMatches;
    }

}
