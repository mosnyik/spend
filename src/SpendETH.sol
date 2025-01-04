// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract SpendETH {
    address recipient;

    constructor(address payable _receiver) {
        require(_receiver != address(0), "INVALID ADDRESS");
        recipient = _receiver;
    }
    // worse case based on recent gas prices 0.0396305 ETH at (700 Gwei)
    // best case based on recent gas prices 0.000283075 ETH at  (5 Gwei)
    // best case based on recent gas prices 0.0007903854 ETH at (13.96 Gwei)

    receive() external payable {
        require(msg.value > 0, "NO ETH RECIEVED");
        require(recipient != address(0), "INVALID RECIPIENT");
        (bool sent,) = recipient.call{value: msg.value}("");
        require(sent, "SENDING FAILED");
    }

    function updateRecipient(address payable _newRecipient) external {
        require(_newRecipient != address(0), "INVALID RECIPIENT");
        recipient = _newRecipient;
    }
}
