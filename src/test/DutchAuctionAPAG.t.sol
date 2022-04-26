// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "ds-test/test.sol";
import "../APAGals.sol";
import "../DutchAuctionAPAG.sol";

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
       function expectRevert() external;
    function expectRevert(bytes calldata) external;
    function expectRevert(bytes4) external;
        function warp(uint256) external;
        function skip(uint256 time) external;


}

contract MinterTest is DSTest {
    
    APAGals  APAGALS;
    DutchAuctionAPAG MINTER;

    CheatCodes constant cheats = CheatCodes(HEVM_ADDRESS);
    mapping (uint => bool) ids ;
    function setUp() public {
        APAGALS = new APAGals("XX","YY","ZZ");
        APAGALS.toggleClaimability();
        APAGALS.toggleAirdropClaimability();
        APAGALS.setFreeMintDetails(955, 0x64a86c4f5c74f7c6b6f0d97092229d08d5cafd090d4075e77541625de1c310c2);
        MINTER = new DutchAuctionAPAG(address(APAGALS),10 ether, 2 ether, 1651262400, 8 );
    }

    function mint(uint userId, uint budget, uint numberOfMints) internal {
        address user = cheats.addr(userId);
        cheats.deal(user,  budget);
        uint price = APAGALS.CLAIM_PRICE();
        cheats.prank(user);
        APAGALS.normalMint{value:price* numberOfMints}(numberOfMints);
        for (uint256 index = 0; index < numberOfMints; index++) {
            uint tokenId = APAGALS.tokenOfOwnerByIndex(user, index);
            //emit log_named_uint("tokenId", tokenId);
        }
        
        assertEq(APAGALS.balanceOf(user), numberOfMints);
    }
    function atestMint() public {
        for (uint256 index = 1; index < 50 ; index++) {
            mint(index, 8 ether, 2);
        }
        mint(121, 8 ether, 1);
        mint(1221, 8 ether, 1);
        assertEq(address(APAGALS).balance, 400 ether );
        
    }



    function testFreeMint() public {
        bytes32[] memory arr =  new bytes32[](1);
        arr[0] = 0x3576257df5f094f04def2b851c4e0ad9768ba9214bca0d09fd3306ca4b14bea8;
        emit log_address(address(MINTER));
        emit log_named_uint("Minted", APAGALS.freeRedeemed(address(MINTER)));
        address user = cheats.addr(12);
        cheats.warp(1651262401 + 60 * 122);
        //cheats.skip(60 * 10);

        cheats.deal(user,  22 ether);
        cheats.prank(user);
        MINTER.mintAPAGal{value:20 ether}(2, arr, 954);
        assertEq(APAGALS.balanceOf(address(MINTER)),0);
        assertEq(APAGALS.balanceOf(user),2);
        emit log_named_uint("Minted", APAGALS.freeRedeemed(address(MINTER)));
        
    }
    
    receive() external payable {}

    fallback() external payable {}
}


