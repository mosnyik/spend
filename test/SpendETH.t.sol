// SPDX-Licence-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {SpendETH} from "../src/SpendETH.sol";

contract Spend is Test {
    SpendETH public spendETH;

    address recipient = address(1);
    address sender = address(2);
    address newRecipient = address(3);

    function setUp() public {
        spendETH = new SpendETH(payable(recipient));

        //set the balances of the sender to 100 ether
        deal(sender, 100 ether);
    }

    function testSendETH() public {
        // simulate a call sender with 10 ether
        vm.prank(sender);

        (bool success,) = address(spendETH).call{value: 10 ether}("");
        require(success, "SOMETHING WENT WRONG");

        // 10000000000000000000  = 10 ether
        assertEq(address(recipient).balance, 10 ether);
    }

    function testSetNewRecipient() public {
        // simulate a call sender with 10 ether
        vm.prank(sender);

        spendETH.updateRecipient(payable(newRecipient));

        (bool success,) = address(spendETH).call{value: 10 ether}("");
        require(success, "SOMETHING WENT WRONG");

        // 10000000000000000000  = 10 ether
        assertEq(address(newRecipient).balance, 10 ether);
    }
}
