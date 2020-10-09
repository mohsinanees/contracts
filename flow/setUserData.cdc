import WebaverseAccount from WEBAVERSEACCOUNTADDRESS

transaction {

    let state: &WebaverseAccount.State

    prepare(signer: AuthAccount) {
        self.state = signer.borrow<&WebaverseAccount.State>(from: /storage/AccountCollection)
            ?? panic("Could not borrow a reference to the account state")
    }

    execute {
        self.state.keyValueMap["ARG0"] = "ARG1"
    }
}
