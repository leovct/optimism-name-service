# 🅾️ Optimism Name Service

![CI Workflow Badge](https://github.com/leovct/ons/actions/workflows/ci.yml/badge.svg)
![CD Workflow Badge](https://github.com/leovct/ons/actions/workflows/cd.yml/badge.svg)

The Optimism Name Service (ONS) is a distributed naming system based on the [Optimism](https://www.optimism.io/) blockchain, highly inspired by the [Ethereum Name Service](https://ens.domains/) (ENS). The purpose of this system is to allow users to manipulate readable names like 'lola.opt' rather than long cryptocurrency addresses.

The project is at the prototype stage and is currently being deployed and tested on the Optimism Kovan blockchain.

## 🛠️ Useful commands

```shell
# 📦 Get up and running (make sure to update the environment variables).
npm install
cp .env.example .env

# 🪄 Lint files.
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix

# ⚙️ Compile contracts.
npx hardhat compile

# 🧪 Test contracts (with gas report).
npx hardhat test

# 📊 Test coverage report.
npx hardhat coverage

# 🤖 Generate contract's documentation.
npx hardhat docgen

# 🐍 Run slither (audit).
slither .

# 🛡️ Run mythril (audit).
myth analyze contracts/ONS.sol

# 🏠 Deploy contract to localhost blockchain.
npx hardhat run scripts/deploy.ts

# 🚀 Deploy and verify contract to Optimistic Kovan testnet.
npx hardhat run scripts/deploy.ts --network optimisticKovan
```
