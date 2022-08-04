import { Contract } from "ethers"

export interface CounterContract extends Contract {
  increment(): Promise<void>
  decrement(): Promise<void>
  get(): Promise<number>
}

export interface IdentityContract extends Contract {
  // CoOwnable
  issuer(): Promise<string>
  identified(): Promise<string>
  isIssuer(): Promise<boolean>
  isIdentified(): Promise<boolean>
  // IssuerTransferred

  // Identity
  name(): Promise<string>
}
