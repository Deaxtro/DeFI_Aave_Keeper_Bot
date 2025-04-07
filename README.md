# Aave Keeper Bot (Sepolia or Mainnet Fork)

🛠️ A flashloan-based liquidation bot with Aave v3 support. Simulates profit and withdrawals using testnet or mainnet fork.

## Features
- Flash loan liquidations via Aave
- Auto withdrawal of profit
- Python dashboard
- Sepolia + local fork support

## Setup

1. Install dependencies:
```bash
npm install
pip install -r requirements.txt
```

2. Configure `.env`:
```
PROVIDER=https://sepolia.infura.io/v3/YOUR_KEY
PRIVATE_KEY=YOUR_WALLET_PRIVATE_KEY
FLASH_CONTRACT=0x... # Filled after deploy
```

3. Deploy FlashLiquidator:
```bash
npx hardhat run scripts/deploy.js --network sepolia
```

4. Run bot:
```bash
python keeper/keeper.py
```

## Testnet ETH
Use [https://sepoliafaucet.com](https://sepoliafaucet.com) to get funds.

## Mainnet Fork
```bash
npx hardhat node --fork https://mainnet.infura.io/v3/YOUR_KEY
```
