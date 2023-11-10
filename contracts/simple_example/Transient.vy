#pragma evm-version cancun

event Number:
	number : indexed(uint256)

number_transient : transient(uint256)

# entry point: call callee that can call you back to set transient
@external
@payable
def test(callee : address):
	send(callee, msg.value)
	log Number(self.number_transient) # if no revert, this must be 1234

@external
@payable
def __default__():
	self.number_transient = 1234
