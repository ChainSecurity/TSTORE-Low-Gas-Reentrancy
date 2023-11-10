#pragma evm-version cancun

interface DeferredCallee:
    def callback(): nonpayable

balanceOf: public(HashMap[address, int256])
transientBalanceOf: public(transient(HashMap[address, int256]))

deferredLiquidityCheck: transient(HashMap[address, bool])

@external
@payable
def deposit():
	if (self.deferredLiquidityCheck[msg.sender]):
		self.transientBalanceOf[msg.sender] += convert(msg.value, int256)
	else:
		self.balanceOf[msg.sender] += convert(msg.value, int256)

@external
def withdraw(receiver : address, amount : int256):
	assert amount >= 0, "cannot withdraw negative amount"
	newBalance : int256 = 0
	if (self.deferredLiquidityCheck[msg.sender]):
		newBalance = self.transientBalanceOf[msg.sender] - amount
	else:
		newBalance = self.balanceOf[msg.sender] - amount
		assert newBalance >= 0, "user in unhealthy position"

	send(receiver, convert(amount, uint256))

	if (self.deferredLiquidityCheck[msg.sender]):
		self.transientBalanceOf[msg.sender] = newBalance
	else:
		self.balanceOf[msg.sender] = newBalance

@external
def transfer(receiver : address, amount : int256):
	assert amount >= 0, "cannot transfer negative amount"
	if (self.deferredLiquidityCheck[msg.sender]):
		self.transientBalanceOf[msg.sender] -= amount
	else:
		self.balanceOf[msg.sender] -= amount
		assert self.balanceOf[msg.sender] >= 0, "user in unhealthy position"

	if (self.deferredLiquidityCheck[receiver]):
		self.transientBalanceOf[receiver] += amount
	else:
		self.balanceOf[receiver] += amount

@external
def batch():
	assert (not self.deferredLiquidityCheck[msg.sender]), "already batching operations"
	self.deferredLiquidityCheck[msg.sender] = True
	DeferredCallee(msg.sender).callback() # callback will use transient storage
	self.deferredLiquidityCheck[msg.sender] = False
	self.balanceOf[msg.sender] += self.transientBalanceOf[msg.sender]
	self.transientBalanceOf[msg.sender] = 0
	assert self.balanceOf[msg.sender] >= 0, "user in unhealthy position"
