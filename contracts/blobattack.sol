pragma solidity ^0.4.19;

import "./blobhelpers.sol";

contract BlobAttack is BlobHelpers {
  
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  function attack(uint _blobId, uint _targetId) external onlyOwnerOf(_blobId) {
    Blob storage myBlob = blobs[_blobId];
    Blob storage enemyBlob = blobs[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      /* myBlob.winCount = myBlob.winCount.add(1); */
      myBlob.winCount++;
      myBlob.level = myBlob.level.add(1);
      enemyBlob.lossCount = enemyBlob.lossCount.add(1);
      feedAndMultiply(_blobId, enemyBlob.dna, "blob");
    } 
  }
}
