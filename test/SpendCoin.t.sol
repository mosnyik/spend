// SPDX-Licence-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {SpendCoin} from "../src/SpendCoin.sol";

contract Spend is Test {
    SpendCoin public spendCoin;

    address recipient = address(1);
    address sender = address(2);
    address bnbSender = address(3);
    address newRecipient1 = address(4);
    address newRecipient2 = address(5);
    address newRecipient3 = address(6);
    address newRecipient4 = address(7);
    address newRecipient5 = address(8);
    address newRecipient6 = address(9);
    address newRecipient7 = address(10);
    address[10] allowedAddresses = [
        recipient,
        sender,
        bnbSender,
        newRecipient1,
        newRecipient2,
        newRecipient3,
        newRecipient4,
        newRecipient5,
        newRecipient6,
        newRecipient7
    ];

    //vm.envString is provided by Foundry so that we can read our .env file and get values from there
    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
    string BNB_MAINNET_RPC_URL = vm.envString("BNB_MAINNET_RPC_URL");

    uint256 mainnetFork;
    uint256 bnbMainnetFork;

    function setUp() public {
        // vm is a variable included in the forge standard library that is used to manipulate the execution environment of our tests
        // create a fork of Ethereum mainnet using the specified RPC URL and store its id in mainnetFork
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
        bnbMainnetFork = vm.createFork(BNB_MAINNET_RPC_URL);
        // select the fork obtained using its id
        vm.selectFork(mainnetFork);
        vm.selectFork(bnbMainnetFork);

        spendCoin = new SpendCoin(payable(recipient));

        //set the balances of the sender to 100 ether
        deal(sender, 100 ether);
        //set the balances of the sender to 100 BNB
        deal(bnbSender, 100 ether);
        deal(recipient, 0 ether);
    }

    function testSendETH() public {
        // simulate a call sender with 10 ether
        vm.prank(sender);

        (bool success,) = address(spendCoin).call{value: 10 ether}("");
        require(success, "SOMETHING WENT WRONG");

        // 10000000000000000000  = 10 ether
        assertEq(address(recipient).balance, 10 ether);
    }

    function testSendBNB() public {
        assertEq(bnbSender.balance, 100 ether, "bnbSender should have 100 ether");
        // simulate a call sender with 10 ether
        vm.prank(bnbSender);

        spendCoin.transferBNB{value: 10 ether}(10 ether);

        // 10000000000000000000  = 10 ether
        assertEq(recipient.balance, 10 ether, "Recipient should receive 10 ether");
    }

    function testSetNewRecipient() public {
        // simulate a call sender with 10 ether
        vm.prank(recipient);

        spendCoin.addAllowedRecipient(newRecipient2);
        spendCoin.updateRecipient(payable(newRecipient2));

        // 10000000000000000000  = 10 ether
        assertEq(spendCoin.recipient(), newRecipient2, "Recipient was successfull");
    }
}
