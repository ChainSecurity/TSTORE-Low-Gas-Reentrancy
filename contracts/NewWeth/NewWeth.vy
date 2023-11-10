#pragma evm-version cancun

from vyper.interfaces import ERC20

# Events
event Approval:
    owner: indexed(address)
    spender: indexed(address)
    value: uint256

event Transfer:
    sender: indexed(address)
    receiver: indexed(address)
    value: uint256

event Deposit:
    sender: indexed(address)
    value: uint256

event Withdrawal:
    sender: indexed(address)
    value: uint256

# Variables
name: public(String[32])
symbol: public(String[32])
decimals: public(uint256)
balanceOf: public(HashMap[address, uint256])
allowance: public(HashMap[address, HashMap[address, uint256]])
tempAllowance: transient(HashMap[address, HashMap[address, uint256]])

# Initialize the contract
@external
def __init__():
    self.name = "Wrapped Ether"
    self.symbol = "WETH"
    self.decimals = 18

# Receive Ether and wrap it
@payable
@external
def deposit():
    self.balanceOf[msg.sender] += msg.value
    log Deposit(msg.sender, msg.value)

# Withdraw Ether
@external
def withdraw(wad: uint256):
    assert self.balanceOf[msg.sender] >= wad
    self.balanceOf[msg.sender] -= wad
    send(msg.sender, wad)
    log Withdrawal(msg.sender, wad)

# Return the total supply (all wrapped ether in the contract)
@external
@view
def totalSupply() -> uint256:
    return self.balance

# Approve allowance
@external
def approve(guy: address, wad: uint256) -> bool:
    self.allowance[msg.sender][guy] = wad
    log Approval(msg.sender, guy, wad)
    return True

# Transfer wrapped ether
@external
def transfer(dst: address, wad: uint256) -> bool:
    return self._transferFrom(msg.sender, dst, wad)

# Transfer from a specific address
@external
def transferFrom(src: address, dst: address, wad: uint256) -> bool:
    return self._transferFrom(src, dst, wad)

@internal
def _transferFrom(src: address, dst: address, wad: uint256) -> bool:
    assert self.balanceOf[src] >= wad

    if src != msg.sender and self.allowance[src][msg.sender] != MAX_UINT256:
        assert self.allowance[src][msg.sender] >= wad
        self.allowance[src][msg.sender] -= wad

    self.balanceOf[src] -= wad
    self.balanceOf[dst] += wad

    log Transfer(src, dst, wad)

    return True

# Temporary approval
@external
def temporaryApprove(guy: address, wad: uint256):
    self.tempAllowance[msg.sender][guy] = wad

# Withdraw all temporary approved amount from an address
@external
def withdrawAllTempFrom(src: address, dst: address):
    assert msg.sender == src or msg.sender == dst
    assert self.tempAllowance[src][dst] <= self.balanceOf[src]
    send(dst, self.tempAllowance[src][dst])
    self.balanceOf[src] -= self.tempAllowance[src][dst]
    log Transfer(src, dst, self.tempAllowance[src][dst])
    log Withdrawal(dst, self.tempAllowance[src][dst])
    self.tempAllowance[src][dst] = 0
