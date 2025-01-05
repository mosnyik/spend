// SPDX-Licence-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {SpendToken} from "../src/SpendToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract spendUSDTBEP20 is Test {
    SpendToken public spendBEP20;
    address constant USDTBEP20 = 0x55d398326f99059fF775485246999027B3197955;

    //vm.envString is provided by Foundry so that we can read our .env file and get values from there
    string BNB_MAINNET_RPC_URL = vm.envString("BNB_MAINNET_RPC_URL");

    uint256 mainnetFork;
    IERC20 public usdtToken;

    address public spender = address(1);
    address public recipient = address(2);

    function setUp() public {
        // mock fork of the mainnet
        mainnetFork = vm.createFork(BNB_MAINNET_RPC_URL);
        // select the fork obtained using its id
        vm.selectFork(mainnetFork);

        //fetch the USDT-ERC20 contract
        usdtToken = IERC20(USDTBEP20);
        spendBEP20 = new SpendToken(USDTBEP20, recipient);
    }

    function testSpendBEP20() public {
        uint256 BALANCE_AMOUNT_USDT = 2000 ether;

        // fund my accounts
        deal(USDTBEP20, spender, BALANCE_AMOUNT_USDT);
        deal(USDTBEP20, recipient, 0);

        assertEq(IERC20(USDTBEP20).balanceOf(spender), BALANCE_AMOUNT_USDT, "SPENDER WALLET FUNDED");
        assertEq(IERC20(USDTBEP20).balanceOf(recipient), 0, "RECIPIENT WALLET EMPTY");

        vm.prank(spender);
        // send the usdt
        usdtToken.approve(address(spendBEP20), 500 ether);

        vm.prank(spender);
        spendBEP20.transferUSDTFrom(500 ether, recipient);

        assertEq(IERC20(USDTBEP20).balanceOf(spender), 1500 ether, "Sender should have 90 ether");
        assertEq(IERC20(USDTBEP20).balanceOf(recipient), 500 ether, "Recipient should have 10 ether");
    }
}

contract spendUSDTERC20 is Test {
    SpendToken public spendERC20;
    address USDTERC20 = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

    //vm.envString is provided by Foundry so that we can read our .env file and get values from there
    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    uint256 mainnetFork;
    IERC20 public usdtToken;

    address public spender = address(1);
    address public recipient = address(2);

    function setUp() public {
        // mock fork of the mainnet
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
        // select the fork obtained using its id
        vm.selectFork(mainnetFork);

        //fetch the USDT-ERC20 contract
        usdtToken = IERC20(USDTERC20);
        spendERC20 = new SpendToken(USDTERC20, recipient);
    }

    // function testSpendERC20 () public {
    //      uint256 BALANCE_AMOUNT_USDT = 2000 ether;

    //      // fund my accounts
    //     deal(USDTERC20, spender, BALANCE_AMOUNT_USDT);
    //     deal(USDTERC20, recipient, 0);

    //     assertEq(IERC20(USDTERC20).balanceOf(spender), BALANCE_AMOUNT_USDT, "SPENDER WALLET FUNDED" );
    //     assertEq(IERC20(USDTERC20).balanceOf(recipient), 0, "RECIPIENT WALLET EMPTY" );

    //     vm.prank(spender);
    //     // send the usdt
    //     usdtToken.approve(address(spendERC20), 500 ether);

    //      vm.prank(spender);
    //     spendERC20.transferUSDTFrom(500 ether, recipient);

    //     assertEq(IERC20(USDTERC20).balanceOf(spender), 1500 ether, "Sender should have 90 ether");
    //     assertEq(IERC20(USDTERC20).balanceOf(recipient), 500 ether, "Recipient should have 10 ether");
    // }
}
