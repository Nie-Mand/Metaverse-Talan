import { deploy } from "../../utils"

export default async function main() {
  // const structs = await deploy("Structs", "Structs")

  const counterUtils = await deploy("CounterUtils", "CounterUtils")

  const counter = await deploy("Counter", "Counter", {
    libraries: {
      CounterUtils: counterUtils.tx.address,
    },
  })

  console.log(counter.tx.address)

  return counter
}
