// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SpendCoin is Ownable {
    address public recipient;
    mapping(address => bool) public allowedRecipients;

    // Define Events
    event RecipientAdded(address indexed addedBy, address indexed newRecipient);
    event RecipientUpdated(address indexed updatedBy, address indexed newRecipient);
    event BNBTransferred(address indexed sender, address indexed recipient, uint256 amount);
    event OwnerTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address payable _receiver) Ownable(_receiver) {
        require(_receiver != address(0), "INVALID ADDRESS");
        recipient = _receiver;
        allowedRecipients[_receiver] = true;
    }

    function isAllowedRecipient(address reqAddress) private view returns (bool) {
        return allowedRecipients[reqAddress];
    }

    function addAllowedRecipient(address newAllowedRecipient) external onlyOwner {
        if (!isAllowedRecipient(newAllowedRecipient)) {
            allowedRecipients[newAllowedRecipient] = true;
            emit RecipientAdded(msg.sender, newAllowedRecipient); // Emit event
        }
    }

    function transferBNB(uint256 _amount) external payable {
        require(msg.value >= _amount, "INSUFFICIENT BNB BALANCE");
        require(msg.value > 0, "NO BNB RECEIVED");
        require(recipient != address(0), "INVALID RECIPIENT");
        (bool sent, ) = recipient.call{value: _amount}("");
        require(sent, "SENDING BNB FAILED");

        emit BNBTransferred(msg.sender, recipient, _amount); // Emit event
    }

    receive() external payable {
        require(msg.value > 0, "NO ETH RECEIVED");
        require(recipient != address(0), "INVALID RECIPIENT");
        (bool sent, ) = recipient.call{value: msg.value}("");
        require(sent, "SENDING ETH FAILED");
    }

    function updateRecipient(address payable _newRecipient) external onlyOwner {
        require(_newRecipient != address(0), "INVALID RECIPIENT");
        require(isAllowedRecipient(_newRecipient), "CAN'T SET THIS RECIPIENT");
        recipient = _newRecipient;

        emit RecipientUpdated(msg.sender, _newRecipient); // Emit event
    }

    function setNewOwner(address _newOwner) external onlyOwner {
        transferOwnership(_newOwner);
        emit OwnerTransferred(msg.sender, _newOwner); // Emit event
    }
}