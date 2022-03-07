//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// Importing OpenZeppelin's ERC721 implementations
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract MerkleNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    //TokenID counter so that each NFT has a unique tokenID
    Counters.Counter private _tokenIds;

    // Bytes32 array to store the leaves of the Merkle Tree
    bytes32[] private leaves;

    // Constructor
    constructor() ERC721("Merkle", "NFT") {}

    // Mint function that is called everytime a new NFT is about to be created
    function mint(
        address receiver, // Address of the receiver - Upon successful mint, this address will own the NFT
        string memory name, // Name field = A constitutent of the on-chain tokenURI
        string memory description // Description field = A constitutent of the on-chain tokenURI
    ) public returns (uint256) {
        // Get the current tokenID
        // NFT Token IDs start from 0, i.e. the first NFT to be minted will have an ID 0
        uint256 currentTokenId = _tokenIds.current();
        // Call the _mint function of the ERC721 contract
        _mint(receiver, currentTokenId);

        // Encode the name and description to get the tokenURI
        string memory tokenURI = string(abi.encodePacked(name, description));
        // Set the tokenURI for the current tokenID
        _setTokenURI(currentTokenId, tokenURI);

        // Hash the required data to store it as a leaf of the Merkle tree
        bytes32 hash = keccak256(abi.encodePacked(msg.sender, receiver, currentTokenId, tokenURI));
        // Push the obtained hash as a new leaf of the Merkle tree
        leaves.push(hash);

        // Increase the tokenID so that the next NFT will have a unique tokenID
        _tokenIds.increment();
        // Return the tokenID of the current NFT minted
        return currentTokenId;
    }

    // A getter function to get all the leaves of the Merkle tree
    // By default, Solidity generates a getter for all public variables
    // But for an array, we can fetch a single index only using that default function
    // So, the need for this method arose
    function getAllLeaves() public view returns (bytes32[] memory) {
        return leaves;
    }
}
