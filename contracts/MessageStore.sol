// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract MessageStore is ReentrancyGuard {
    struct CoffeeMessage {
        address sender;
        string message;
        uint256 amount;
    }

    mapping(address => CoffeeMessage[]) private userMessages;
    mapping(address => uint256) public pendingWithdrawals;

    event MessageStored(address indexed sender, address indexed recipient, string message, uint256 amount);
    event CoffeeWithdrawn(address indexed recipient, uint256 amount);

    function sendMessageWithCoffee(address recipient, string memory _message) public payable {
        require(msg.value > 0, "You must send some Ether");
        userMessages[recipient].push(CoffeeMessage(msg.sender, _message, msg.value));
        pendingWithdrawals[recipient] += msg.value;
        emit MessageStored(msg.sender, recipient, _message, msg.value);
    }

    function getMyMessages() public view returns (CoffeeMessage[] memory) {
        return userMessages[msg.sender];
    }

    function withdrawCoffee() public nonReentrant {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "No coffee money to withdraw");
        pendingWithdrawals[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
        emit CoffeeWithdrawn(msg.sender, amount);
    }

    function getPendingWithdrawal(address user) public view returns (uint256) {
        return pendingWithdrawals[user];
    }
}