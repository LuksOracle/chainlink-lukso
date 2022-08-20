// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20TokenContract is ERC20("ChainLink Token", "LINK") {}

contract faucetLINK {

    address private ChainlinkTokenAddressLuksoL16 = 0xbFB26279a9D28CeC1F781808Da89eFbBfE2c4268;
    ERC20TokenContract tokenObject = ERC20TokenContract(ChainlinkTokenAddressLuksoL16);

    address public immutable relayAddress = 0x8414F1BaC5fCdA2C274A4a78D0D62109f1Cbb6C8; //UNIVERSAL PROFILE ADDRESS ON L16.
    mapping(address => uint) public userPreviousWithdrawTime;

    event faucetWithdraw();

    modifier cooldown(address cooldownUser) {
        require(block.timestamp > (userPreviousWithdrawTime[cooldownUser] + 43200), "Current user must wait 12 hours for faucet cooldown.");
        _;
    }
    
    modifier faucetFunded() {
        require(tokenObject.balanceOf(address(this)) >= 20 ether,"Faucet does not have any more LINK (has less than 20 LINK currently).");
        _;
    }

    modifier isRelay() {
        require(msg.sender == relayAddress ,"Only the relay address can access this function.");
        _;
    }

    function withdrawDirect() public faucetFunded cooldown(msg.sender) {
        userPreviousWithdrawTime[msg.sender] = block.timestamp; //Current faucet user address records current UNIX time for cooldown check. 
        tokenObject.transfer(msg.sender, 20 ether);             //Send 20 LINK to current faucet user address.
        emit faucetWithdraw();
    }
    
    function withdrawRelay(address relayCaller) public isRelay faucetFunded cooldown(relayCaller) {
        userPreviousWithdrawTime[relayCaller] = block.timestamp; //Current faucet user address records current UNIX time for cooldown check. 
        tokenObject.transfer(relayCaller, 20 ether);             //Send 20 LINK to current faucet user address.
        emit faucetWithdraw();
    }
}
