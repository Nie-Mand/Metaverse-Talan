import { Signer } from "ethers"
interface Libraries {
  [libraryName: string]: string
}

export interface FactoryOptions {
  signer?: Signer
  libraries?: Libraries
}
