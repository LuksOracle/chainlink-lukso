// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract MockTwitterNameSpace { 

    address public tempRequestAddress;      //20 BYTES, 20/32 FOR SLOT 0
    uint96  public tempTwitter_id;          //12 BYTES, 32/32 FOR SLOT 0

    uint public _addressFromTweetMatches;

    mapping(address => uint96) public addressTwitterID;
    mapping(uint96 => address) public twitterIDaddress;

    event tweetRequestEvent();

    modifier twitterMatchesAccount(uint96 twitter_id,address checkAddress){
        require(twitterIDaddress[twitter_id] == checkAddress, "You have not verified this Twitter ID with your account yet.");
        _;
    }

    function requestTweetAddressCompare(uint96 twitter_id_Request) public {
        require(tempTwitter_id ==  0 && tempRequestAddress == address(0), "REQUEST ALREADY ACTIVE!");
        //Skip sending to oracle.
        tempTwitter_id = twitter_id_Request;
        tempRequestAddress = msg.sender;
    }

    function mockRequestAnswer(uint mockRequestReturnValue) public {
       _addressFromTweetMatches = mockRequestReturnValue;
    }

    function mockFulfillLogic() public {
        if(_addressFromTweetMatches == 1){
            if(twitterIDaddress[tempTwitter_id] != address(0)){
                addressTwitterID[twitterIDaddress[tempTwitter_id]] = 0;
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
