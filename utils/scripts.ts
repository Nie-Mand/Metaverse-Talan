import { ethers } from "hardhat"
import { FactoryOptions } from "./types"

export async function deploy(
  _contractName: string,
  _label: string,
  _options: FactoryOptions = {},
  ..._args: any[]
) {
  const contract = await ethers.getContractFactory(_contractName, _options)
  const app = await contract.deploy(..._args)
  const tx = await app.deployed()
  console.log(`${_label} deployed to: ${tx.address}`)
  return { tx, app }
}
