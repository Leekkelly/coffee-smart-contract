const hre = require("hardhat");

async function main() {
  const MessageStore = await hre.ethers.getContractFactory("MessageStore");
  console.log("Deploying MessageStore...");
  const messageStore = await MessageStore.deploy();

  await messageStore.waitForDeployment();

  const address = await messageStore.getAddress();
  console.log("MessageStore deployed to:", address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });