# What is gas in Ethereum?

* 1 gas = 1 unit of fuel in processing transactions on EVM
* Each opecode consumes certain preset amount of gas. Example - REVERT (0), JUMPI (10), SELFDESTRUCT (24000), CREATE (32000), 21000 for each transaction (plain money transfer - no code) - This is detailed in Ethereum Yellow Paper

![](https://github.com/psrvere/solidity-projects/blob/master/images/etherscan_gas.png)

In above picture:
* **Gas Limit** is decided before sending the transaction (decided by compiler or wallets + user can also change this)
* **Usage by tx or Gas Used** - total gas limit used by the transaction (a transaction =  a bunch of opcodes)
* **Gas Fees** - Price of gas in Gwei. It has 3 parts
    -  **Base** - base fees in Gwei
    - **Max Priority** - max fee user wants to give to the miner. Miners will naturllay prioritise higher Max Priority Fees transactions
    - **Max** - max fees user is willing to pay for this transaction
* **Gas Price** - Base Fees + Max Priority Fees
    - [ ] Q - In what all cases a user has to pay Max Fees.
    - [ ] Q - In what all cases even Max Fees is not sufficient.
* **Tx Fees** - Gas Price x Gas Used

- [ ] to understand fees burnt and tx savings read up this later - https://eips.ethereum.org/EIPS/eip-1559