#pragma evm-version cancun

# simple calle that calls fallback function back
@external
@payable
def __default__():
	raw_call(msg.sender, _abi_encode(""))
