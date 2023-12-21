// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract SolidityContract {
    // a dynamic array
    address[] public users;

    // get an element from a dynamic-size array at the specified index
    function getUser(uint256 index) external view returns (address) {
        // require(index < users.length, "Index out of bounds");
        return users[index];
    }

    // add a new element to a dynamic-size array at the specified index
    function addUser(address newUser) external {
        users.push(newUser);
    }
}
