import { expect } from "chai"
import { ethers } from "hardhat"
import { Signer } from "ethers"
import { Identity } from "../typechain-types"

describe("Identity works", () => {
  const issuedName = "Adam"
  let identity: Identity
  let dao: Signer, adam: Signer
  let daoAddress: string, adamAddress: string

  before(async () => {
    const signers = await ethers.getSigners()
    dao = signers[0]
    adam = signers[1]
    daoAddress = await dao.getAddress()
    adamAddress = await adam.getAddress()
    const contract = await ethers.getContractFactory("Identity", dao)
    identity = await contract.deploy(adamAddress, issuedName)
    await identity.deployed()
  })

  it("should be co-owned by the creator and the identified", async () => {
    const [issuer] = await identity.functions.issuer()
    const [identified] = await identity.functions.identified()

    expect(issuer).to.equal(daoAddress)
    expect(identified).to.equal(adamAddress)
  })

  it("should has the name that was issued to it", async () => {
    const [name] = await identity.functions.getName()
    expect(name).to.equal(issuedName)
  })

  it("only the issued can change the name", async () => {
    await expect(identity.connect(adam).functions.setName("Peter")).to.be
      .fulfilled

    await expect(
      identity.connect(dao).functions.setName("Peter")
    ).to.be.revertedWith("Only the identifier can perform this action")
  })

  it("accepts metadata", async () => {
    const email = "adam@gmail.com"
    await expect(identity.connect(adam).functions.setMetadata("Email", email))
      .to.be.fulfilled

    const [_email] = await identity.connect(dao).functions.getMetadata("Email")

    await expect(_email).to.equal(email)

    await expect(
      identity.connect(dao).functions.setMetadata("Email", email)
    ).to.be.revertedWith("Only the identifier can perform this action")
  })
})
