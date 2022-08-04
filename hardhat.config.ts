import { HardhatUserConfig } from "hardhat/config"
import "@nomicfoundation/hardhat-toolbox"
import "dotenv/config"

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    matic: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [process.env.MUMBAI_PRIVATE_KEY || ""],
    },
  },
}

export default config
