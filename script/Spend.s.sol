// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.25;

// import {Script, console} from "forge-std/Script.sol";
// import {SpendCoin} from "../src/SpendCoin.sol";

// contract Spend is Script {
//     function run() external {
//         // deployment private key from env
//         uint256 deploymentPrivateKey = vm.envUint("LOCAL_TEST_NET_PRIVATE_KEY");
//         address recipient = vm.parseAddress("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266");

//         // broadcast the transaction using the deployerPrivateKey
//         vm.startBroadcast(deploymentPrivateKey);

//         // Deploy the contract
//         SpendCoin spendCoin = new SpendCoin(payable(recipient));

//         // log the deployed contract address in the console
//         console.log("Deployed contract address:", address(spendCoin));

//         // stop braodcasting the transaction
//         vm.stopBroadcast();
//     }
// }
