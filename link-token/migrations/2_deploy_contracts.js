require('dotenv').config();
const LinkToken = artifacts.require('LinkToken');

module.exports = async (deployer) => {
  const OWNER = process.env.OWNER_ADDRESS;
  await deployer.deploy(LinkToken, OWNER);
  console.log('LinkToken contract address is: ', LinkToken.address);
};
