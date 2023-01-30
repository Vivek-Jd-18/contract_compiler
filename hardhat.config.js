require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
//contract address =  0xaD4E2c7562A7524c70bE70Ea96664396A5EC5728
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.10",
  settings: {
    allowUnlimitedContractSize: true
  },
  networks: {
    polygon: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/-jfOBYHd4XL7WHwOuEOB8UFTBS9ZHLqq",
      accounts: ["6fd8a361b032e87813c8931343e525bb6ddafd482aefe78081cb354cd43d9555"],
    },
    bsc: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: ["6fd8a361b032e87813c8931343e525bb6ddafd482aefe78081cb354cd43d9555"],
      // gas: 2100000,
      // gasPrice: 8000000000,
      allowUnlimitedContractSize: true,
    },
    binance: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      chainId: 97,
      accounts: ["6fd8a361b032e87813c8931343e525bb6ddafd482aefe78081cb354cd43d9555"],
      // gas: 9000000000,
      // gasPrice: 8000000000
      allowUnlimitedContractSize: true,
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: 'CKKB8QYUKP4WTGF2M9UYB4U14C556ZMR64'
    }
  }

};
















// { solidity: { version: "0.5.15", }