// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TwitterNameSpace is ChainlinkClient { 

    using Chainlink for Chainlink.Request;

    address public tempRequestAddress;      //20 BYTES, 20/32 FOR SLOT 0
    uint96  public tempTwitter_id;          //12 BYTES, 32/32 FOR SLOT 0

    mapping(address => uint96) public addressTwitterID;
    mapping(uint96 => address) public twitterIDaddress;

    event tweetRequestEvent();

    modifier twitterMatchesAccount(uint96 twitter_id,address checkAddress){
        require(twitterIDaddress[twitter_id] == checkAddress, "You have not verified this Twitter ID with your account yet.");
        _;
    }

    constructor()  {
        setChainlinkToken(0xbFB26279a9D28CeC1F781808Da89eFbBfE2c4268);
        setChainlinkOracle(0x401ae6Bfb89448fB6e06CE7C9171a8A0366d02d0);
    }

    function requestTweetAddressCompare(uint96 twitter_id_Request) public returns (bytes32 requestId) {
        require(tempTwitter_id ==  0 && tempRequestAddress == address(0), "REQUEST ALREADY ACTIVE!");
        Chainlink.Request memory req = buildChainlinkRequest("13a2fe212bcf40978d8c0d52b8d96e4d", address(this), this.fulfillTweetAddressCompare.selector);
        req.add("twitter_id"   , Strings.toString(twitter_id_Request));                                    // Point at specific Tweet.
        req.add("address_owner", Strings.toHexString(uint160(msg.sender), 20) ); //Point at msg.sender (type string to handle Chainlink request).
        tempTwitter_id = twitter_id_Request;
        tempRequestAddress = msg.sender;
        return sendChainlinkRequest(req, 1 ether);
    }

    function fulfillTweetAddressCompare(bytes32 _requestId, uint _addressFromTweetMatches) public recordChainlinkFulfillment(_requestId) {
        if(_addressFromTweetMatches == 1){
            if(twitterIDaddress[tempTwitter_id] != address(0)){
                addressTwitterID[twitterIDaddress[tempTwitter_id]] = 0;
            }
                addressTwitterID[tempRequestAddress] = tempTwitter_id;
                twitterIDaddress[tempTwitter_id] = tempRequestAddress;
        }
        tempRequestAddress = address(0);
        tempTwitter_id = 0;
        emit tweetRequestEvent();
    }

    function resolveToTwitterID(uint96 _twitter_id) public twitterMatchesAccount(_twitter_id,msg.sender){
        addressTwitterID[msg.sender] = _twitter_id;
    }

}
