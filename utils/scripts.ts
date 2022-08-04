import { ethers } from "hardhat"
import { FactoryOptions } from "./types"

export async function deploy(
  _contract: string,
  _label: string,
  _options: FactoryOptions = {}
) {
  const contract = await ethers.getContractFactory(_contract, _options)
  const app = await contract.deploy()
  const tx = await app.deployed()
  console.log(`${_label} deployed to: ${tx.address}`)
  return { tx, app }
}
