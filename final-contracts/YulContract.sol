// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract YulContract {
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
        assembly {
            sstore(owner.slot, caller())
        }
    }

    modifier onlyOwner() {
        assembly {
            let _owner := sload(owner.slot)
            if iszero(eq(_owner, caller())) {
                mstore(
                    0x40,
                    0x08c379a000000000000000000000000000000000000000000000000000000000
                )
                mstore(0x44, 32)
                mstore(0x64, 32)
                mstore(0x84, "You are not the owner")
                revert(0x40, 0x64)
            }
        }
        _;
    }

    function getOwner() external view returns (address) {
        assembly {
            mstore(0x40, sload(owner.slot))
            return(0x40, 0x20)
        }
    }

    // get an element from a fixed-size array at the specified index
    function getAdmin(uint256 index) external view returns (address) {
        // return admins[index];
        assembly {
            let slot := admins.slot
            let indexSlot := add(slot, index)
            let indexValue := sload(indexSlot)
            mstore(0x40, indexValue)
            return(0x40, 0x20)
        }
    }

    // update an existing element in a fixed-size array at the specified index
    function setAdmin(uint256 index, address newAdmin) external {
        // admins[index] = newAdmin;
        assembly {
            let slot := admins.slot
            sstore(add(slot, index), newAdmin)
        }
    }

    // get an element from a dynamic-size array at the specified index
    function getUser(uint256 index) external view returns (address) {
        assembly {
            let slot := users.slot
            let length := sload(slot)

            if iszero(gt(length, index)) {
                revert(0, 0)
            }

            mstore(0x40, slot)
            let storagePointer := keccak256(0x40, 0x20)

            mstore(0x40, sload(add(storagePointer, index)))

            return(0x40, 0x20)
        }
    }

    // add a new element to a dynamic-size array
    function addUser(address newUser) external {
        assembly {
            let slot := users.slot
            mstore(0x40, slot)
            let storagePointer := keccak256(0x40, 0x20)

            let length := sload(slot)
            sstore(users.slot, add(length, 1))

            sstore(add(storagePointer, length), newUser)
        }
    }

    // deposit
    function deposit() public payable {
        assembly {
            let memptr := mload(0x40)

            mstore(memptr, caller())

            mstore(add(memptr, 0x20), balances.slot)

            let addrBalanceSlot := keccak256(memptr, 0x40)

            let addrBalance := sload(addrBalanceSlot)

            sstore(addrBalanceSlot, add(addrBalance, callvalue()))

            let
                eventSignature
            := 0xe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c

            mstore(0x40, callvalue())
            log2(0x40, 0x20, eventSignature, caller())
        }
    }

    // withdraw
    function withdraw(uint256 amount) public {
        assembly {
            let memptr := mload(0x40)

            mstore(memptr, caller())

            mstore(add(memptr, 0x20), balances.slot)

            let addrBalanceSlot := keccak256(memptr, 0x40)

            let addrBalance := sload(addrBalanceSlot)

            if iszero(amount) {
                mstore(
                    0x40,
                    0x08c379a000000000000000000000000000000000000000000000000000000000
                )
                mstore(0x44, 32)
                mstore(0x64, 32)
                mstore(0x84, "Amount must be greater than zero")
                revert(0x40, 0x64)
            }

            if gt(amount, addrBalance) {
                mstore(
                    0x40,
                    0x08c379a000000000000000000000000000000000000000000000000000000000
                )
                mstore(0x44, 32)
                mstore(0x64, 20)
                mstore(0x84, "Insufficient balance")
                revert(0x40, 0x64)
            }

            if iszero(call(gas(), caller(), amount, 0, 0, 0, 0)) {
                revert(0, 0)
            }

            sstore(addrBalanceSlot, sub(addrBalance, amount))
        }
    }

    // get the struct from a mapping
    function getUserInfo()
        public
        view
        returns (
            uint256 salary,
            uint256 age,
            bool isActive,
            address backupAddress
        )
    {
        assembly {
            mstore(0x00, caller())
            mstore(0x20, userInfos.slot)
            let dataLocation := keccak256(0x00, 0x40)
            salary := sload(add(dataLocation, 0))
            age := sload(add(dataLocation, 1))
            isActive := and(sload(add(dataLocation, 2)), 0xFF)
            backupAddress := shr(8, sload(add(dataLocation, 2)))
        }
    }

    // set a mapping to a struct
    function setUserInfo(
        uint256 _salary,
        uint256 _age,
        bool _isActive,
        address _backupAddress
    ) public {
        assembly {
            mstore(0x00, caller())
            mstore(0x20, userInfos.slot)
            let dataLocation := keccak256(0x00, 0x40)

            sstore(add(dataLocation, 0), _salary)
            sstore(add(dataLocation, 1), _age)
            let packedValue := shl(0, _isActive)
            packedValue := or(packedValue, shl(8, _backupAddress))
            sstore(add(dataLocation, 2), packedValue)

            let
                eventSignature
            := 0xc9fa2289565e53512e6f1bdcf7f3cbb82bc90f75c7db8e17135b9f11b40340a0

            mstore(0x40, _salary)
            mstore(0x60, _backupAddress)
            log4(0x40, 0x40, eventSignature, caller(), _age, _isActive)
        }
    }

    // average for loop
    function calculateAverageAge() public view returns (uint256) {
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
