// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract SolidityContract {
    // a dynamic array
    address[] public users;

    // a mapping with a struct
    mapping(address => UserInfo) public userInfos;

    // user info struct
    struct UserInfo {
        uint256 salary;
        uint256 age;
        bool isActive;
        address backupAddress;
    }

    // set a mapping to a struct
    function setUserInfo(
        uint256 _salary,
        uint256 _age,
        bool _isActive,
        address _backupAddress
    ) public {
        UserInfo storage userInfo = userInfos[msg.sender];
        userInfo.salary = _salary;
        userInfo.age = _age;
        userInfo.isActive = _isActive;
        userInfo.backupAddress = _backupAddress;

        users.push(msg.sender);
    }

    // average for loop
    function calculateAverageAge() public view returns (uint256) {
        uint256 totalAge = 0;

        // iterate through all users and sum up their ages
        for (uint256 i = 0; i < users.length; i++) {
            totalAge += userInfos[users[i]].age;
        }

        // calculate and return the average age
        return totalAge / users.length;
    }
}
