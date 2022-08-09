// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract bytes32ToAddress {
    bytes32 public immutable addressBytes32TypeRight = 0x000000000000000000000000c1202e7d42655F23097476f6D48006fE56d38d4f; //TEST https://web3-type-converter.onbrn.com/
    bytes32 public immutable addressBytes32TypeLeft  = 0xc1202e7d42655F23097476f6D48006fE56d38d4f000000000000000000000000; //TEST https://web3-type-converter.onbrn.com/
    address public addressAddresType;

    //BITS ALREADY IN PLACE, USES MUCH LESS GAS AND IS RECOMMENDED. 
    function bytes32ToAddressTest() public view returns (address) { //
        return address(uint160(uint256(addressBytes32TypeRight)));
    }

    function bytes32ToAddressConvert() public { 
        addressAddresType = address(uint160(uint256(addressBytes32TypeRight)));
    }

    //USES MORE GAS SHIFTING! 
    //AVOID SINCE IT USES MORE GAS IF POSSIBLE! 
    function bytes32ToAddressTestShifted() public view returns (address) { //SHIFT 12 BYTES (96 BITS).
        return address(uint160(uint256(addressBytes32TypeLeft>>96)));
    }

    function bytes32ToAddressConvertShifted() public { 
        addressAddresType = address(uint160(uint256(addressBytes32TypeLeft>>96)));
    }
}
