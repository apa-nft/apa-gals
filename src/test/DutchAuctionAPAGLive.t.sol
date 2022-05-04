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
          function roll(uint256) external;


}

contract MinterLiveTest is DSTest {
    
    APAGals  APAGALS = APAGals(payable(0x7600088FB72941A9139669D7F6Cb4E717ec05C87));
    DutchAuctionAPAG MINTER = DutchAuctionAPAG(0x553beE42d9F308Aa6DB5C7dF53bDab8d649EAD00);

    CheatCodes constant cheats = CheatCodes(HEVM_ADDRESS);
    function setUp() public {

        //MINTER = new DutchAuctionAPAG(address(0x10991ecDa405C8A917AF30f49D0D1775577AD977),10 ether, 2 ether, 1651262400, 8 );
    }



    function testLiveFreeMint() public {
        uint previousOwnerBalance = (address(0xc135009C21291D72564737f276F41EE653F5c7C0).balance);
        emit log_named_uint("my balance before", previousOwnerBalance);
        uint totalRevenue = 0;
        emit log_named_uint("minted",APAGALS.apaGalsMinted());
        bool result = APAGALS.canClaim();
        assert(true == result);
        cheats.prank(0xc135009C21291D72564737f276F41EE653F5c7C0);
        APAGALS.toggleClaimability();
        result = APAGALS.canClaimAirdrop();
        assert(false == result);
        cheats.prank(0xc135009C21291D72564737f276F41EE653F5c7C0);
        APAGALS.toggleAirdropClaimability();

        
        bytes32[] memory arr =  new bytes32[](7);
        arr[0] = 0xce3b04c0a3fde6819f0fc7f1241c6916fa570fea69f27bac7ac07160b671e8e5;
        arr[1] = 0xdc128cf4f27fc58a61fdcc10d656d95705981021f0c33b5b84af623e3848a9d5;
        arr[2] = 0x4ffc2814b12e5137852940db1b7998ca0ab585ed6c8f51491d3034afc2374ec1;
        arr[3] = 0x5ebb18b266b27fbee6508bd34d18503d51afe7cde69831460357fcc468101dce;
        arr[4] = 0xdb13213441a2c2638fbbb281d2558425ffd277894a5ffcc75ce503645bcfb8ab;
        arr[5] = 0x6b184d3994dc925e19076882ceaa004a7b56c25d0bdfcadefbcaec7caf2033ac;
        arr[6] = 0xf2cdda2fe654c3850b4794201bcd08a23a5a03a9748ad1448f324a077d03752d;
        emit log_named_uint("Minted", APAGALS.freeRedeemed(address(MINTER)));
        uint timeBlock = 80 minutes / 8;
        cheats.warp(1651266000);
        assert(MINTER.getPrice() == 10 ether);
        emit log_named_uint("Price", MINTER.getPrice());

        address user = cheats.addr(123);
        cheats.deal(user,  220 ether);       
        cheats.prank(user);
        MINTER.mintAPAGal{value:30 ether}(3, arr, 300);
        assertEq(APAGALS.balanceOf(address(MINTER)),0);
        assertEq(APAGALS.balanceOf(user),3);
        emit log_named_uint("Minted", APAGALS.freeRedeemed(address(MINTER)));
        assertEq((address(MINTER).balance),30 ether);
        totalRevenue += 30 ether;


        cheats.warp(1651266000 + timeBlock);
        assert(MINTER.getPrice() == 9 ether);
        emit log_named_uint("Price", MINTER.getPrice());

        user = cheats.addr(1234);
        cheats.deal(user,  120 ether);       
        cheats.prank(user);
        MINTER.mintAPAGal{value:18 ether}(2, arr, 300);
        assertEq(APAGALS.balanceOf(address(MINTER)),0);
        assertEq(APAGALS.balanceOf(user),2);
        emit log_named_uint("Minted", APAGALS.freeRedeemed(address(MINTER)));
        totalRevenue += 18 ether;
        assertEq((address(MINTER).balance),totalRevenue);


        cheats.warp(1651266000 + timeBlock * 2);
        assert(MINTER.getPrice() == 8 ether);
        emit log_named_uint("Price", MINTER.getPrice());

        user = cheats.addr(12345);
        cheats.deal(user,  120 ether);       
        cheats.prank(user);
        MINTER.mintAPAGal{value:24 ether}(3, arr, 300);
        assertEq(APAGALS.balanceOf(address(MINTER)),0);
        assertEq(APAGALS.balanceOf(user),3);
        emit log_named_uint("Minted", APAGALS.freeRedeemed(address(MINTER)));
        totalRevenue += 24 ether;
        assertEq((address(MINTER).balance),totalRevenue);


        cheats.warp(1651266000 + timeBlock * 3);
        assert(MINTER.getPrice() == 7 ether);
        emit log_named_uint("Price", MINTER.getPrice());

        user = cheats.addr(123457);
        cheats.deal(user,  10 ether);       
        cheats.prank(user);
        MINTER.mintAPAGal{value:7 ether}(1, arr, 300);
        assertEq(APAGALS.balanceOf(address(MINTER)),0);
        assertEq(APAGALS.balanceOf(user),1);
        emit log_named_uint("Minted", APAGALS.freeRedeemed(address(MINTER)));
        totalRevenue += 7 ether;
        assertEq((address(MINTER).balance),totalRevenue);

        cheats.warp(1651266000 + timeBlock * 4);
        assert(MINTER.getPrice() == 6 ether);
        emit log_named_uint("Price", MINTER.getPrice());
        cheats.warp(1651266000 + timeBlock * 5);
        assert(MINTER.getPrice() == 5 ether);
        emit log_named_uint("Price", MINTER.getPrice());
        cheats.warp(1651266000 + timeBlock * 6);
        assert(MINTER.getPrice() == 4 ether);
        emit log_named_uint("Price", MINTER.getPrice());

        user = cheats.addr(1234257);
        cheats.deal(user,  103 ether);       
        cheats.prank(user);
        MINTER.mintAPAGal{value:20 ether}(5, arr, 300);
        assertEq(APAGALS.balanceOf(address(MINTER)),0);
        assertEq(APAGALS.balanceOf(user),5);
        emit log_named_uint("Minted", APAGALS.freeRedeemed(address(MINTER)));
        totalRevenue += 20 ether;
        assertEq((address(MINTER).balance),totalRevenue);

        cheats.warp(1651266000 + timeBlock * 7);
        assert(MINTER.getPrice() == 3 ether);
        emit log_named_uint("Price", MINTER.getPrice());

        user = cheats.addr(123425217);
        cheats.deal(user,  1023 ether);       
        cheats.prank(user);
        MINTER.mintAPAGal{value:12 ether}(4, arr, 300);
        assertEq(APAGALS.balanceOf(address(MINTER)),0);
        assertEq(APAGALS.balanceOf(user),4);
        emit log_named_uint("Minted", APAGALS.freeRedeemed(address(MINTER)));
        totalRevenue += 12 ether;
        assertEq((address(MINTER).balance),totalRevenue);

        cheats.warp(1651266000 + timeBlock * 8);
        assert(MINTER.getPrice() == 2 ether);
        emit log_named_uint("Price", MINTER.getPrice());
        cheats.warp(1651266000 + timeBlock * 9);
        assert(MINTER.getPrice() == 2 ether);
        emit log_named_uint("Price", MINTER.getPrice());


        uint APAGalsBalance = (address(APAGALS)).balance;
        emit log_named_uint("APAGALS balance before", APAGalsBalance);
        cheats.prank(0xc135009C21291D72564737f276F41EE653F5c7C0);
        APAGALS.emergencyWithdraw();

        cheats.prank(0xc135009C21291D72564737f276F41EE653F5c7C0);
        MINTER.emergencyWithdraw();
        emit log_named_uint("my balance after", (address(0xc135009C21291D72564737f276F41EE653F5c7C0).balance));
        assertEq((address(0xc135009C21291D72564737f276F41EE653F5c7C0).balance),previousOwnerBalance + totalRevenue + APAGalsBalance);

    }
    receive() external payable {}

    fallback() external payable {}
}
