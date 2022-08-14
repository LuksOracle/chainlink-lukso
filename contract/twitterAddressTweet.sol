// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract twitterAddressTweet is ChainlinkClient {

    using Chainlink for Chainlink.Request;

    uint public addressFromTweetMatches;

    constructor()  {
        setChainlinkToken(0xbFB26279a9D28CeC1F781808Da89eFbBfE2c4268);
        setChainlinkOracle(0x401ae6Bfb89448fB6e06CE7C9171a8A0366d02d0);
    }

    function requestTweetAddressCompare(string calldata twitter_id) public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest("13a2fe212bcf40978d8c0d52b8d96e4d", address(this), this.fulfillTweetAddressCompare.selector);
        req.add("twitter_id"   , twitter_id);                                    // Point at specific Tweet.
        req.add("address_owner", Strings.toHexString(uint160(msg.sender), 20) ); //Point at msg.sender (type string to handle Chainlink request).
        return sendChainlinkRequest(req, 1 ether);
    }

    function fulfillTweetAddressCompare(bytes32 _requestId, uint _addressFromTweetMatches) public recordChainlinkFulfillment(_requestId) {
        addressFromTweetMatches = _addressFromTweetMatches;
    }

   function requestTweetUsernameCompare(string calldata twitter_id, string calldata author_id) public returns (bytes32 requestId) {
        
        // CHECK AFTER CONFIRM FIRST ADDRESS OR PASS BASED ON THE SAME TWITTER ID
        // NEED NEW JOB ID
        // MAYBE WE CAN DO TWO REQUESTS IF WE PARSE THEM IN ORDER AND JUST RETURN 1 IF BOTH LOOK GOOD?
        // REPLACE JOB ID WHEN WE HAVE NEW JOB ID INFO IF WE KEEP THIS REQUEST 13a2fe212bcf40978d8c0d52b8d96e4d


        Chainlink.Request memory req = buildChainlinkRequest("13a2fe212bcf40978d8c0d52b8d96e4d", address(this), this.fulfillTweetUsernameCompare.selector);
        req.add("twitter_id", twitter_id); // Chainlink nodes 1.0.0 and later support this format
        req.add("author_id", author_id);
        return sendChainlinkRequest(req, 1 ether);
    }

    function fulfillTweetUsernameCompare(bytes32 _requestId, uint _addressFromTweetMatches) public recordChainlinkFulfillment(_requestId) {
        addressFromTweetMatches = _addressFromTweetMatches;
    }


}
