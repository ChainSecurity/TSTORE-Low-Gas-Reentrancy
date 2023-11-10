#pragma evm-version cancun

interface NewWethCaller:
    def callback(): nonpayable

caller : public(address)

@nonpayable
@external
def set_caller(_caller : address):
    self.caller = _caller

@payable
@external
def __default__():
    NewWethCaller(self.caller).callback()
