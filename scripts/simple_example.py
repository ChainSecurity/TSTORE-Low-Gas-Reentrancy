import os
from dotenv import load_dotenv
from ape import accounts, project

def main():
    # Load account and set auto sign
    load_dotenv()
    acc = accounts.load(os.getenv('ACCOUNT_ALIAS'))
    acc.set_autosign(True)

    # Deploy and Run
    transient = acc.deploy(project.Transient)
    callee = acc.deploy(project.TransientCallee)
    res = transient.test(callee, sender = acc, value=1)

    # Print Result: Get log topic 1 and convert to int
    logged_value = int(res.logs[0]['topics'][1].hex(), 16)
    print('Logged value:', logged_value) # reentrant should be 1234