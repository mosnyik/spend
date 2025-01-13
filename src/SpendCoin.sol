// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract SpendCoin {
    address public recipient;

    // Define Events
    event BNBTransferred(address indexed sender, address indexed recipient, uint256 amount);
    event ETHTransferred(address indexed sender, address indexed recipient, uint256 amount);

    constructor(address payable _receiver) {
        require(_receiver != address(0), "INVALID ADDRESS");
        recipient = _receiver;
    }

    function transferBNB(uint256 _amount) external payable {
        require(msg.value >= _amount, "INSUFFICIENT BNB BALANCE");
        require(msg.value > 0, "NO BNB RECEIVED");
        require(recipient != address(0), "INVALID RECIPIENT");
        (bool sent,) = recipient.call{value: _amount}("");
        require(sent, "SENDING BNB FAILED");

        emit BNBTransferred(msg.sender, recipient, _amount); // Emit event
    }

    receive() external payable {
        require(recipient != address(0), "INVALID RECIPIENT");
        (bool sent,) = recipient.call{value: msg.value}("");
        require(sent, "SENDING ETH FAILED");
        emit ETHTransferred(msg.sender, recipient, msg.value); // Emit event
    }
}
