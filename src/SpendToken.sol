// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SpendToken is Ownable {
    address public recipient;

    event TokenTransfered(address indexed sender, address indexed recipient, uint256 amount);

    IERC20 token;

    constructor(address _token, address _initialOwner) Ownable(_initialOwner) {
        token = IERC20(_token);
    }

    function transferUSDTFrom(uint256 _amount, address _to) external {
        require(token.balanceOf(msg.sender) >= _amount, "INSUFFICIENT BALANCE");
        bool success = token.transferFrom(msg.sender, _to, _amount);
        require(success, "TOKEN TRANSFER FAILED");

        emit TokenTransfered(msg.sender, _to, _amount);
    }
}
