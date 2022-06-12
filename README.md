# 🅾️ Optimism Name Service

![CI Workflow Badge](https://github.com/leovct/ons/actions/workflows/ci.yml/badge.svg)
![CD Workflow Badge](https://github.com/leovct/ons/actions/workflows/cd.yml/badge.svg)

The Optimism Name Service (ONS) is a distributed naming system based on the [Optimism](https://www.optimism.io/) blockchain, highly inspired by the [Ethereum Name Service](https://ens.domains/) (ENS). The purpose of this system is to allow users to manipulate readable names like 'lola.opt' rather than long cryptocurrency addresses.

The project is at the prototype stage and is currently being deployed and tested on the Optimism Kovan blockchain.

## 🛠️ Useful commands

```shell
# 📦 Get up and running (make sure to update the environment variables).
npm install
curl -L https://foundry.paradigm.xyz | bash # foundry (https://github.com/foundry-rs/foundry).
cp .env.example .env

# 🪄 Lint files.
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix

# ⚙️ Compile contracts (hardhat and foundry).
npx hardhat compile
forge build

# 🧪 Test contracts with gas report (hardhat and foundry).
npx hardhat test
forge test --gas-report

# 📊 Test coverage report.
npx hardhat coverage

# 🐍 Run slither (audit).
slither .

# 🛡️ Run mythril (audit).
myth analyze contracts/ONS.sol

# 🏠 Deploy contract to localhost blockchain (hardhat and foundry).
npx hardhat run scripts/deploy.ts
forge script scripts/ONS.s.sol

# 🚀 Deploy and verify contract to Optimistic Kovan testnet (hardhat).
npx hardhat run scripts/deploy.ts --network optimisticKovan
```
