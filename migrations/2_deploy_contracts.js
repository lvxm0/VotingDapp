var Vote = artifacts.require("./VotingSystem.sol");

module.exports = function(deployer) {
  deployer.deploy(Vote,[1,2,3]);
};