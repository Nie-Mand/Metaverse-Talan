import { expect } from "chai"
import { ethers, network } from "hardhat"
import { Signer } from "ethers"
import { Campaign, PrestigeToken } from "../typechain-types"

async function nextBlock(n: number = 1) {
  while (n--) {
    await network.provider.request({
      method: "evm_mine",
      params: [],
    })
  }
}

function nextTime() {
  return network.provider.send("evm_increaseTime", [1])
}

function currentBlock() {
  return ethers.provider.getBlockNumber()
}

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

    const _marketplace = await ethers
      .getContractFactory("TicketsMarketplaceFactory")
      .then(_ => _.deploy())
      .then(_ => _.deployed())
      .then(_ => _.address)

    const campaignFactory = await ethers
      .getContractFactory("CampaignFactory")
      .then(_ => _.deploy(_token, _timeLock, _marketplace))
      .then(_ => _.deployed())

    const campaignTx = await campaignFactory.createCampaign(
      "We need a job",
      2,
      3,
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

  it("Handles Proposals", async () => {
    const sample = await ethers
      .getContractFactory("SampleContract")
      .then(_ => _.deploy())
      .then(_ => _.deployed())

    const proposedFunction = sample.interface.encodeFunctionData("set", [69])

    const proposalTx = await campaign.propose(
      [sample.address],
      [0],
      [proposedFunction],
      "Let's change the value into 69"
    )

    const receipt = await proposalTx.wait(1)

    const proposalId = receipt.events![0].args![0]

    let status = await campaign.state(proposalId)

    console.log("status", status)

    const tokenPrice = await token.tokenPrice()

    await campaign.connect(david).buyEquity(20, {
      value: ethers.BigNumber.from(String(tokenPrice.toNumber() * 20)),
    })

    console.log(await token.balanceOf(await david.getAddress()))
    await nextBlock(1)

    const tx = await campaign.connect(david).castVote(proposalId, 1) // 1 for yes, 0 for no ?

    await tx.wait()

    status = await campaign.state(proposalId)

    console.log("status", status)

    await nextBlock(3)

    status = await campaign.state(proposalId)

    console.log("status", status)

    const votes = await campaign.getVotes(
      await david.getAddress(),
      (await currentBlock()) - 1
    )

    console.log("votes", votes)

    // current blockNumber

    // proposalThreshold

    // status = await campaign.state(proposalId)

    // console.log("status", status)

    // await sample.set(69)

    // v = await sample.v()
    // expect(v).to.equal(69)
  })
})
