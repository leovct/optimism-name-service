import { ethers } from "hardhat";
// eslint-disable-next-line node/no-missing-import, camelcase
import { ONS, ONS__factory } from "../typechain";

async function main() {
  // Deploy the ONS contract.
  // eslint-disable-next-line camelcase
  const ONS: ONS__factory = await ethers.getContractFactory("ONS");
  const ons: ONS = await ONS.deploy();
  await ons.deployed();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
