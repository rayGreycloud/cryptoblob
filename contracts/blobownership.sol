pragma solidity ^0.4.19;

import "./blobattack.sol";
import "./erc721.sol";
import "./safemath.sol";


contract BlobOwnership is BlobAttack, ERC721 {
  
  using SafeMath for uint256; 
  
  mapping (uint => address) blobApprovals;

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerBlobCount[_owner];
  }
  
  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return blobToOwner[_tokenId];
  }
  
  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerBlobCount[_to] = ownerBlobCount[_to].add(1);
    ownerBlobCount[_from] = ownerBlobCount[_from].sub(1);
    blobToOwner[_tokenId] = _to;
    
    Transfer(_from, _to, _tokenId);
  }
  
  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }
  
  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    blobApprovals[_tokenId] = _to;
    
    Approval(msg.sender, _to, _tokenId);
  }
  
  function takeOwnership(uint256 _tokenId) public {
    require(blobApprovals[_tokenId] == msg.sender);
    
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }
}
