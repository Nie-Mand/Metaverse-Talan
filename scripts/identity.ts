import { deploy } from "../utils"

async function main() {
  const identity = await deploy("Identity", "Identity", {})
  return identity
}

main()
