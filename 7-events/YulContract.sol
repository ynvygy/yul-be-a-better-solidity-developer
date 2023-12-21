// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract YulContract {
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
        assembly {
            let slot := admins.slot
            sstore(add(slot, index), newAdmin)

            // event AdminAdded(address indexed newAdmin);
            // emit AdminAdded(newAdmin);

            let
                eventSignature
            := 0x44d6d25963f097ad14f29f06854a01f575648a1ef82f30e562ccd3889717e339
            log2(0x00, 0x00, eventSignature, caller())
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

            // event Deposit(address indexed depositor, uint256 amount);
            // emit Deposit(msg.sender, msg.value);

            let
                eventSignature
            := 0xe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c

            mstore(0x40, callvalue())
            log2(0x40, 0x20, eventSignature, caller())
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
            mstore(0x40, caller())
            mstore(0x60, userInfos.slot)
            let dataLocation := keccak256(0x40, 0x40)

            sstore(add(dataLocation, 0), _salary)
            sstore(add(dataLocation, 1), _age)
            let packedValue := shl(0, _isActive)
            packedValue := or(packedValue, shl(8, _backupAddress))
            sstore(add(dataLocation, 2), packedValue)

            // event UserInfoAdded(
            //    address indexed userInfoAddress,
            //    uint256 indexed age,
            //    bool indexed isActive,
            //    uint256 salary,
            //    address backupAddress
            // );

            // emit UserInfoAdded(
            //    userInfos[msg.sender],
            //    _age,
            //    _isActive,
            //    _salary,
            //    _backupAddress
            // );

            let
                eventSignature
            := 0xc9fa2289565e53512e6f1bdcf7f3cbb82bc90f75c7db8e17135b9f11b40340a0

            mstore(0x40, _salary)
            mstore(0x60, _backupAddress)
            log4(0x40, 0x40, eventSignature, caller(), _age, _isActive)
        }
    }

    function selector() public pure returns (bytes32) {
        return keccak256("Event(type)");
    }
}
