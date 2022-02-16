# Transfer vs Send vs Call

## Outline

- receive() payable function
- fallback() payable function
- payable() only one explicit conversion allowed at a time - 0.8.0 breaking change
- Transfer, Send and Call  - formats, return values, opcodes and gas used
- Reentrancy safeguard
- check implementations in a few big protocols like Uniswap, AAVE

## Links

- https://solidity-by-example.org/sending-ether/
- https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/
