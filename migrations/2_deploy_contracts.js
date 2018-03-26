let BlobOwnership = artifacts.require("./blobownership.sol");

module.exports = function(deployer) {
  deployer.deploy(BlobOwnership);
}
