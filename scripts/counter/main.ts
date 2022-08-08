import { ethers } from 'hardhat';
import { deploy } from "../../utils"

export default async function main() {
  // const structs = await deploy("Structs", "Structs")

  // const counterUtils = await deploy("CounterUtils", "CounterUtils")

  // const counter = await deploy("Counter", "Counter", {
  //   libraries: {
  //     CounterUtils: counterUtils.tx.address,
  //   },
  // })
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());
  const Ticket = await ethers.getContractFactory("Ticket");
  const ticket = await Ticket.deploy();
  console.log("Ticket contract address" , ticket.address) ;
  const MarcketPlace = await ethers.getContractFactory("MarketPlace");
  const marcketplace = await MarcketPlace.deploy(1); 
  console.log("MarketPlace contract address" , marcketplace.address);

}

