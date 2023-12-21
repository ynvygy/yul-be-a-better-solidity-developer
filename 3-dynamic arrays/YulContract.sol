// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract YulContract {
    // a dynamic array
    address[] public users;

    constructor() {
        users.push(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        users.push(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    }

    // get an element from a fixed-size array at the specified index
    //function getAdmin(uint256 index) external view returns (address) {
    //assembly {
    //    let slot := admins.slot
    //    let indexSlot := add(slot, index)
    //    let indexValue := sload(indexSlot)
    //    mstore(0x40, indexValue)
    //    return(0x40, 0x20)
    //}
    //}

    // get an element from a dynamic-size array at the specified index
    // https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html
    function getUser(uint256 index) external view returns (address) {
        // return users[index];
        assembly {
            let slot := users.slot

            mstore(0x40, slot)
            let storagePointer := keccak256(0x40, 0x20)

            mstore(0x40, sload(add(storagePointer, index)))

            return(0x40, 0x20)
        }
    }

    // add a new element to a dynamic-size array
    function addUser(address newUser) external {
        // users.push(newUser);
        assembly {
            let slot := users.slot
            mstore(0x40, slot)
            let storagePointer := keccak256(0x40, 0x20)

            let length := sload(slot)
            sstore(users.slot, add(length, 1))

            sstore(add(storagePointer, length), newUser)
        }
    }

    function testLength() external view returns (uint length) {
        assembly {
            let slot := users.slot
            length := sload(slot)
        }
    }
}
