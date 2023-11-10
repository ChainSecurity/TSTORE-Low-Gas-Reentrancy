# TSTORE Reentrancy Experiments

The current specification of TSTORE (see [EIP-1153](https://eips.ethereum.org/EIPS/eip-1153)) introduces a new reentrancy attack vector using transient storage. This repository implements examples to illustrate the potential vulnerabilities. Hence, these contracts are for educational purpose only and should not be used.

For full details check the blog article at: https://chainsecurity.com/tstore-low-gas-reentrancy/

Thanks to our engineers @ritzdorf and @kenijiva for preparing the examples.

## Installation & Running

1. We use vyper and ape. Please follow the [ape installation guide](https://docs.apeworx.io/ape/stable/userguides/quickstart.html#installation) for advice on installing ape.
2. If necessary install dotenv using `pip install python-dotenv`
3. You'll need have an account ready for ape. In `.env_template`, we define the account to be aliased as `testing`. You can change that to your needs. Create a `.env` file according to your alias (or simply rename). However, we suggest using an account dedicated for testing purposes. Follow the [ape live network account tutorial](https://docs.apeworx.io/ape/stable/userguides/accounts.html#live-network-accounts) for more information.
4. We'll be running our script on a live testing network. From [here](https://github.com/ethpandaops/dencun-testnet), take the latest testnet network. At the time of writing, it was [this](https://dencun-devnet-11.ethpandaops.io/) which we'll be using below.
5. Drop the faucet to the address of the testing account you'll be using.
6. Run the script. Replace `<script_name>` with the script you want to run.
    ```bash
    ape run scripts/<script_name> --network https://rpc.dencun-devnet-11.ethpandaops.io
    ```

Note that you'll be signing data. Please make sure you understand what the scripts are doing - especially since the "autosign" flag for ape will be set to true. Hence, you'll be receiving the following warning after entering your passphrase:

```bash
WARNING: Danger! This account will now sign any transaction it's given.
```

## The Examples

### Simple Example

This is a simple example showing a basic reentrancy using just 2300 gas.

### EthLocker

This is a locker contract managing ETH which allows a more gas-efficient temporary balance where settling appears at the end of the transaction. However, reentrancies are possible.

### NewWETH

This is slightly changed Wrapped ETH contract, where the `temporaryApprove` function is implemented as suggested in the EIP. However, the function `withdrawAllTempFrom` which makes use of the temporarily allowance is vulnerable.

## Results
### Simple Example

```bash
Logged value: 1234
```

### NewWeth

```bash
WETH.balance: 0
Callee.balance: 100000000000000000
WETH.balanceOf(Caller): 100000000000000000
[{'address': '0x0BF2074D83C16F0EcAB3671BA20a62C46217b69f', 'topics': [HexBytes('0xe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c'), HexBytes('0x000000000000000000000000f69c2ccac48189a25c4dfbca0053e3e190c0006a')], 'data': HexBytes('0x000000000000000000000000000000000000000000000000016345785d8a0000'), 'blockNumber': 56114, 'transactionHash': HexBytes('0x66e130f93bd2b3aba4ca607421156e008afaf8ba0fda38f0569049bc34c5b39c'), 'transactionIndex': 0, 'blockHash': HexBytes('0x554b6aeddfd8c31d3d163a12cad5b01353b481d70689eb33ca29218187855b10'), 'logIndex': 0, 'removed': False}, {'address': '0x0BF2074D83C16F0EcAB3671BA20a62C46217b69f', 'topics': [HexBytes('0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'), HexBytes('0x000000000000000000000000f69c2ccac48189a25c4dfbca0053e3e190c0006a'), HexBytes('0x000000000000000000000000ddafb6eb07b57189d9c21b7fbc6db1dcff1c2fc7')], 'data': HexBytes('0x0000000000000000000000000000000000000000000000000000000000000000'), 'blockNumber': 56114, 'transactionHash': HexBytes('0x66e130f93bd2b3aba4ca607421156e008afaf8ba0fda38f0569049bc34c5b39c'), 'transactionIndex': 0, 'blockHash': HexBytes('0x554b6aeddfd8c31d3d163a12cad5b01353b481d70689eb33ca29218187855b10'), 'logIndex': 1, 'removed': False}, {'address': '0x0BF2074D83C16F0EcAB3671BA20a62C46217b69f', 'topics': [HexBytes('0x7fcf532c15f0a6db0bd6d0e038bea71d30d808c7d98cb3bf7268a95bf5081b65'), HexBytes('0x000000000000000000000000ddafb6eb07b57189d9c21b7fbc6db1dcff1c2fc7')], 'data': HexBytes('0x0000000000000000000000000000000000000000000000000000000000000000'), 'blockNumber': 56114, 'transactionHash': HexBytes('0x66e130f93bd2b3aba4ca607421156e008afaf8ba0fda38f0569049bc34c5b39c'), 'transactionIndex': 0, 'blockHash': HexBytes('0x554b6aeddfd8c31d3d163a12cad5b01353b481d70689eb33ca29218187855b10'), 'logIndex': 2, 'removed': False}]
```

### ETHLocker

```bash
Attacker.balance: 100
ETHLocker.balanceOf(AttackerInit) 100
ETHLocker.balance 0
```
