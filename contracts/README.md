# πΎοΈ Optimism Name Service Contracts

## π οΈ Useful commands

```shell
# π¦ Get up and running (make sure to update the environment variables).
npm install
cp .env.example .env

# π§ Setup foundry
curl -L https://foundry.paradigm.xyz | bash # foundry (https://github.com/foundry-rs/foundry).
forge init --no-commit --no-git --force

# πͺ Lint files.
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix

# βοΈ Compile contracts (hardhat and foundry).
npx hardhat compile
forge build

# π§ͺ Test contracts with gas report (hardhat and foundry).
npx hardhat test
forge test --gas-report

# π Test coverage report.
npx hardhat coverage

# π Run slither (audit).
slither .

# π‘οΈ Run mythril (audit).
myth analyze contracts/ONS.sol

# π  Deploy contract to localhost blockchain (hardhat and foundry).
npx hardhat run scripts/deploy.ts
forge script scripts/ONS.s.sol

# π Deploy and verify contract to Optimistic Kovan testnet (hardhat).
npx hardhat run scripts/deploy.ts --network optimisticKovan
```
