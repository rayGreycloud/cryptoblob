pragma solidity ^0.4.19;

import "./blobfeeding.sol";
import "./safemath.sol";

contract BlobHelpers is BlobFeeding {

  using SafeMath32 for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _blobId) {
    require(blobs[_blobId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }
  
  function levelUp(uint _blobId) external payable {
    require(msg.value == levelUpFee);
    uint32 _level = blobs[_blobId].level.add(1);
    blobs[_blobId].level = _level;
  }  

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function changeName(uint _blobId, string _newName) external aboveLevel(2, _blobId) onlyOwnerOf(_blobId) {
    blobs[_blobId].name = _newName;
  }

  function changeDna(uint _blobId, uint _newDna) external aboveLevel(20, _blobId) onlyOwnerOf(_blobId) {
    blobs[_blobId].dna = _newDna;
  }

  function getBlobsByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerBlobCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < blobs.length; i++) {
      if (blobToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
