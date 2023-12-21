// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract SolidityContract {
    // a mapping with a struct
    mapping(address => UserInfo) public userInfos;

    // user info struct
    struct UserInfo {
        uint256 salary;
        uint256 age;
        bool isActive;
        address backupAddress;
    }

    // get the struct from a mapping
    function getUserInfo() public view returns (UserInfo memory) {
        UserInfo memory userInfo = userInfos[msg.sender];
        return userInfo;
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
    }
}
