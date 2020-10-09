import FungibleToken from FUNGIBLETOKENADDRESS
import WebaverseToken from WEBAVERSETOKENADDRESS

transaction {
  let tokenAdmin: &WebaverseToken.Administrator
  let tokenReceiver: &{FungibleToken.Receiver}

  prepare(signer: AuthAccount) {
      let recipient : Address = ARG0
  
      self.tokenAdmin = signer
      .borrow<&WebaverseToken.Administrator>(from: /storage/tokenAdmin) 
      ?? panic("Signer is not the token admin")

      self.tokenReceiver = getAccount(recipient)
      .getCapability(/public/exampleTokenReceiver)!
      .borrow<&{FungibleToken.Receiver}>()
      ?? panic("Unable to borrow receiver reference")
  }

  execute {
      let amount : UFix64 = ARG1
      let minter <- self.tokenAdmin.createNewMinter(allowedAmount: amount)
      let mintedVault <- minter.mintTokens(amount: amount)

      self.tokenReceiver.deposit(from: <-mintedVault)

      destroy minter
  }
}
