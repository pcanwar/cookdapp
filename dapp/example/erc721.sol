// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Storage  {

    struct Store {
        uint tokenId;
        uint price;
        bool isAvailable;
    }
    
    mapping(uint256 => Store) internal tokenIdInfo;

}

contract GetStorege is Storage {
    
    function getTokenId(uint256 _tokenId) public view returns(Store memory){
        return tokenIdInfo[_tokenId];
    }
    
    function isAvailable(uint256 _tokenId) public view returns( bool){
        return tokenIdInfo[_tokenId].isAvailable == true;
    }
}



contract NFT is ERC721, GetStorege {
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

       constructor( ) ERC721("ABC", "abc") {

    }
    
    function createToken(address marketPlace) internal returns (uint) {
        _tokenIdCounter.increment();
        uint256 newItemId = _tokenIdCounter.current();
        _safeMint(msg.sender, newItemId);
        setApprovalForAll(marketPlace, true); // set approval 
        return newItemId;
    }
    
    function mintAssets(address marketPlace ,uint256 _price) public   {
     
        uint tokenId = createToken(marketPlace);
        tokenIdInfo[tokenId] = Store(
            tokenId,
            _price,
            true
            );
        
    }
    

    
    
}


contract MarketPlace is IERC721Receiver{
    
    function sendTokenToThisContract(  uint256 tokenId, address to, address nft) public {
        IERC721(nft).transferFrom(msg.sender, address(this), tokenId);
        IERC721(nft).safeTransferFrom(address(this), to, tokenId);

    }



    function backToSender(uint256 tokenId, address nft) public {
        IERC721(nft).safeTransferFrom(address(this), msg.sender, tokenId);
    } 

 
    
    
    
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external pure override returns (bytes4){
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
    
    
}




