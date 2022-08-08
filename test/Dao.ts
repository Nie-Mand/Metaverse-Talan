import { expect } from "chai"
import { ethers } from "hardhat"
import { Signer } from "ethers"
import { DaoToken } from "../typechain-types"

describe("Dao works", () => {
  let john: Signer, bob: Signer, david: Signer
  let daoToken: DaoToken

  before(async () => {
    const signers = await ethers.getSigners()
    john = signers[0]
    bob = signers[1]
    david = signers[2]
    const contract = await ethers.getContractFactory("DaoToken", john)
    daoToken = await contract.deploy()
    await daoToken.deployed()
  })

  it("has a working governance token, META", async () => {
    const [name] = await daoToken.functions.name()
    const [symbol] = await daoToken.functions.symbol()

    expect(name).to.equal("MetaDaoToken")
    expect(symbol).to.equal("META")

    await expect(daoToken.functions.transfer(bob.getAddress(), 69)).to.be
      .fulfilled

    const [balance] = await daoToken.functions.balanceOf(bob.getAddress())
    expect(balance).to.equal(69)

    await expect(
      daoToken.connect(bob).functions.approve(david.getAddress(), 11)
    ).to.be.fulfilled

    const [allowance] = await daoToken.functions.allowance(
      bob.getAddress(),
      david.getAddress()
    )

    expect(allowance).to.equal(11)

    await expect(
      daoToken
        .connect(david)
        .functions.transferFrom(bob.getAddress(), john.getAddress(), 10)
    ).to.be.fulfilled
  })
})
