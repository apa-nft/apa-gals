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

contract DutchAuctionAPAG is Ownable {

    uint public immutable startingPrice;
    uint public immutable discountRate;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint private constant DURATION = 80 minutes;
    uint private immutable timeBlock;
    uint public constant maxMintPerTx = 5;

    uint floorPrice;

    APAGAls apaGals;
    
    error InsufficientAmount();
    error MaxMintPerTxExceeded();
    event pricex(uint);


    constructor(address _nft_address, uint _startingPrice, uint _floorPrice, uint _startTime, uint _steps) {
        apaGals = APAGAls(payable(_nft_address));
        startingPrice = _startingPrice; // 5 AVAX
        discountRate = (_startingPrice - _floorPrice) / _steps;
        startAt = _startTime; // 1651262400
        expiresAt = _startTime + DURATION;
        timeBlock = DURATION / _steps;
        floorPrice = _floorPrice;

    }

    function mintAPAGal(uint numberOfMints, bytes32[] calldata proof, uint totalGiven) external payable {
        uint price = getPrice();
        emit pricex(price);
        if(numberOfMints > maxMintPerTx) revert MaxMintPerTxExceeded();
        if (price * numberOfMints > msg.value) revert InsufficientAmount();
        apaGals.freeMint(numberOfMints, totalGiven, proof);
        
        for (uint256 index = 0; index < numberOfMints; index++) {
            apaGals.safeTransferFrom(address(this), msg.sender, apaGals.tokenOfOwnerByIndex(address(this),0));
        }
    }

    function getPrice() public view returns (uint) {
        if(block.timestamp >= expiresAt) { return  floorPrice;}
        uint timeElapsed = block.timestamp - startAt;
        uint divison = timeElapsed / timeBlock;
        uint discount = discountRate * divison ;
        return startingPrice - discount;
    }

    function emergencyWithdraw() external onlyOwner {
        payable(_msgSender()).transfer(address(this).balance);
    }


    function changefloorPrice(uint _floorPrice) external onlyOwner {
        floorPrice = _floorPrice;
    }

    function setNFTaddress(address _nft_address) external onlyOwner {
       apaGals = APAGAls(payable(_nft_address));
    }


}



