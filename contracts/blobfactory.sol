pragma solidity ^0.4.19;

import "./ownable.sol";
import "./safemath.sol";

contract BlobFactory is Ownable {
  
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    event NewBlob(uint blobId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Blob {
      string name;
      uint dna;
      uint32 level;
      uint32 readyTime;
      uint16 winCount;
      uint16 lossCount;
    }

    Blob[] public blobs;

    mapping (uint => address) public blobToOwner;
    mapping (address => uint) ownerBlobCount;

    function _createBlob(string _name, uint _dna) internal {
        uint id = blobs.push(Blob(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
        blobToOwner[id] = msg.sender;
        ownerBlobCount[msg.sender] = ownerBlobCount[msg.sender].add(1);
        NewBlob(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomBlob(string _name) public {
        require(ownerBlobCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createBlob(_name, randDna);
    }

}
