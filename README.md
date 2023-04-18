# Ethereum Escrow Contract

A simple Ethereum escrow contract that handles payments between a payer and a payee. The contract is designed to be secure and efficient, utilizing the EIP-1167 Minimal Proxy contract pattern for contract deployment.

## Overview

This repository contains the source code for two smart contracts:

1. `Escrow.sol`: Contains the business logic for the ETH Escrow, used for handling payments between a payer and a payee.
2. `EscrowFactory.sol`: Serves as a factory for creating and managing Escrow contracts.

The smart contracts are written in Solidity version 0.8.18 and are compiled and deployed using Hardhat with TypeScript.

## Features

- Secure: Utilizes Solidity 0.8.18 for built-in overflow and underflow protection.
- Efficient: Employs the EIP-1167 Minimal Proxy contract pattern for optimized contract deployment.
- Flexible: Allows the payee to edit the price and the payer to cancel the deposit.

## EIP-1167

EIP-1167 is a minimal proxy contract pattern that enables the deployment of proxy contracts with minimal overhead. It reduces the gas cost of contract deployment by using a minimal proxy contract that delegates calls to a shared implementation contract. This approach allows for significant gas savings when deploying multiple instances of the same contract logic.

## Other Contracts Used

1. `Initializable.sol`: A utility contract from OpenZeppelin to manage the initialization of the escrow contract.
2. `Address.sol`: A library contract from OpenZeppelin that provides functions to safely transfer ETH.
3. `Ownable.sol`: A utility contract from OpenZeppelin that provides a simple access control mechanism for contract ownership.

## Getting Started

To compile and deploy the smart contracts, you will need to install [Hardhat](https://hardhat.org/) and [Node.js](https://nodejs.org/). Follow the steps below to set up the project:

1. Clone the repository:
<pre>
```
git clone https://github.com/kirilradkov14/escrow-contract.git
```
</pre>
2. Change to the project directory:
<pre>
```
cd escrow-contract
```
</pre>
3. Install dependencies:
<pre>
```
npm install
```
</pre>
4. Compile the smart contracts:
<pre>
```
npx hardhat compile
```
</pre>
5. Deploy the smart contracts to a local test network:
<pre>
```
npx hardhat run --network localhost scripts/deploy.ts
```
</pre>

## License

This project is licensed under the MIT License.
