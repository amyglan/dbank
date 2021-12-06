const Token = artifacts.require("Token");
const dBank = artifacts.require("dBank");

module.exports = async function(deployer) {
	await deployer.deploy(Token)//deploy Token

	const token = await Token.deployed()         //assign token into variable to get it's address
	
	await deployer.deploy(dBank, token.address)  //pass token address for dBank contract(for future minting)

	const dbank = await dBank.deployed()          //assign dBank contract into variable to get it's address

	await token.passMinterRole(dbank.address)	//change token's owner/minter from deployer to dBank
};