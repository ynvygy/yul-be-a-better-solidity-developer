// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract SolidityContract {
    // a fixed array
    address[5] public admins;

    constructor() {
        admins[2] = msg.sender;
    }

    // get an element from a fixed-size array at the specified index
    function getAdmin(uint256 index) external view returns (address) {
        // require(index < 5, "Index is out of bounds")
        return admins[index];
    }

    // update an existing element in a fixed-size array at the specified index
    function setAdmin(uint256 index, address newAdmin) external {
        // require(index < 5, "Index is out of bounds")
        admins[index] = newAdmin;
    }
}
