import { expect } from "chai"
import deployCounter from "../scripts/counter/main"
import { CounterContract } from "../@types"

describe("Counter works", () => {
  let counter: CounterContract
  before(async () => {
    const contract = await deployCounter()
    counter = contract.app as CounterContract
  })

  it("should create a counter initialized with 0", async () => {
    const initial = await counter.get()
    expect(initial).to.equal(0)
  })

  it("should increment by 1", async () => {
    const initial = await counter.get()
    await counter.increment()
    const after = await counter.get()
    expect(after).to.equal(initial + 1)
  })

  it("should decrememnt by 1", async () => {
    const initial = await counter.get()
    await counter.decrement()
    const after = await counter.get()

    expect(after).to.equal(initial - 1)
  })
})
