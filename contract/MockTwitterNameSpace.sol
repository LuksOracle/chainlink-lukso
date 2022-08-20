// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract MockTwitterNameSpace { 

    address public tempRequestAddress;      //20 BYTES, 20/32 FOR SLOT 0
    uint96  public tempTwitter_id;          //12 BYTES, 32/32 FOR SLOT 0

    uint public _addressFromTweetMatches;

    mapping(address => uint96) public addressTwitterID;
    mapping(uint96 => address) public twitterIDaddress;

    function requestTweetAddressCompare(uint96 twitter_id_Request) public {
        require(tempTwitter_id ==  0, "REQUEST ALREADY ACTIVE FOR TWITTER ID!");
        require(tempRequestAddress == address(0), "REQUEST ALREADY CHECKING ADDRESS!");
        //Skip sending to oracle.
        tempTwitter_id = twitter_id_Request;
        tempRequestAddress = msg.sender;
        //Skip waiting for an answer.
          if(_addressFromTweetMatches == 1){
            if(twitterIDaddress[tempTwitter_id] != address(0)){
                addressTwitterID[twitterIDaddress[tempTwitter_id]] = 0;
            }
            addressTwitterID[tempRequestAddress] = tempTwitter_id;
            twitterIDaddress[tempTwitter_id] = tempRequestAddress;
        }
        tempRequestAddress = address(0);
        tempTwitter_id = 0;
    }

    function mockRequestAnswer(uint mockRequestReturnValue) public {
       _addressFromTweetMatches = mockRequestReturnValue;
    }

}