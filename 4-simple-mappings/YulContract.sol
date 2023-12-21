// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract YulContract {
    // a simple mapping
    mapping(address => uint256) public balances;

    function getBalance(address _address) external view returns (uint256) {
        assembly {
            mstore(0x40, _address)
            mstore(0x60, balances.slot)
            let addrBalanceSlot := keccak256(0x40, 0x40)
            let addrBalance := sload(addrBalanceSlot)
            mstore(0x40, addrBalance)
            return(0x40, 0x20)
        }
    }

    // deposit
    // mapping storage location = 'msg.sender + balances slot'
    // msg.value = callvalue()
    function deposit() public payable {
        assembly {
            mstore(0x40, caller())

            mstore(0x60, balances.slot)

            let addrBalanceSlot := keccak256(0x40, 0x40)

            let addrBalance := sload(addrBalanceSlot)

            sstore(addrBalanceSlot, add(addrBalance, callvalue()))
        }
    }

    // withdraw
    // call(g, a, v, in, insize, out, outsize)
    // 1000000000000000000
    function withdraw(uint256 amount) public {
        // require statements
        assembly {
            let memptr := mload(0x40)

            mstore(0x40, caller())

            mstore(0x60, balances.slot)

            let addrBalanceSlot := keccak256(0x40, 0x40)

            let addrBalance := sload(addrBalanceSlot)

            if iszero(call(gas(), caller(), amount, 0, 0, 0, 0)) {
                revert(0, 0)
            }

            sstore(addrBalanceSlot, sub(addrBalance, amount))
        }
    }
}
