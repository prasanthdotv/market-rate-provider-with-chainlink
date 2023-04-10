require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

const OWNER_KEY = process.env.OWNER_KEY;
const RPC_URL = process.env.RPC_URL;

module.exports = {
  networks: {
    dev: {
      provider: new HDWalletProvider([OWNER_KEY], 'http://localhost:8545'),
      network_id: '*',
      gasPrice: 0,
      gas: '0x1ffffffffffffe',
    },
    testnet: {
      provider: new HDWalletProvider([OWNER_KEY], RPC_URL),
      network_id: '23232',
      gasPrice: 0,
      gas: '0x1ffffffffffffe',
    },
    mainnet: {
      provider: new HDWalletProvider([OWNER_KEY], RPC_URL),
      network_id: '32323',
      gasPrice: 0,
      gas: '0x1ffffffffffffe',
    },
  },

  mocha: {
    // timeout: 100000
  },

  compilers: {
    solc: {
      version: '^0.8.7', // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {
        // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200,
        },
        //  evmVersion: "byzantium"
      },
    },
  },
};
