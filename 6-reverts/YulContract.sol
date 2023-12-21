// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract YulContract {
    // a variable
    address public owner;

    // a simple mapping
    mapping(address => uint256) public balances;

    constructor() {
        assembly {
            sstore(owner.slot, caller())
        }
    }

    modifier onlyOwner() {
        // require(msg.sender == owner, "You are not the owner");
        assembly {
            let _owner := sload(owner.slot)
            if iszero(eq(_owner, caller())) {
                mstore(
                    0x40,
                    0x08c379a000000000000000000000000000000000000000000000000000000000
                )
                mstore(0x44, 32)
                mstore(0x64, 21)
                mstore(0x84, "You are not the owner")
                revert(0x40, 0x64)
            }
        }
        _;
    }

    // deposit
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // withdraw
    // https://soliditylang.org/blog/2021/04/21/custom-errors/
    // 0x08c379a000000000000000000000000000000000000000000000000000000000
    function withdraw(uint256 amount) public {
        // require statements
        assembly {
            let memptr := mload(0x40)

            mstore(memptr, caller())

            mstore(add(memptr, 0x20), balances.slot)

            let addrBalanceSlot := keccak256(memptr, 0x40)

            let addrBalance := sload(addrBalanceSlot)

            // require(amount > 0, "Amount must be greater than 0");
            if iszero(amount) {
                mstore(
                    0x40,
                    0x08c379a000000000000000000000000000000000000000000000000000000000
                )
                mstore(0x44, 32)
                mstore(0x64, 29)
                mstore(0x84, "Amount must be greater than 0")
                revert(0x40, 0x64)
            }

            // require(amount <= balances[msg.sender], "Insufficient balance");
            if gt(amount, addrBalance) {
                mstore(
                    0x40,
                    0x08c379a000000000000000000000000000000000000000000000000000000000
                )
                mstore(0x44, 32)
                mstore(0x64, 20)
                mstore(0x84, "Insufficient balance")
                revert(0x40, 0x64)
            }

            if iszero(call(gas(), caller(), amount, 0, 0, 0, 0)) {
                revert(0, 0)
            }

            sstore(addrBalanceSlot, sub(addrBalance, amount))
        }
    }
}
