import { ethers, network } from "hardhat";

// eslint-disable-next-line node/no-missing-import, camelcase
import { ONS, ONS__factory } from "../typechain";
const hre = require("hardhat");

async function main() {
  // Deploy the ONS contract.
  // eslint-disable-next-line camelcase
  const ONS: ONS__factory = await ethers.getContractFactory("ONS");
  const ons: ONS = await ONS.deploy();
  await ons.deployed();
  console.log(
    `ONS contract deployed to the ${network.name} blockchain: ${ons.address}`
  );

  // Verify the contract on https://optimistic.etherscan.io/.
  if (network.config.chainId !== 31337) {
    console.log(
      "Waiting for 5 block confirmations before verifying the contract on https://optimistic.etherscan.io/..."
    );
    await ons.deployTransaction.wait(6);

    await hre.run("verify:verify", {
      address: ons.address,
    });
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
