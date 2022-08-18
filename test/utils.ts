import { expect } from "chai"
import { ethers, network } from "hardhat"
import { Signer } from "ethers"

export async function nextBlock(n = 1) {
  while (n--) {
    await network.provider.request({
      method: "evm_mine",
      params: [],
    })
  }
}

export function nextTime() {
  return network.provider.send("evm_increaseTime", [1])
}

export function currentBlock() {
  return ethers.provider.getBlockNumber()
}

export enum ProposalState {
  Pending = 0,
  Active = 1,
  Canceled = 2,
  Defeated = 3,
  Succeeded = 4,
  Queued = 5,
  Expired = 6,
  Executed = 7,
}
