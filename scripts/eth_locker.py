import os
from dotenv import load_dotenv
from ape import accounts, project

def main():
    # Load account and set auto sign
    load_dotenv()
    acc = accounts.load(os.getenv('ACCOUNT_ALIAS'))
    acc.set_autosign(True)

    # Deploy and Run
    eth_locker  = acc.deploy(project.ETHLocker)
    attacker_init = acc.deploy(project.ETHLockerAttackerInit)
    attacker  = acc.deploy(project.ETHLockerAttacker, eth_locker, attacker_init, value = 100)
    attacker_init.run(eth_locker, attacker, sender=acc)

    # Print Result: Print balances in different locations
    print('Attacker.balance:', attacker.balance)
    print('ETHLocker.balanceOf(AttackerInit)', eth_locker.balanceOf(attacker_init))
    print('ETHLocker.balance', eth_locker.balance)