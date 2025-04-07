import os
import time
from dotenv import load_dotenv
from web3 import Web3
from rich.table import Table
from rich.console import Console

load_dotenv()

PROVIDER = os.getenv("PROVIDER")
PRIVATE_KEY = os.getenv("PRIVATE_KEY")
BOT_ADDRESS = Web3.to_checksum_address(Web3(Web3.HTTPProvider(PROVIDER)).eth.account.privateKeyToAccount(PRIVATE_KEY).address)

w3 = Web3(Web3.HTTPProvider(PROVIDER))
console = Console()

def get_balance(token_address):
    token_abi = [{"constant":True,"inputs":[],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"type":"function"}]
    token = w3.eth.contract(address=token_address, abi=token_abi)
    return token.functions.balanceOf(BOT_ADDRESS).call()

def dashboard(tokens):
    table = Table(title="📊 Keeper Bot Dashboard")
    table.add_column("Token")
    table.add_column("Balance")
    total = 0
    for name, addr in tokens.items():
        bal = get_balance(Web3.to_checksum_address(addr)) / 1e18
        total += bal
        table.add_row(name, f"{bal:.4f}")
    table.add_row("TOTAL", f"{total:.4f}")
    console.clear()
    console.print(table)

if __name__ == "__main__":
    TOKENS = {
        "DAI": "0x0000000000000000000000000000000000000000",  # Replace with real DAI on Sepolia
        "USDC": "0x0000000000000000000000000000000000000000"  # Replace with real USDC
    }
    while True:
        dashboard(TOKENS)
        time.sleep(10)
