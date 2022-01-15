// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("deploying with: ", deployer);

  console.log("account balance: ", (await deployer.getBalance()).toString());

  const contract = await hre.ethers.getContractFactory("GangFactory");
  const deployedContract = await contract.deploy();

  await deployedContract.deployed();

  console.log("Greeter deployed to:", deployedContract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
