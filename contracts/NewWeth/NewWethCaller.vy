#pragma evm-version cancun

interface NewWeth:
    def temporaryApprove(guy: address, wad: uint256): nonpayable
    def deposit(): payable
    def withdrawAllTempFrom(sender : address, dst : address) : nonpayable

interface NewWethCallee:
    def set_caller(a: address): nonpayable

new_weth : immutable(address)
target: public(address)

@payable
@external
def __init__(_new_weth: address):
    new_weth = _new_weth

@payable
@external
def run(_target: address):
    self.target = _target
    NewWethCallee(self.target).set_caller(self)
    NewWeth(new_weth).deposit(value=msg.value)
    NewWeth(new_weth).temporaryApprove(self.target, msg.value)
    NewWeth(new_weth).withdrawAllTempFrom(self, self.target)

@external
def callback():
    NewWeth(new_weth).temporaryApprove(self.target, convert(0, uint256))

