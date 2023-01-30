const hre = require("hardhat");

async function main() {

  // 1) deploying Minter First

  const MINTER = await hre.ethers.getContractFactory("ERA");
  const Minter = await MINTER.deploy();
  await Minter.deployed();

  console.log(
    `Era deployed with  ${Minter.address}`
  );

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
