import { expect } from "chai"
import { ethers } from "hardhat"
import { Signer } from "ethers"
import { Campaign, PrestigeToken } from "../typechain-types"

describe("Dao works", () => {
  let john: Signer, bob: Signer, david: Signer
  let campaign: Campaign
  let token: PrestigeToken

  before(async () => {
    const signers = await ethers.getSigners()
    john = signers[1]
    bob = signers[2]
    david = signers[3]

    const _token = await ethers
      .getContractFactory("PrestigeTokenFactory")
      .then(_ => _.deploy())
      .then(_ => _.deployed())
      .then(_ => _.address)

    const _timeLock = await ethers
      .getContractFactory("TimeLockFactory")
      .then(_ => _.deploy())
      .then(_ => _.deployed())
      .then(_ => _.address)

    const campaignFactory = await ethers
      .getContractFactory("CampaignFactory")
      .then(_ => _.deploy(_token, _timeLock))
      .then(_ => _.deployed())

    const campaignTx = await campaignFactory.createCampaign(
      "We need a job",
      1,
      1,
      69,
      ethers.utils.parseEther("0.000001"),
      666,
      20,
      {
        value: ethers.utils.parseEther("0.001"),
      }
    )
    const receipt = await campaignTx.wait()
    const address = receipt.events?.find(x => {
      return x.event == "CampainCreated"
    })!.args![1]

    campaign = await ethers.getContractAt("Campaign", address)
    token = await ethers.getContractAt("PrestigeToken", await campaign.token())
  })

  it("Can Sell tokens to users ", async () => {
    let johnsBalance = await token.balanceOf(john.getAddress())
    let campaignBalance = await token.balanceOf(campaign.address)
    expect(johnsBalance).to.equal(0)
    expect(campaignBalance).to.equal(6666666666)

    const tokenPrice = await token.tokenPrice()

    await campaign.connect(john).buyEquity(11, {
      value: ethers.BigNumber.from(String(tokenPrice.toNumber() * 11)),
    })

    johnsBalance = await token.balanceOf(john.getAddress())
    campaignBalance = await token.balanceOf(campaign.address)

    expect(johnsBalance).to.equal(11)
    expect(campaignBalance).to.equal(6666666666 - 11)

    const check = await campaign
      .connect(bob)
      .buyEquity(10000, {
        value: ethers.BigNumber.from(String(tokenPrice.toNumber() * 10000)),
      })
      .then(() => true)
      .catch(() => false)
    expect(check).to.equal(false)
  })
})
