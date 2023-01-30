const hre = require("hardhat");

async function main() {

  // 1) deploying Minter First

  const MINTER = await hre.ethers.getContractFactory("ERAMinter");
  const Minter = await MINTER.deploy();
  await Minter.deployed();

  console.log(
    `Minter deployed with  ${Minter.address}`
  );

  // 2) deploying Handler second 

  const HANDLER = await hre.ethers.getContractFactory("ERAHandler");
  const Handler = await HANDLER.deploy(Minter.address);
  await Handler.deployed();

  console.log(
    `Handler deployed with  ${Handler.address}`
  );

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
