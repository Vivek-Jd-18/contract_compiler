const hre = require("hardhat");

async function main() {

  // 1) deploying Minter First

  // const MINTER = await hre.ethers.getContractFactory("ERA");
  const Factory = await hre.ethers.getContractFactory('Factory');
  const Router = await hre.ethers.getContractFactory('Router');
  const Pair = await hre.ethers.getContractFactory('Pair');
  const Token1 = await hre.ethers.getContractFactory('Token1');
  const Token2 = await hre.ethers.getContractFactory('Token2');
  const bitcone = await hre.ethers.getContractFactory('bitcone');

  const bitconeAddress = "0x3C4F015BBd5CF17bD122fc0851f9a14eE70b0706"

  //addresses
  const pancakeFactoryAddress = "0x6725F303b657a9451d8BA641348b6761A6CC7a17";
  const pancakeRouterAddress = "0xD99D1c33F9fC3444f8101754aBC46c52416550D1";

  // const Minter = await MINTER.deploy();
  // await Minter.deployed();


  // const [admin, _] = await web3.eth.getAccounts();

  //ref// const factory = await Factory.at('0x6725F303b657a9451d8BA641348b6761A6CC7a17');
  const pancakeFactory = await hre.ethers.getContractAt("Factory", pancakeFactoryAddress);
  console.log("pancake Factory fetched with address : ",pancakeFactory)
  
  //ref// const router = await Router.at('0xD99D1c33F9fC3444f8101754aBC46c52416550D1');
  const pancakeRouter = await hre.ethers.getContractAt("Router", pancakeRouterAddress);
  console.log("pancake Router fetched with address : ",pancakeRouter)
  
  const bitconeCtr = await hre.ethers.getContractAt("bitcone", bitconeAddress);
  console.log("pancake Factory fetched with address : ",pancakeFactory)

  // const token1 = await Token1.new();
  const token1 = await Token1.deploy();
  await token1.deployed();
  console.log("token 1 address is : ", token1.address)

  // const token2 = await Token2.new();
  const token2 = await Token2.deploy();
  await token2.deployed();
  console.log("token 2 address is : ", token2.address)

  //calling factor's createPair()
  const pairAddress = await pancakeFactory.createPair(token1.address, bitconeAddress);
  console.log("pairAddress response : ", pairAddress);
  
  
  const tx = await pancakeFactory.createPair(token1.address, bitconeAddress);
  console.log("tx response : ", tx);
  
  await token1.approve(pancakeRouter.address, 10000);
  await bitconeCtr.approve(pancakeRouter.address, 10000);

  console.log("both approval done!  :-) ");


  // const addToLiquidityRepsonse = await pancakeRouter.addLiquidity(
  //   token1.address,
  //   token2.address,
  //   10000,
  //   10000,
  //   10000,
  //   10000,
  //   "0x20845c0782D2279Fd906Ea3E3b3769c196032C46",
  //   Math.floor(Date.now() / 1000) + 60 * 10
  // );
  // console.log("addLiquidity .-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.- ",addLiquidity);
  
  //ref // const pair = await Pair.at(pairAddress);
  const pancakePair = await hre.ethers.getContractAt("Pair", pancakeFactoryAddress);
  console.log("pancakePair .-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.- ",pancakePair);
  
  const walletAddress = "0x20845c0782D2279Fd906Ea3E3b3769c196032C46";
  const balance = await pancakePair.balanceOf(walletAddress);

  console.log(`balance LP: ${balance.toString()}`);



  // console.log(
  //   `Era deployed with  ${Minter.address}`
  // );

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});




































////////////////////////// truffle code


// const Factory = artifacts.require('Factory.sol');
// const Router = artifacts.require('Router.sol');
// const Pair = artifacts.require('Pair.sol');
// const Token1 = artifacts.require('Token1.sol');
// const Token2 = artifacts.require('Token2.sol');

// module.exports = async done => {
//   try {
//     const [admin, _] = await web3.eth.getAccounts();
//     const factory = await Factory.at('0x6725F303b657a9451d8BA641348b6761A6CC7a17');
//     const router = await Router.at('0xD99D1c33F9fC3444f8101754aBC46c52416550D1');
//     const token1 = await Token1.new();
//     const token2 = await Token2.new();
//     const pairAddress = await factory.createPair.call(token1.address, token2.address);
//     const tx = await factory.createPair(token1.address, token2.address);
//     await token1.approve(router.address, 10000);
//     await token2.approve(router.address, 10000);
//     await router.addLiquidity(
//       token1.address,
//       token2.address,
//       10000,
//       10000,
//       10000,
//       10000,
//       admin,
//       Math.floor(Date.now() / 1000) + 60 * 10
//     );
//     const pair = await Pair.at(pairAddress);
//     const balance = await pair.balanceOf(admin);
//     console.log(`balance LP: ${balance.toString()}`);
//   } catch (e) {
//     console.log(e);
//   }
//   done();
// };