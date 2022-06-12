# 🅾️ Optimism Name Service Contracts

## 🛠️ Useful commands

```shell
# 📦 Get up and running (make sure to update the environment variables).
npm install
cp .env.example .env

# 🔧 Setup foundry
curl -L https://foundry.paradigm.xyz | bash # foundry (https://github.com/foundry-rs/foundry).
forge init --no-commit --no-git --force

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
