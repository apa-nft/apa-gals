// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;


import "@openzeppelin/contracts/access/Ownable.sol";


interface APAGAls {
    function freeMint(
        uint256 numberOfMints,
        uint256 totalGiven,
        bytes32[] memory proof
    ) external;

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
    function safeTransferFrom( address from, address to, uint256 tokenId)  external;

}

contract RemainingMinter is Ownable {

    APAGAls apaGals;
    uint mintPrice = 3 ether;
    event mintedToken(uint i);
    error InsufficientAmount();


    constructor(address _nft_address) {
        apaGals = APAGAls(payable(_nft_address));
    }

    function mintAPAGal(uint numberOfMints, bytes32[] calldata proof, uint totalGiven) external payable {
        if (mintPrice * numberOfMints > msg.value) revert InsufficientAmount();
        apaGals.freeMint(numberOfMints, totalGiven, proof);
        for (uint256 index = 0; index < numberOfMints; index++) {
            apaGals.safeTransferFrom(address(this), msg.sender, apaGals.tokenOfOwnerByIndex(address(this),0));
        }
        
    }

    function emergencyWithdraw() external onlyOwner {
        payable(_msgSender()).transfer(address(this).balance);
    }


    function changeMintPrice(uint _mintPrice) external onlyOwner {
        mintPrice = _mintPrice;
    }

    function setNFTaddress(address _nft_address) external onlyOwner {
       apaGals = APAGAls(payable(_nft_address));
    }


}