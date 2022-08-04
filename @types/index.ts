import { Contract } from "ethers"

export interface CounterContract extends Contract {
  increment(): Promise<void>
  decrement(): Promise<void>
  get(): Promise<number>
}
