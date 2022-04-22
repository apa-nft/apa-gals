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
       function expectRevert() external;
    function expectRevert(bytes calldata) external;
    function expectRevert(bytes4) external;
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

    function testCannotMintWithInsufficentFunds() public {
        uint numberOfMints = 1;
        address user = cheats.addr(12);
        uint price = APAGALS.CLAIM_PRICE();
        cheats.deal(user,  price-1 );
        cheats.prank(user);
        cheats.expectRevert(APAGals.InsufficientAmount.selector);
        APAGALS.normalMint{value:(price -1 )* numberOfMints}(numberOfMints);
    
    }

    function testWithdraw() public {
        APAGALS.setFreeMintDetails(0, 0x7d48839e90ec96279fc0c7029b182bb818348dded9ac08936b7ef825761d37e4);
        uint totalMintable = APAGALS.MAX_SUPPLY() - APAGALS.reserved();
        emit log_named_uint("totalMintable", totalMintable);
        for (uint256 index = 1; index < totalMintable; index++) {
            mint(index, 8 ether, 1);
            
        }
        mint(1123, 8 ether, 1);
        assertEq(address(APAGALS).balance, totalMintable * 2 ether );
        address user = cheats.addr(23123123);
        APAGALS.transferOwnership(user);
        cheats.prank(user);
        APAGALS.emergencyWithdraw();
        assertEq(address(user).balance, totalMintable * 2 ether);
    }

    function testFreeMint() public {
        APAGALS.setFreeMintDetails(927, 0x186cb94cb113a9c073c1b4ebe00cc65ed1ebde65d8a70c10c13947e3dbf0eff5);
        //bytes32[] memory arr =  new bytes32[](9);
        bytes32[] memory arr =  new bytes32[](10);
        arr[0] = 0x8c6ef3d456b21796978787223bb9b77fe8cf7671b31324600dbf52bb63ccdbdb;
        arr[1] = 0x8d55ea53e16c1df2abdac08bb0abda303ddd918e6df66eefa627404a946e3e7d;
        arr[2] = 0x1a7195854142b0c6931a24165c6e337ba575aa7caa957d19c055738686971bd4;
        arr[3] = 0xd9a7645fccb618a49ab993b6b592bd3717f2749f7332f3f1837c51fecf7bd037;
        arr[4] = 0x6ba2fec0ce7cbd03bb511f0cef462fd99685c354587c931b67c49ab589467633;
        arr[5] = 0x0934042b90bfe0a86f0e1e655909aa41957c0f3c6265ab170d87a5157a833259;
        arr[6] = 0x477e7462e83bf30590d13e33615aabeb177d8dd6190e272730b0fdf49554624e;
        arr[7] = 0xbc130eeeb24a489f8f48ca8ff41961dc8c37ee4d052b61b18e7f16a793451681;
        arr[8] = 0x05fd9cb7c35043386f3b8526979f1388983aa289a730726da88ced9e01429d6d;
        arr[9] = 0x95f12c140f03b99b90fbddd5436283a1ff6dd5eb3e45056e9637cba5c24422a4;
        cheats.prank(0x33eBB62DC9ddBf6B8F3C0efdF5BccC2e7AC60211);
        APAGALS.freeMint(1, 20, arr);
        cheats.prank(0x33eBB62DC9ddBf6B8F3C0efdF5BccC2e7AC60211);
        APAGALS.freeMint(9, 20, arr);

        emit log_named_uint("apagalsMinted", APAGALS.apaGalsMinted());
        
        //cheats.prank(0x33eBB62DC9ddBf6B8F3C0efdF5BccC2e7AC60211);
        //cheats.expectRevert(APAGals.Unauthorized.selector);
        //APAGALS.freeMint(1, 20, arr);
        
        //cheats.expectRevert(APAGals.Unauthorized.selector);
        //APAGALS.freeMint(1, 10, arr);

        uint totalMintable = APAGALS.MAX_SUPPLY() - APAGALS.reserved();
        emit log_named_uint("totalMintable", totalMintable);
        emit log_named_uint("reserved", APAGALS.reserved());
        for (uint256 index = 1; index < 73; index++) {
            mint(index, 8 ether, 1);
            
        }
        mint(1123, 8 ether, 1);
        //mint(1112323, 8 ether, 1);
        emit log_named_uint("apagalsMinted after", APAGALS.apaGalsMinted());


        cheats.prank(0x33eBB62DC9ddBf6B8F3C0efdF5BccC2e7AC60211);
        APAGALS.freeMint(9, 20, arr);
        cheats.prank(0x33eBB62DC9ddBf6B8F3C0efdF5BccC2e7AC60211);
        APAGALS.freeMint(1, 20, arr);
        emit log_named_uint("apagalsMinted after after", APAGALS.apaGalsMinted());
        //assertEq(address(APAGALS).balance, totalMintable * 2 ether );
        address user = cheats.addr(23123123);
        APAGALS.transferOwnership(user);
        cheats.prank(user);
        APAGALS.emergencyWithdraw();
        //assertEq(address(user).balance, totalMintable * 2 ether);
    }
    
    receive() external payable {}

    fallback() external payable {}
}


