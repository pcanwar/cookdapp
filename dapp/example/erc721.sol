// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// Counters is used for only be incremented, decremented or reset
import "@openzeppelin/contracts/utils/Counters.sol";
// ERC721 standard 
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// to check that the receiver is an IERC721Receiver 
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";


// Storage contract only contains the data logic.
contract Storage  {
    struct Store {
        uint tokenId; // nft id, this will be incremented
        uint price; 
        bool isAvailable;
    }
    
    // each Store has uint 
    mapping(uint256 => Store) internal tokenIdInfo;

}

// GetStorege has a getter function and if the item is available for sale or etc..
contract GetStorege is Storage {
    
    function getTokenId(uint256 _tokenId) public view returns(Store memory){
        return tokenIdInfo[_tokenId];
    }
    
    function isAvailable(uint256 _tokenId) public view returns( bool){
        return tokenIdInfo[_tokenId].isAvailable == true;
    }
}

// use ERC721 standard from openzeppelin, each token id or nft has 
contract NFT is ERC721, GetStorege {
    

    // contrainer 
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter; // tokenId from Counters file that is imported
       constructor( ) ERC721("ABC", "abc") {

    }
    

    // create nft, this function is internal no one can interact with it publicly
    // marketPlace is a different contract that will hold nft if there is a sale 
    function createToken(address marketPlace) internal returns (uint) {
        _tokenIdCounter.increment();// increase token id
        uint256 newItemId = _tokenIdCounter.current(); // return the current value or the 
        // the number of elements in a mapping
        _safeMint(msg.sender, newItemId); // _safeMint is from ERC721 to mint a new token to the caller of this function
        setApprovalForAll(marketPlace, true); // set approval to marketPlace contract address
        return newItemId; // retrun the token id
    }
    

    // public function to mint an nft
    // _price of nft
    // smart contact address of marketPlace
    function mintAssets(address marketPlace ,uint256 _price) public   {
     
        uint tokenId = createToken(marketPlace);
        tokenIdInfo[tokenId] = Store(
            tokenId,
            _price,
            true
            );
        
    }
    

    
    
}

// marketPlace uses IERC721Receiver for receiving the token nft id.
// 
contract MarketPlace is IERC721Receiver{
    
    // send token id to this contract using 
    // tokenId is nft token id
    //  nft is NFT contract address 
    // to : the receiver of the nft token
    function sendTokenToThisContract(  uint256 tokenId, address to, address nft) public {
        IERC721(nft).transferFrom(msg.sender, address(this), tokenId);
        IERC721(nft).safeTransferFrom(address(this), to, tokenId);

    }


    // 
    // send token id to the caller of this function  
    // tokenId is nft token id
    // nft is NFT contract address 
    function backToSender(uint256 tokenId, address nft) public {
        IERC721(nft).safeTransferFrom(address(this), msg.sender, tokenId);
    } 
    
    // ( the receiving contract ) is to make this contract aware of implementing that the token id you are going to transfer,
    // token id is going to be safe and it will be able to be transfered out.
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external pure override returns (bytes4){
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
    
    
}




