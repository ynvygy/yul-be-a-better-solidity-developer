// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract SolidityContract {
    // a variable
    address public owner;

    // a fixed array
    address[5] public admins;

    // a dynamic array
    address[] public users;

    // a simple mapping
    mapping(address => uint256) public balances;

    // a mapping with a struct
    mapping(address => UserInfo) public userInfos;

    // events
    // eemitted when a deposit occurs
    event Deposit(address indexed depositor, uint256 amount);
    // event emitted when adding a new admin
    event AdminAdded(address indexed newAdmin);
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

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // get an element from a fixed-size array at the specified index
    function getAdmin(uint256 index) external view returns (address) {
        return admins[index];
    }

    // update an existing element in a fixed-size array at the specified index
    function setAdmin(uint256 index, address newAdmin) external {
        admins[index] = newAdmin;
        emit AdminAdded(newAdmin);
    }

    // get an element from a dynamic-size array at the specified index
    function getUser(uint256 index) external view returns (address) {
        return users[index];
    }

    // add a new element to a dynamic array
    function addUser(address newUser) external {
        users.push(newUser);
    }

    // deposit
    function deposit() public payable {
        balances[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    // withdraw
    function withdraw(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        balances[msg.sender] -= amount;
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

        emit UserInfoAdded(
            msg.sender,
            _age,
            _isActive,
            _salary,
            _backupAddress
        );
    }

    // average for loop
    function calculateAverageAge() public view returns (uint256) {
        uint256 totalAge = 0;

        for (uint256 i = 0; i < users.length; i++) {
            totalAge += userInfos[users[i]].age;
        }

        return totalAge / users.length;
    }
}
