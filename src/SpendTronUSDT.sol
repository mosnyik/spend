// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface ITRC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract SpendToken {
    ITRC20 public token;

    constructor(address _token) {
        token = ITRC20(_token);
    }

    function transferUSDTFrom(uint256 _amount, address _recipient) external {
        require(token.balanceOf(msg.sender) >= _amount, "INSUFFICIENT BALANCE");
        require(_recipient != address(0), "INVALID RECIPIENT");
        bool success = token.transferFrom(msg.sender, _recipient, _amount);
        require(success, "TOKEN TRANSFER FAILED");
    }
}
