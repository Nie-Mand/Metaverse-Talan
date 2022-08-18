import { deploy } from "../utils"

export default async function main() {
  // const prestigeTokenFactory = await deploy(
  //   "PrestigeTokenFactory",
  //   "PrestigeTokenFactory"
  // )
  // const timeLockFactory = await deploy("TimeLockFactory", "TimeLockFactory")
  const ticketsMarketplaceFactory = await deploy(
    "TicketsMarketplaceFactory",
    "TicketsMarketplaceFactory"
  )

  await deploy(
    "CampaignFactory",
    "CampaignFactory",
    {},
    "0x4B08F154ff47eA63Da4922fB8D646A8B27bCF48d",
    "0x3999f1DD6a6C5051CcD46b60903B400F99E14dbc",
    "0x99afd3fFE153bdfA1e7cb03eCEbCf7F7712cb8ED"
    //   ticketsMarketplaceFactory.tx.address
    //   // prestigeTokenFactory.tx.address,
    //   // timeLockFactory.tx.address
  )
}

main()
