# LuksOracle

Chainlink oracle on Lukso blockchain which supports API uint256 GET requests.

Note: 

## Starting the Chainlink node on Lukso with WSS RPC URL:

0. Fork this repository/folder.

:warning: Note: if running on Windows, use WSL2, and fork the repository onto /home rather than /mnt. Otherwise, Chainlink will be unable to connect to pgSQL :warning: 

1. Create a "data" folder inside the "chainlink-lukso" directory [holds PostgreSQL database].

2. Create an ".env" file inside the "chainlink-lukso" directory with the following in chainlink-lukso [we are using a public WSS RPC URL]:
    
        ROOT=/chainlink
        LOG_LEVEL=debug
        ETH_CHAIN_ID=2828
        CHAINLINK_TLS_PORT=0
        SECURE_COOKIES=false
        ALLOW_ORIGINS=*
        ETH_URL=wss://ws.rpc.l16.lukso.network
        DATABASE_URL=postgresql://postgres:secret@chainlink-lukso-pg_chainlink-1:5432/chainlink-lukso?sslmode=disable

3. Update directories to match your file system for "docker-compose.yml"

4. Run the following in command line:

        cd chainlink-lukso
        docker compose up

:warning: Note: if there is an issue with your node, run the following (will wipe Docker and PostgreSQL files for a clean node): :warning:

        cd chainlink-lukso
        docker rm -vf $(docker ps -aq)
        docker rmi -f $(docker images -aq)
        sudo rm -r -f data

5. Interact with Chainlink node interface in weB browser URL:

        http://localhost:6688/

## Lukso Chainlink Contracts

Lukso LINK: https://explorer.execution.l16.lukso.network/address/0xbFB26279a9D28CeC1F781808Da89eFbBfE2c4268/transactions

(From Ethereum Mainnet LINK: https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca#code)

LINK Faucet deployed (20 LINK every 12 hours direct and with Lukso Universal Profile Key Manager transaction relay option) 
https://explorer.execution.l16.lukso.network/address/0xcaa48809Dd9E46F8Cc7523Afd9EbD7909F2E5D5b/transactions

Lukso Oracle.sol (redeploy and save contract): https://explorer.execution.l16.lukso.network/address/0x401ae6Bfb89448fB6e06CE7C9171a8A0366d02d0/transactions

Lukso requestGETuint256.sol (redeploy and save contract): https://explorer.execution.l16.lukso.network/address/0x090b750b9B5251828E16360Fd69100dc4c674e71/transactions
