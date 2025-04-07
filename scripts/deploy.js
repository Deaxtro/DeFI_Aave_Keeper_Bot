async function main() {
  const FlashLiquidator = await ethers.getContractFactory("FlashLiquidator");
  const contract = await FlashLiquidator.deploy("0xD64dDe119f11C88850FD596BE11CE398CC5893e6"); // Sepolia Aave v3 Provider
  await contract.deployed();
  console.log("FlashLiquidator deployed to:", contract.address);
}
module.exports = main;
