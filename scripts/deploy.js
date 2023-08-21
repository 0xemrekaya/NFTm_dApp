
const hre = require("hardhat");

async function main() {

    const nftm = await hre.ethers.deployContract("NFTCreator");
  
    await nftm.waitForDeployment();
    const result = await nftm.getAddress();
  
    console.log("Contract deployed to: ", result);
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});