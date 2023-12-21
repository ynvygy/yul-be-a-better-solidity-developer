// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract YulContract {
    // a fixed array
    address[5] public admins;

    constructor() {
        admins[2] = msg.sender;
    }

    // get an element from a fixed-size array at the specified index
    function getAdmin(uint256 index) external view returns (address) {
        // return admins[index];
        assembly {
            let slot := admins.slot
            let indexSlot := add(slot, index)
            let indexValue := sload(indexSlot)
            mstore(0x40, indexValue)
            return(0x40, 0x20)
        }
    }

    // update an existing element in a fixed-size array at the specified index
    function setAdmin(uint256 index, address newAdmin) external {
        // admins[index] = newAdmin;
        assembly {
            let slot := admins.slot
            sstore(add(slot, index), newAdmin)
        }
    }
}
