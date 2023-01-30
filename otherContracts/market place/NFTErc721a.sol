// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721A.sol";
import "./Ownable.sol";
import "./Counters.sol";
import "./ERC721URIStorage.sol";
import "./IERC721Receiver.sol";

contract NFTErc721a is ERC721URIStorage, IERC721Receiver, Ownable {
    using Counters for Counters.Counter;

    using Strings for uint256;
    uint256 public tokenId;
    uint256 public totalNFTSupply;
    string public _tokenURI;
    string public nftTokenURl;
    string private  baseTokenUri;
    string public   placeholderTokenUri;
    bool public isRevealed;

    address contractAddress;
    mapping(uint256 => string) private _tokenURIs;

    constructor(address marketplaceAddress, uint256 _maxBatchSize)
        ERC721A("NFT Trader", "NFTT", _maxBatchSize)
    {
        contractAddress = marketplaceAddress;
    }

    //Mint NFTs
    function mintNFTToken(uint256 quantity, bytes memory data,string memory _tokenURI)
        public
        returns (uint256)
    {
        _safeMint(contractAddress, quantity,data);
        _setTokenURI(tokenId, _tokenURI);
        totalNFTSupply = totalNFTSupply + quantity;
        setApprovalForAll(contractAddress, true);
        return tokenId;
    }

    //Mint NFTs
    function createNFTtoken(
        address to,
        uint256 quantity,
        bytes memory _data
    ) public returns (uint256) {
        _safeMint(to, quantity, _data);
        totalNFTSupply = totalNFTSupply + quantity;
        _setTokenURI(tokenId, _tokenURI);
        setApprovalForAll(contractAddress, true);
        return tokenId;
    }

    //Get TotalSupply of NFT
    function getTotalSupply() public view returns (uint256) {
        return totalNFTSupply;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // //return uri for certain token
    // function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    //     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

    //     uint256 trueId = tokenId + 1;

    //     if(!isRevealed){
    //         return placeholderTokenUri;
    //     }
    //     //string memory baseURI = _baseURI();
    //     return bytes(baseTokenUri).length > 0 ? string(abi.encodePacked(baseTokenUri, trueId.toString(), ".json")) : "empty";
    // }

//    //base URI Function
//     function _baseURI() internal view virtual override returns (string memory) {
//         return baseTokenUri;
//     }

    // //Set Token URI
    // function setTokenUri(string memory _baseTokenUri) external onlyOwner {
    //     baseTokenUri = _baseTokenUri;
    // }

    // function setPlaceHolderUri(string memory _placeholderTokenUri) external onlyOwner{
    //     placeholderTokenUri = _placeholderTokenUri;
    // }

    // function toggleReveal() external onlyOwner{
    //     isRevealed = !isRevealed;
    // }


}