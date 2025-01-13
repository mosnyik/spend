// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract SpendCoin {
    address public owner; 
    address public recipient;
    mapping(address => bool) public allowedRecipients;

      // Define Events
    event TRXRecipientAdded(address indexed addedBy, address indexed newRecipient);
    event TRXRecipientUpdated(address indexed updatedBy, address indexed newRecipient);
    event TRXTransferred(address indexed sender, address indexed recipient, uint256 amount);
    event TRXOwnerTransferred(address indexed previousOwner, address indexed newOwner);
    event TRXReceived( address indexed sender, address indexed reciever, uint256 amount);


    modifier onlyOwner() {
        require(msg.sender == owner, "NOT OWNER");
        _;
    }

    constructor(address payable _receiver) {
        require(_receiver != address(0), "INVALID ADDRESS");
        owner = msg.sender; // Set the deployer as the owner
        recipient = _receiver;
        allowedRecipients[_receiver] = true;
    }

    function isAllowedRecipient(address reqAddress) private view returns (bool) {
        return allowedRecipients[reqAddress];
    }

    function addAllowedRecipient(address newAllowedRecipient) external onlyOwner {
        if (!isAllowedRecipient(newAllowedRecipient)) {
            allowedRecipients[newAllowedRecipient] = true;
            emit TRXRecipientAdded(msg.sender, newAllowedRecipient); 
        }
    }

    // Function to transfer TRX
    function transferTRX(uint256 _amount) external payable {
        require(msg.value >= _amount, "INSUFFICIENT TRX BALANCE");
        require(msg.value > 0, "NO TRX RECEIVED");
        require(recipient != address(0), "INVALID RECIPIENT");

        // Sending TRX to the recipient
        (bool sent, ) = recipient.call{value: _amount}("");
        require(sent, "SENDING TRX FAILED");
        // emit an event to log the transfer
        emit TRXTransferred(msg.sender, recipient, _amount);
    }

    // Fallback function to handle TRX transfers
    receive() external payable {
        require(msg.value > 0, "NO TRX RECEIVED");
        require(recipient != address(0), "INVALID RECIPIENT");

        // Forward the received TRX to the recipient
        (bool sent, ) = recipient.call{value: msg.value}("");
        require(sent, "SENDING TRX FAILED");

        // log event for fallback transfers
        emit TRXReceived(msg.sender, recipient,msg.value);
    }

    // Update the recipient address
    function updateRecipient(address payable _newRecipient) external {
        require(_newRecipient != address(0), "INVALID RECIPIENT");
        require(isAllowedRecipient(_newRecipient), "CAN'T SET THIS RECIPIENT");
        recipient = _newRecipient;

        // Emit an event for recipient updates
        emit TRXRecipientUpdated(msg.sender,_newRecipient);
    }

    // Set a new owner
    function setNewOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "INVALID OWNER");
        owner = _newOwner;

        // Emit an event for ownership transfer
        emit TRXOwnerTransferred(msg.sender, _newOwner);
    }
}
