// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract YulContract {
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
        userInfos[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = UserInfo(
            3000,
            20,
            true,
            0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        );
    }

    //function deposit() public payable {
    //    assembly {
    //        mstore(0x40, caller())
    //        mstore(0x60, balances.slot)
    //        let addrBalanceSlot := keccak256(0x40, 0x40)
    //        let addrBalance := sload(addrBalanceSlot)
    //        sstore(addrBalanceSlot, add(addrBalance, callvalue()))
    //    }
    //}

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
        }
    }
}
