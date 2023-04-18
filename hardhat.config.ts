import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require('dotenv').config();

const getAccounts:any = [process.env.ACCOUNT_1,process.env.ACCOUNT_2,process.env.ACCOUNT_3,process.env.ACCOUNT_4,process.env.ACCOUNT_5,process.env.ACCOUNT_6]

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  networks: {
    goerli: {
      url: process.env.GOERLI_RPC_NODE,
      accounts: getAccounts
    },
    sepolia: {
      url: process.env.SEPOLIA_RPC_NODE,
      accounts: getAccounts
    }
  }
};

export default config;