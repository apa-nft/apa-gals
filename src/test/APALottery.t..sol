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
        x.roll();
        
    }

    function roll() internal {
        for (uint16 index = 1; index < 900; index++) {     
            uint rnd = ( enoughRandom(index)) % 10000;
            emit log_uint(rnd);
            ids[rnd] = true;
        }
    }

    function enoughRandom(uint16 i) internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        // solhint-disable-next-line
                        block.timestamp,
                        msg.sender,
                        blockhash(block.number),i
                    )
                )
            );
    }
}
