// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract SolidityContract {
    // a fixed array
    address[5] public admins;

    // a simple mapping
    mapping(address => uint256) public balances;

    // a mapping with a struct
    mapping(address => UserInfo) public userInfos;

    // events
    // event emitted when adding a new admin
    event AdminAdded(address indexed newAdmin);
    // eemitted when a deposit occurs
    event Deposit(address indexed depositor, uint256 amount);
    // event emitted when adding user info
    event UserInfoAdded(
        address indexed userInfoAddress,
        uint256 indexed age,
        bool indexed isActive,
        uint256 salary,
        address backupAddress
    );

    // user info struct
    struct UserInfo {
        uint256 salary;
        uint256 age;
        bool isActive;
        address backupAddress;
    }

    // update an existing element in a fixed array
    function setAdmin(uint256 index, address newAdmin) external {
        admins[index] = newAdmin;

        emit AdminAdded(newAdmin);
    }

    // deposit
    function deposit() public payable {
        balances[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);
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

        emit UserInfoAdded(
            msg.sender,
            _age,
            _isActive,
            _salary,
            _backupAddress
        );
    }
}
