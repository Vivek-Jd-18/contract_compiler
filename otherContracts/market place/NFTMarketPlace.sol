// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Counters.sol";
import "./ERC721A.sol";
import "./ReentrancyGuard.sol";
import "./IERC721Receiver.sol";

contract NFTMarketPlace is ReentrancyGuard, IERC721Receiver {
    address payable owner;
    address payable contractOwner;
    bool public canPause = true;
    using Counters for Counters.Counter;
    Counters.Counter private itemId;
    Counters.Counter private itemsSold;
    uint256 public totalNFTSupply;
    uint256 price = 0;
    uint256 account;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    modifier isWhitelisted(address _address) {
        require(whitelistedAddresses[_address], "You need to be whitelisted");
        _;
    }

    struct NftMerketItem {
        address nftContract;
        uint256 id;
        uint256 tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool sold;
    }

    event NftMerketItemCreated(
        address indexed nftContract,
        uint256 indexed id,
        uint256 tokenId,
        address owner,
        address seller,
        uint256 price,
        bool sold
    );

    bool public AllowToWhiteListed = false;

    mapping(uint256 => NftMerketItem) private idForMarketItem;

    mapping(uint256 => address payable) private contractOwnerList;

    mapping(address => bool) public  whitelistedAddresses;
    address[] public WhiteArray;

    event addTowhitelisted(address indexed account);
    

    //Transfer NFT Using IERC721 function
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // Set TotalSupply of NFT
    function setTotalNFTSupply(uint256 _totalNFTSupply)
        public
        returns (uint256 __totalNFTSupply)
    {
        totalNFTSupply = _totalNFTSupply;
        return totalNFTSupply;
    }

    //Set Whitelisted Function 
    function allowToBuyForWhiteListed() public returns (bool) {
        AllowToWhiteListed = !AllowToWhiteListed;
        return AllowToWhiteListed;
    }

    //Set Price Function 
    function setPrice(uint256 _price) public returns (uint256) {
        price = _price;
        return price;
    }

    //Buy NFT Function 
    function buyNFT(address nftContract, uint256 tokenId)
        public
        payable
        nonReentrant
    {
        if (AllowToWhiteListed) {
            require(verifyUser(msg.sender), "Account is not Whitelisted");
        }
        if (price > 0) {
            owner.transfer(price);
        }
        uint256 id = itemsSold.current();
        IERC721(nftContract).transferFrom(address(this), msg.sender, id); //buy
        itemsSold.increment();
        idForMarketItem[id] = NftMerketItem(
            nftContract,
            id,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );

        emit NftMerketItemCreated(
            nftContract,
            id,
            tokenId,
            address(0),
            msg.sender,
            price,
            false
        );
    }

    //Create My purchased Nft Item

    function getMyNFTPurchased() public view returns (NftMerketItem[] memory) {
        uint256 totalItemCount = itemsSold.current();
        uint256 myItemCount = 0; //10
        uint256 myCurrentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idForMarketItem[i].owner == msg.sender) {
                myItemCount += 1;
            }
        }

        NftMerketItem[] memory nftItems = new NftMerketItem[](myItemCount); //list[3]
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idForMarketItem[i].owner == msg.sender) {
                //[1,2,3,4,5]
                uint256 currentId = i ;
                NftMerketItem storage currentItem = idForMarketItem[currentId];
                nftItems[myCurrentIndex] = currentItem;
                myCurrentIndex += 1;
            }
        }

        return nftItems;
    }

   // My Sold item count
    function getSoldNFTCount() public view returns (uint256 soldNFTCount) {
        return itemsSold.current();
    }

    // Free NFT Counter

    function getFreeNFTPurchased()
        public
        view
        returns (NftMerketItem[] memory)
    {
        uint256 totalItemCount = itemsSold.current();
        uint256 myItemCount = 0; //10
        uint256 myCurrentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idForMarketItem[i + 1].price == 0) {
                myItemCount += 1;
            }
        }

        NftMerketItem[] memory nftItems = new NftMerketItem[](myItemCount); //list[3]
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idForMarketItem[i + 1].price == 0) {
                //[1,2,3,4,5]
                uint256 currentId = i + 1;
                NftMerketItem storage currentItem = idForMarketItem[currentId];
                nftItems[myCurrentIndex] = currentItem;
                myCurrentIndex += 1;
            }
        }

        return nftItems;
    }

    //Paid NFT List
    function getPaidNFTPurchased()
        public
        view
        returns (NftMerketItem[] memory)
    {
        uint256 totalItemCount = itemId.current();
        uint256 myItemCount = 0; //10
        uint256 myCurrentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idForMarketItem[i + 1].price > 0) {
                myItemCount += 1;
            }
        }

        NftMerketItem[] memory nftItems = new NftMerketItem[](myItemCount); //list[3]
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idForMarketItem[i + 1].price > 0) {
                //[1,2,3,4,5]
                uint256 currentId = i + 1;
                NftMerketItem storage currentItem = idForMarketItem[currentId];
                nftItems[myCurrentIndex] = currentItem;
                myCurrentIndex += 1;
            }
        }

        return nftItems;
    }

    //Fetch  all unsold nft items
    function getAllUnsoldNFT() public view returns (NftMerketItem[] memory) {
        uint256 myItemCount = itemId.current() - itemsSold.current();
        uint256 myCurrentIndex = 0;

        NftMerketItem[] memory nftItems = new NftMerketItem[](myItemCount); //list[3]
        for (uint256 i = 0; i < itemId.current(); i++) {
            if (idForMarketItem[i + 1].sold == false) {
                //[1,2,3,4,5]
                uint256 currentId = i + 1;
                NftMerketItem storage currentItem = idForMarketItem[currentId];
                nftItems[myCurrentIndex] = currentItem;
                myCurrentIndex += 1;
            }
        }

        return nftItems;
    }

        function set(address userAddress) public {
        //checking if an array is empty, then insert first element without checking
        bool isFound = false;

        if(WhiteArray.length==0){
            whitelistedAddresses[userAddress] = true;
            WhiteArray.push(userAddress);
        }
        //inserting elements to array only if element is not present in an array
        else{
            for(uint i =0;i<WhiteArray.length;i++){
                if (WhiteArray[i] == userAddress){
                    isFound = true;
                    return;
                }
            }
            if(!isFound){
                WhiteArray.push(userAddress);
            }    
        }
    }
    //getting index of single user if it's present
    function getSingle(address userAddress) public view returns (uint) {
        for (uint i = 0; i <= WhiteArray.length; i++) {
            if(WhiteArray[i] == userAddress){
                return i;
            }
        }
    }

    //Verify user is Whitelisted or not 
    function verifyUser(address _whitelistedAddress)
        public
        view
        returns (bool)
    {
        bool userIsWhitelisted = whitelistedAddresses[_whitelistedAddress];
        return userIsWhitelisted;
    }

   
     function remove(address userAddress) public {
        uint tempLen;

        //getting item length 
        for(uint j=0;j<WhiteArray.length;j++){
            if(WhiteArray[j]==userAddress){
                tempLen=j;
                break;
            }
        }

        //pop element from array then shift further elements to left side to avoid  '0' in array

        for (uint i = tempLen; i < WhiteArray.length - 1; i++) {
            WhiteArray[i] = WhiteArray[i + 1];
            
        }
        WhiteArray.pop();
    }

   //getting all users array
    function getAll() public view returns (address[] memory){
        return WhiteArray;
    }

    
}
