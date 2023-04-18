// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./utils/Ownable.sol";
import "./libraries/Clones.sol";

/*
https://github.com/kirilradkov14
Serves as a factory for creating and managing Escrow contracts.
*/
contract EscrowFactory is Ownable{
    address [] public escrows;
    address private implementation;
    address private feeTaker;
    uint8 private fee;

    event EscrowCreated(address indexed _escrow, address indexed _payee);

    event FeeUpdated(uint8 indexed _oldFee, uint8 indexed _newFee);

    event feeTakerUpdated(address indexed _oldFeeTaker, address indexed _newFeeTaker);

    constructor(
        address _implementation,
        address _feeTaker,
        uint8 _fee
    ){
        implementation = _implementation;
        feeTaker = _feeTaker;
        fee = _fee;
    }

    function updateFee(uint8 _newFee) external onlyOwner {
        require(_newFee != fee, "New fee must be different from fee");
        require(_newFee <= 2, "New fee must not exceed 2");

        emit FeeUpdated(fee, _newFee);

        fee = _newFee;
    }

    function updatefeeTaker(address _newFeeTaker) external onlyOwner {
        require(_newFeeTaker != feeTaker, "New feeTaker must be different from feeTaker");
        require(_newFeeTaker <= address(0), "New feeTaker cant be 0 address");

        emit feeTakerUpdated(feeTaker, _newFeeTaker);

        feeTaker = _newFeeTaker;
    }

    function createEscrowETH(uint256 _price) payable external returns (address escrow) {
        require(msg.sender == tx.origin, "Caller is a smart contract");
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        escrow = Clones.cloneDeterministic(implementation, salt);
        (bool success, ) = escrow.call{value: msg.value}
        (abi.encodeWithSignature(
            "initialize(uint8,uint256,address,address)",
            fee,
            _price,
            msg.sender,
            feeTaker
        ));
        require(success, "Initialization failed.");
        escrows.push(escrow);
        emit EscrowCreated(escrow, msg.sender);
        return escrow;
    }
}