import { ethers } from "hardhat";


async function main() {

  const getEscrowFactory = await ethers.getContractFactory("EscrowETH");
  const escrow = await getEscrowFactory.deploy();
  console.log("ETH Escrow logic Contract deployed at: " + escrow.address);

  const getEscrowProxyFactory = await ethers.getContractFactory("EscrowFactory");
  const escrowFactory = await getEscrowProxyFactory.deploy(
    escrow.address,
    "0x000000000000000000000000000000000000dEaD", // Change with desired address
    2, // Change with desired fee rate (%)
  );
  console.log("Escrow Factory Contract deployed at: " + escrowFactory.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
