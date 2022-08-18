import { expect } from "chai"
import { ethers, network } from "hardhat"
import { Signer } from "ethers"
import { Campaign, PrestigeToken, TicketsMarketplace } from "../typechain-types"
import { nextBlock, nextTime, currentBlock, ProposalState } from "./utils"

describe("Dao works", () => {
  let john: Signer, bob: Signer, david: Signer, tyler: Signer
  let campaign: Campaign
  let token: PrestigeToken

  const delay = 2
  const duration = 5
  const description = "Let's sell some tickets with 0.068 MATIC"

  before(async () => {
    const signers = await ethers.getSigners()
    tyler = signers[0]
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
      delay,
      duration,
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
    const marketplace = await ethers.getContractAt(
      "TicketsMarketplace",
      await campaign.marketplace()
    )
    const proposedFunction = marketplace.interface.encodeFunctionData(
      "createTickets",
      ["tokenURI", 100, ethers.utils.parseEther("0.068"), 200, "matchId"]
    )

    const proposalTx = await campaign.propose(
      [marketplace.address],
      [0],
      [proposedFunction],
      description
    )

    const receipt = await proposalTx.wait(1)

    const proposalId = receipt.events![0].args![0]

    console.log("proposalId", proposalId)

    expect(await campaign.state(proposalId)).to.equal(ProposalState.Pending)

    // skip delay
    await nextBlock(delay + 1)
    expect(await campaign.state(proposalId)).to.equal(ProposalState.Active)

    // buy some tokens
    const tokenPrice = await token.tokenPrice()
    await campaign.connect(david).buyEquity(18, {
      value: ethers.BigNumber.from(String(tokenPrice.toNumber() * 18)),
    })
    expect(await token.balanceOf(await david.getAddress())).to.equal(18)

    await campaign.connect(tyler).buyEquity(3, {
      value: ethers.BigNumber.from(String(tokenPrice.toNumber() * 3)),
    })
    expect(await token.balanceOf(await tyler.getAddress())).to.equal(3)

    await campaign.connect(bob).buyEquity(1, {
      value: ethers.BigNumber.from(String(tokenPrice.toNumber() * 1)),
    })
    expect(await token.balanceOf(await bob.getAddress())).to.equal(1)

    // 1 for yes, 0 for no ?
    const tx = await campaign
      .connect(david)
      .castVoteWithReason(proposalId, 1, "That's too expensive")
      .then(_tx => _tx.wait())

    console.log("tx", tx)

    expect(await campaign.hasVoted(proposalId, await david.getAddress())).to.be
      .true

    // get quorum per proposal
    // const quorum = await campaign.quorum(proposalId)

    // get quorum
    // const quorum = await campaign.quorum(proposalId)

    // console.log("quorum", quorum)

    // const davidVoteBlock = tx.blockNumber

    // check david's votes
    // console.log(
    //   "DAVID",
    //   await campaign.getVotes(await david.getAddress(), davidVoteBlock - 1)
    // )

    console.log("votes?", await campaign.proposalVotes(proposalId))

    console.log("x", await campaign.proposalEta(proposalId))
    console.log("reached?", await campaign.quorumReached(proposalId))

    // await nextBlock(duration + 1)
    // console.log(await campaign.state(proposalId))
    console.log(await campaign.state(proposalId))

    // await nextBlock(duration + 1)

    // console.log(await campaign.state(proposalId))

    console.log("pre", await campaign.state(proposalId))

    const q = await campaign
      .queue(
        [marketplace.address],
        [0],
        [proposedFunction],
        ethers.utils.id(description)
      )
      .then(_tx => _tx.wait())

    // console.log("q", q)

    // status = await campaign.state(proposalId)

    // console.log("status", status)

    // const votes = await campaign.getVotes(
    //   await david.getAddress(),
    //   (await currentBlock()) - 1
    // )

    // console.log("votes", votes)

    // current blockNumber

    // proposalThreshold

    // status = await campaign.state(proposalId)

    // console.log("status", status)

    // await sample.set(69)

    // v = await sample.v()
    // expect(v).to.equal(69)
  })
})
