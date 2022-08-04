import { expect } from "chai"
import { ethers } from "hardhat"
import { Signer } from "ethers"
import { IdentityIssuer } from "../typechain-types"

describe("Identity Issuer works", () => {
  let identityIssuer: IdentityIssuer
  let adam: Signer, bob: Signer

  before(async () => {
    const signers = await ethers.getSigners()
    adam = signers[0]
    bob = signers[1]
    const contract = await ethers.getContractFactory("IdentityIssuer")
    identityIssuer = await contract.deploy()
    await identityIssuer.deployed()
  })

  it("create an identity to new users", async () => {
    expect(
      identityIssuer.connect(adam).functions.signup({
        name: "Adam",
      })
    ).to.be.fulfilled

    expect(
      identityIssuer.connect(adam).functions.signup({
        name: "Paul",
      })
    ).to.be.revertedWith("You are already registered")

    const [adamsIdentity] = await identityIssuer.connect(adam).functions.login()
    const contract = await ethers.getContractAt("Identity", adamsIdentity)
    const [name] = await contract.functions.getName()
    expect(name).to.equal("Adam")
  })

  it("allow login for only identified users", () => {
    expect(identityIssuer.connect(adam).functions.login()).to.be.fulfilled
    expect(identityIssuer.connect(bob).functions.login()).to.be.revertedWith(
      "You do not have an identity"
    )
  })
})