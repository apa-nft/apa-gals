// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";


contract APAGals is
    ERC721Enumerable,
    ReentrancyGuard,
    Ownable
{

    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public reserved = 900;
    uint256 public apaGalsMinted = 0;
    uint256 public constant MAX_PER_CLAIM = 5;
    uint256 public constant CLAIM_PRICE = 4 ether;

    bool public canClaim = false;
    bool public canClaimAirdrop = false;
    uint256 public numHonoraries = 0;
    mapping(uint256 => uint256) indexer;

    bytes32 freeMerkleRoot;
    mapping(address => uint256) public freeRedeemed;

    string baseURI = "https://partyanimals.xyz/apagals/id/";

    event UnlabeledData(string key, uint256 tokenId);


    

    error MintLimit();
    error InsufficientAmount();
    error Unauthorized();
    error ReservedAmountInvalid();

    
    /*///////////////////////////////////////////////////////////////
                            FUTURE CONTENT RELATED
    //////////////////////////////////////////////////////////////*/

    mapping(string => mapping(uint256 => bytes32)) public unlabeledData;
    mapping(address => bool) public contractAuthorities;

    modifier onlyOwnerOrContractAuthority() {
        if (msg.sender != owner() && !contractAuthorities[msg.sender]) revert Unauthorized();
        _;
    }

    function setData(
        string calldata _key,
        uint256 _tokenId,
        bytes32 _data
    ) external onlyOwnerOrContractAuthority {
        unlabeledData[_key][_tokenId] = _data;

        emit UnlabeledData(_key, _tokenId);
    }

    function unsetData(string calldata _key, uint256 _tokenId)
        external
        onlyOwnerOrContractAuthority
    {
        delete unlabeledData[_key][_tokenId];
    }

    function getData(string calldata _key, uint256 _tokenId)
        external
        view
        returns (bytes32)
    {
        return unlabeledData[_key][_tokenId];
    }


    function addcontractAuthorities(address[] calldata _contractAuthorities) external onlyOwner {
        uint256 length = _contractAuthorities.length;
        for (uint256 i; i < length; ) {
            contractAuthorities[_contractAuthorities[i]] = true;
            unchecked {
                ++i;
            }
        }
    }

    function removeContractAuthority(address _contractAuthority) external onlyOwner {
        delete contractAuthorities[_contractAuthority];
    }




    /*///////////////////////////////////////////////////////////////
                            APA GAL MINTING
    //////////////////////////////////////////////////////////////*/

    function _handleMint(uint256 numberOfMints) internal {
        // solhint-disable-next-line
        unchecked {
            uint256 totalAPAGals = apaGalsMinted + numberOfMints;
            if (
                numberOfMints > MAX_PER_CLAIM ||
                totalAPAGals > (MAX_SUPPLY - reserved)
            ) revert MintLimit();

            _mintApaGals(numberOfMints, totalAPAGals - numberOfMints);
            apaGalsMinted = totalAPAGals;
        }
    }

    function _mintApaGals(uint256 numberOfMints, uint256 totalApagalsBefore)
        internal
    {
        uint256 seed = enoughRandom();

        uint256 _indexerLength;
        unchecked {
            _indexerLength = MAX_SUPPLY - totalApagalsBefore;
        }

        for (uint256 i; i < numberOfMints; ) {
            seed >>= i;

            // Find the next available tokenID
            //slither-disable-next-line weak-prng
            uint256 index = seed % _indexerLength;
            uint256 tokenId = indexer[index];

            if (tokenId == 0) {
                tokenId = index;
            }

            // Swap the picked tokenId for the last element
            unchecked {
                --_indexerLength;
            }

            uint256 last = indexer[_indexerLength];
            if (last == 0) {
                // this _indexerLength value had not been picked before
                indexer[index] = _indexerLength;
            } else {
                // this _indexerLength value had been picked and swapped before
                indexer[index] = last;
            }

            // Mint Hopper and generate its attributes
            _mint(msg.sender, tokenId);
            unchecked {
                ++i;
            }
        }
    }

    function normalMint(uint256 numberOfMints) external payable {
        require(canClaim);
        if (CLAIM_PRICE * numberOfMints > msg.value) revert InsufficientAmount();

        _handleMint(numberOfMints);
    }

    function freeMint(
        uint256 numberOfMints,
        uint256 totalGiven,
        bytes32[] memory proof
    ) external {
        require(canClaimAirdrop);
        if (freeRedeemed[msg.sender] + numberOfMints > totalGiven)
            revert Unauthorized();
        if (reserved < numberOfMints) revert ReservedAmountInvalid();
        if (
            !MerkleProof.verify(
                proof,
                freeMerkleRoot,
                keccak256(abi.encodePacked(msg.sender, totalGiven))
            )
        ) revert Unauthorized();

        unchecked {
            freeRedeemed[msg.sender] += numberOfMints;
            reserved -= numberOfMints;
        }

        _handleMint(numberOfMints);
    }

    /*///////////////////////////////////////////////////////////////
                            AIRDROPS
    //////////////////////////////////////////////////////////////*/
    function addHonoraries(address[] calldata honoraries) external onlyOwner {
        uint256 honoraryID = numHonoraries + MAX_SUPPLY;
        for (uint256 i = 0; i < honoraries.length; i++) {
            _mint(honoraries[i], honoraryID);
            honoraryID += 1;
        }

        numHonoraries += honoraries.length;
    }

    function setFreeMintDetails(uint256 _reserved, bytes32 _root)
        external
        onlyOwner
    {
        require(apaGalsMinted + _reserved <= MAX_SUPPLY);
        reserved = _reserved;
        freeMerkleRoot = _root;
    }

    function getClaimedFreeMints(address account)
        external
        view
        returns (uint256)
    {
        return freeRedeemed[account];
    }

    /*///////////////////////////////////////////////////////////////
                            ERC721
    //////////////////////////////////////////////////////////////*/

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return string(bytes.concat(bytes(baseURI), bytes(_toString(tokenId))));
    }

    function setBaseUri(string memory uri) external onlyOwner {
        baseURI = uri;
    }



    function _toString(uint256 value) internal pure returns (string memory) {
        //slither-disable-next-line incorrect-equality
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            //slither-disable-next-line weak-prng
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function enoughRandom() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        // solhint-disable-next-line
                        block.timestamp,
                        msg.sender,
                        blockhash(block.number)
                    )
                )
            );
    }



    /*///////////////////////////////////////////////////////////////
                            MARKETPLACE MANAGEMENT
    //////////////////////////////////////////////////////////////*/

    function emergencyWithdraw() external onlyOwner {
        payable(_msgSender()).transfer(address(this).balance);
    }


    function toggleClaimability() external onlyOwner {
        canClaim = !canClaim;
    }

    function toggleAirdropClaimability() external onlyOwner {
        canClaimAirdrop = !canClaimAirdrop;
    }

    receive() external payable {}

    fallback() external payable {}


    /// @inheritdoc	ERC165
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    constructor(
        string memory nftName,
        string memory nftSymbol,
        string memory baseTokenURI
    ) ERC721(nftName, nftSymbol) Ownable() {
        baseURI = baseTokenURI;

    }
}