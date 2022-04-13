// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "ds-test/test.sol";
import "../APAGals.sol";

interface CheatCodes {
    function expectEmit(
        bool,
        bool,
        bool,
        bool
    ) external;
    function deal(address who, uint256 newBalance) external;
    function prank(address) external;
    function addr(uint256 privateKey) external returns (address);
}

contract APALotteryTest is DSTest {
    
    APAGals  APAGALS;
    CheatCodes constant cheats = CheatCodes(HEVM_ADDRESS);
    mapping (uint => bool) ids ;
    function setUp() public {
        APAGALS = new APAGals("XX","YY","ZZ");
        APAGALS.toggleClaimability();
        APAGALS.toggleAirdropClaimability();
    }

    function mint(uint userId, uint budget, uint numberOfMints) internal {
        address user = cheats.addr(userId);
        cheats.deal(user,  budget);
        uint price = APAGALS.CLAIM_PRICE();
        cheats.prank(user);
        APAGALS.normalMint{value:price* numberOfMints}(numberOfMints);
        for (uint256 index = 0; index < numberOfMints; index++) {
            uint tokenId = APAGALS.tokenOfOwnerByIndex(user, index);
            emit log_named_uint("tokenId", tokenId);
        }
        
        assertEq(APAGALS.balanceOf(user), numberOfMints);
    }
    function testMint() public {
        for (uint256 index = 1; index < 50 ; index++) {
            mint(index, 8 ether, 2);
        }
        mint(121, 8 ether, 1);
        mint(1221, 8 ether, 1);
        assertEq(address(APAGALS).balance, 400 ether );
        
    }

    
}
