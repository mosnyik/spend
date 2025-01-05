// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SpendCoin is Ownable {
    address public recipient;
    mapping(address => bool) public allowedRecipients;

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
        }
    }

    // 58211 gas for the transaction
    // worse case based on recent gas prices 0.0396305 ETH at (700 Gwei)
    // best case based on recent gas prices 0.000283075 ETH at  (5 Gwei)
    // best case based on recent gas prices 0.0007903854 ETH at (13.96 Gwei)

    function transferBNB(uint256 _amount) external payable {
        require(msg.value >= _amount, "INSUFFICIENT BNB BALANCE");
        require(msg.value > 0, "NO BNB RECIEVED");
        require(recipient != address(0), "INVALID RECIPIENT");
        (bool sent,) = recipient.call{value: _amount}("");
        require(sent, "SENDING BNB FAILED");
    }
    // 56671 gas for the transaction
    // worse case based on recent gas prices 0.0396305 ETH at (700 Gwei)
    // best case based on recent gas prices 0.000283075 ETH at  (5 Gwei)
    // best case based on recent gas prices 0.0007903854 ETH at (13.96 Gwei)

    receive() external payable {
        require(msg.value > 0, "NO ETH RECIEVED");
        require(recipient != address(0), "INVALID RECIPIENT");
        (bool sent,) = recipient.call{value: msg.value}("");
        require(sent, "SENDING ETH FAILED");
    }

    function updateRecipient(address payable _newRecipient) external {
        require(_newRecipient != address(0), "INVALID RECIPIENT");
        require(isAllowedRecipient(_newRecipient), "CAN'T SET THIS RECIPIENT");
        recipient = _newRecipient;
    }

    function setNewOwner(address _newOwner) external onlyOwner {
        transferOwnership(_newOwner);
    }
}
