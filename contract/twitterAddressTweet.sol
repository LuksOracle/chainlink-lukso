// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TwitterNameSpace is ChainlinkClient { 

    using Chainlink for Chainlink.Request;

    address public tempRequestAddress;
    string public tempTwitter_id;       //REWRITE AS A UINT96 LATER IF POSSIBLE TO PACK ADDRESS 20 BYTES WITH ANOTHER 12 BYTES.

    mapping(address => string) public addressTwitterID;
    mapping(string => address) public twitterIDaddress;

    constructor()  {
        setChainlinkToken(0xbFB26279a9D28CeC1F781808Da89eFbBfE2c4268);
        setChainlinkOracle(0x401ae6Bfb89448fB6e06CE7C9171a8A0366d02d0);
    }

    function requestTweetAddressCompare(string calldata twitter_id) public returns (bytes32 requestId) {
        require(keccak256(abi.encodePacked((tempTwitter_id))) == keccak256(abi.encodePacked(("0"))), "REQUEST ALREADY ACTIVE FOR TWITTER ID!");
        require(tempRequestAddress == address(0), "REQUEST ALREADY CHECKING ADDRESS!");
        Chainlink.Request memory req = buildChainlinkRequest("13a2fe212bcf40978d8c0d52b8d96e4d", address(this), this.fulfillTweetAddressCompare.selector);
        req.add("twitter_id"   , twitter_id);                                    // Point at specific Tweet.
        req.add("address_owner", Strings.toHexString(uint160(msg.sender), 20) ); //Point at msg.sender (type string to handle Chainlink request).
        tempTwitter_id = twitter_id;
        tempRequestAddress = msg.sender;
        return sendChainlinkRequest(req, 1 ether);
    }

    function fulfillTweetAddressCompare(bytes32 _requestId, uint _addressFromTweetMatches) public recordChainlinkFulfillment(_requestId) {
        if(_addressFromTweetMatches == 1){
            addressTwitterID[tempRequestAddress] = tempTwitter_id;
            twitterIDaddress[tempTwitter_id] = tempRequestAddress;
        }
        tempRequestAddress = address(0);
        tempTwitter_id = "0";
    }

//    function requestTweetUsernameCompare(string calldata twitter_id) public returns (bytes32 requestId) {
//         Chainlink.Request memory req = buildChainlinkRequest("13a2fe212bcf40978d8c0d52b8d96e4d", address(this), this.fulfillTweetUsernameCompare.selector);
//         req.add("twitter_id", twitter_id); // Chainlink nodes 1.0.0 and later support this format
//         return sendChainlinkRequest(req, 1 ether);
//     }

//     function fulfillTweetUsernameCompare(bytes32 _requestId, uint _addressFromTweetMatches) public recordChainlinkFulfillment(_requestId) {
//         addressFromTweetMatches = _addressFromTweetMatches;
//     }



}
