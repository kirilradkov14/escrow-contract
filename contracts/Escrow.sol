// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./utils/Initializable.sol";
import "./libraries/Address.sol";

/*
https://github.com/kirilradkov14
Contains the business logic for the ETH Escrow,
used for handling payments between a payer and a payee
*/
contract Escrow is Initializable {
    using Address for address payable;

    address public payee;
    address public payer;
    address public feeTaker;
    uint8 public fee;
    uint8 public status;
    uint256 public price;
    uint256 public contractBalance;

    modifier onlyPayee {
        require(msg.sender == payee, "Caller is not the payee.");
        _;
    }
    
    modifier onlyPayer {
        require(msg.sender == payer, "Caller is not the payer.");
        _;
    }

    event PriceEdit(address indexed _payer, uint256 indexed _oldFee, uint256 _newFee);

    event Paid(address indexed _payer, uint256 indexed _payeeShare, uint256 indexed _feeShare);

    event Deposited(address indexed _payer, uint256 indexed _amount);

    event Refund(address indexed _payer, uint256 indexed _amount);

    receive() external payable {
        if (status != 1){
            revert("Unable to deposit.");
        } else {
            deposit();
        }
    }

    function initialize(
        uint8 _fee,
        uint256 _price,
        address _payee,
        address _feeTaker
    )  external payable initializer {
        status = 1;
        fee = _fee;
        price = _price;
        payee = _payee;
        feeTaker = _feeTaker;
    }

    function deposit() public payable {
        require(status == 1, "Unable to deposit");
        require(msg.value == price, "Invalid price value");

        status = 2;
        contractBalance = msg.value;
        payer = msg.sender;

        emit Deposited(msg.sender, msg.value);
    }

    function editPrice(uint256 _newPrice) external onlyPayee {
        require(status == 1, "Edit not currently possible");
        emit PriceEdit(msg.sender, price, _newPrice);
        price = _newPrice;
    }

    function pay() external onlyPayer {
        require(status == 2, "Failed to pay.");

        status = 3;

        uint256 toFee = contractBalance * fee / 100;
        uint256 withdrawalbeAmount = contractBalance - toFee;
        contractBalance = 0;
        
        payable(feeTaker).sendValue(toFee);
        payable(payee).sendValue(withdrawalbeAmount);

        emit Paid(msg.sender, withdrawalbeAmount, toFee);
    }

    function cancelDeposit() external onlyPayer {
        require(status == 2, "Unable to refund.");

        status = 1;
        uint256 refundableAmount = contractBalance;
        contractBalance = 0;
        payer = address(0);

        payable(msg.sender).sendValue(refundableAmount);

        emit Refund(msg.sender, refundableAmount);
    }

    function cancelSale() external onlyPayee {
        require(status == 1 || status == 2, "Unable to cancel.");

        if(status == 1){
            status = 3;
        } else {
            status = 3;
            uint256 refundableAmount = contractBalance;
            address toPay = payer;
            contractBalance = 0;
            payer = address(0);

            payable(toPay).sendValue(refundableAmount);
            emit Refund(msg.sender, refundableAmount);
        }
    }

}