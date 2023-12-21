// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract YulContract {
    // a variable
    address public owner;

    // sstore - sload
    // msg.sender = caller()
    constructor() {
        // owner = msg.sender;
        assembly {
            sstore(owner.slot, caller())
        }
    }

    // mstore - mload
    // 0x00 = 0
    // 0x20 = 32
    // 0x40 = 64
    // 0x60 = 96
    // ...
    // 0xE0 = 224
    // https://www.rapidtables.com/convert/number/decimal-to-hex.html
    function getOwner() external view returns (address) {
        // return owner;
        assembly {
            mstore(0x40, sload(owner.slot))
            return(0x40, 0x20)
        }
    }
}
