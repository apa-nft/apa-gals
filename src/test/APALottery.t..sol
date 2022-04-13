// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "ds-test/test.sol";
import "../APALottery.sol";

contract APALotteryTest is DSTest {
    APALottery public x;
    mapping (uint => bool) ids ;
    function setUp() public {
        x = new APALottery();

    }
    function testExample() public {
        x.getSeed();
        
    }

    
}
