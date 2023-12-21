// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract SolidityContract {
    // a variable
    address public owner;

    // a simple mapping
    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // deposit
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // withdraw
    function withdraw(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        balances[msg.sender] -= amount;
    }
}
