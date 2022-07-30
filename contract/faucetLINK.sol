// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20TokenContract is ERC20("ChainLink Token", "LINK") {}

contract faucetLINK {

    address private ChainlinkTokenAddressRinkeby = 0xbFB26279a9D28CeC1F781808Da89eFbBfE2c4268;
    ERC20TokenContract tokenObject = ERC20TokenContract(ChainlinkTokenAddressRinkeby);

    mapping(address => uint) public withdrawAddress;

    event transferLINK();

    modifier cooldown() {
        require(block.timestamp > (withdrawAddress[msg.sender] + 43200), "Current user must Wait 12 hours for facuet cooldown.");
        _;
    }
    
    modifier faucetFunded() {
        require(tokenObject.balanceOf(address(this)) >= 20 ether,"Faucet does not have any more LINK (has less than 20 LINK currently).");
        _;
    }

    function withdraw() public cooldown faucetFunded {
        withdrawAddress[msg.sender] = block.timestamp; //Current time.
        tokenObject.transfer(msg.sender, 20 ether);    //Send 10 LINK to user.
        emit transferLINK();
    }
    
}
