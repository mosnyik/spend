## SpendETH Contract


The SpendETH Contract is an Ethereum smart contract designed to forward any received Ether (ETH) to a predefined recipient address. The recipient address can also be updated dynamically. Built with Foundry, this project ensures a robust and gas-efficient solution for ETH forwarding.

## 🚀 Features

Automatically forwards received ETH to a specified recipient.
Allows updating the recipient address securely.
Includes comprehensive error handling for invalid transactions or recipients.
Fully tested using Foundry's testing framework.

 
## 🌟 Prerequisites
Before you proceed, ensure you have the following installed:

Foundry: Follow the installation guide.
Node.js (optional, if integrating with frontend projects).
Git for cloning the repository.

## 🛠️ Installation

1. Clone the repository:

```bash
git clone https://github.com/mosnyik/spend.git
cd spendeth

```

2. Install Foundry:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```


## 💻 Usage
1. Build the Project

Compile the smart contract:

```bash

forge build

```

2. Run Tests
Run the test suite to ensure the contract functions as expected:

```bash
forge test
```

3. Deploy the Contract
Start a local Ethereum node using Anvil:

```bash
anvil
```
Deploy the contract using Foundry's scripting tool:


```bash
forge script script/SpendETH.s.sol:SpendETHScript --rpc-url http://127.0.0.1:8545 --private-key <your_private_key>
```

Replace <your_private_key> with the private key of the account you want to deploy the contract with.


## 🤝 Interacting with the Contract
### Send ETH
To send ETH to the contract, simply transfer Ether to the deployed contract's address. It will automatically forward the ETH to the predefined recipient.

### Update Recipient
Call the updateRecipient function to change the recipient:

```bash
contract.updateRecipient("0xNewRecipientAddress");

```
### Gas Snapshots
To generate a gas report:

```bash
forge snapshot
```

## Helpful Foundary Commands
#### Formatting Code
```bash
forge fmt
```
#### Start Local Node
```bash
anvil
```
#### Casting Commands
Use cast to interact with the blockchain directly:

```bash
cast send <contract_address> "updateRecipient(address)" <new_recipient_address>
```

### License
This project is licensed under the MIT License. Feel free to use and modify the project as needed.

For issues or feature requests, please open an issue on GitHub or contact the project maintainer.

