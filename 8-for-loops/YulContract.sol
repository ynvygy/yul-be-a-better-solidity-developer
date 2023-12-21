// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract YulContract {
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

    constructor() {
        userInfos[0x617F2E2fD72FD9D5503197092aC168c91465E7f2] = UserInfo(
            3000,
            20,
            true,
            0x617F2E2fD72FD9D5503197092aC168c91465E7f2
        );

        users.push(0x617F2E2fD72FD9D5503197092aC168c91465E7f2);

        userInfos[0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7] = UserInfo(
            3000,
            30,
            true,
            0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7
        );

        users.push(0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7);
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
        // for (uint256 i = 0; i < users.length; i++) {
        //   totalAge += userInfos[users[i]].age;
        // }
        assembly {
            let slot := users.slot
            let length := sload(slot)

            mstore(0x40, slot)
            let storagePointer := keccak256(0x40, 0x20)

            let sum_of_ages := 0
            for {
                let i := 0
            } lt(i, length) {
                i := add(i, 1)
            } {
                let userAddress := sload(add(storagePointer, i))

                mstore(0x40, userAddress)
                mstore(0x60, userInfos.slot)
                let dataLocation := keccak256(0x40, 0x40)
                sum_of_ages := add(sload(add(dataLocation, 1)), sum_of_ages)
            }

            mstore(0x40, div(sum_of_ages, length))
            return(0x40, 0x20)
        }
    }
}
