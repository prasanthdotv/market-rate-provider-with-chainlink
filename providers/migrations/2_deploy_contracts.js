const MarketRateProvider = artifacts.require('MarketRateProvider');
const CPIProvider = artifacts.require('CPIProvider');

module.exports = async (deployer) => {
  const LINK_TOKEN = process.env.LINK_TOKEN;
  const OWNER_ADDRESS = process.env.OWNER_ADDRESS;

  await deployer.deploy(MarketRateProvider, OWNER_ADDRESS, LINK_TOKEN);
  console.log('MarketRateProvider contract address is: ', MarketRateProvider.address);

  await deployer.deploy(CPIProvider, OWNER_ADDRESS, LINK_TOKEN);
  console.log('CPIProvider contract address is: ', CPIProvider.address);
};
