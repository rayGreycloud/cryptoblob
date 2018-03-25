pragma solidity ^0.4.19;

import "./blobfactory.sol";
import "./ownable.sol";
import "./kittyinterface.sol";

contract BlobFeeding is BlobFactory {

  KittyInterface kittyContract;

  modifier onlyOwnerOf(uint _blobId) {
    require(msg.sender == blobToOwner[_blobId]);
    _;
  }

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Blob storage _blob) internal {
    _blob.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Blob storage _blob) internal view returns (bool) {
      return (_blob.readyTime <= now);
  }

  function feedAndMultiply(uint _blobId, uint _targetDna, string _species) internal onlyOwnerOf(_blobId) {
    Blob storage myBlob = blobs[_blobId];
    require(_isReady(myBlob));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myBlob.dna + _targetDna) / 2;
    if (keccak256(_species) == keccak256("kitty")) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createBlob("NoName", newDna);
    _triggerCooldown(myBlob);
  }

  function feedOnKitty(uint _blobId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_blobId, kittyDna, "kitty");
  }
}
