import os
from dotenv import load_dotenv
from ape import accounts, project

def main():
    # Load account and set auto sign
    load_dotenv()
    acc = accounts.load(os.getenv('ACCOUNT_ALIAS'))
    acc.set_autosign(True)

    # Deploy and Run
    new_weth = acc.deploy(project.NewWeth)
    caller = acc.deploy(project.NewWethCaller, new_weth)
    callee = acc.deploy(project.NewWethCallee)
    r = caller.run(callee, value=10**17, sender=acc)

    # Print Result: Print balances in different locations
    print('WETH.balance:', new_weth.balance)
    print('Callee.balance:', callee.balance)
    print('WETH.balanceOf(Caller):', new_weth.balanceOf(caller))
    print(r.logs)