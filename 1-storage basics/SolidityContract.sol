// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract SolidityContract {
    // a variable
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function getOwner() external view returns (address) {
        return owner;
    }
}
