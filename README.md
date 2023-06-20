# LuksOracle

Chainlink oracle on Lukso blockchain which supports API uint256 GET requests.

Note:

## Starting the Chainlink node on Lukso with WSS RPC URL:

0. Fork this repository/folder.

:warning: Note: if running on Windows, use WSL2, and fork the repository onto /home rather than /mnt. Otherwise, Chainlink will be unable to connect to pgSQL :warning:

1. Create a "data" folder inside the "chainlink-lukso" directory [holds PostgreSQL database].

2. Create an ".env" file inside the "chainlink-lukso" directory with the following in chainlink-lukso [we are using a public WSS RPC URL]:

```
ROOT=/chainlink
LOG_LEVEL=debug
ETH_CHAIN_ID=2828
CHAINLINK_TLS_PORT=0
SECURE_COOKIES=false
ALLOW_ORIGINS=*
ETH_URL=wss://ws.rpc.l16.lukso.network
DATABASE_URL=postgresql://postgres:secret@chainlink-lukso-pg_chainlink-1:5432/chainlink-lukso?sslmode=disable
```

3. Update directories to match your file system for "docker-compose.yml"

4. Run the following in command line:

```shell
cd chainlink-lukso
docker compose up
OR
sudo docker-compose up
```

:warning: If you get error
```shell
ERROR: The Compose file './docker-compose.yml' is invalid because:
Unsupported config option for services: 'pg_chainlink'
```
you will need to upgrade docker-compose to version 1.28.0 for service support:

```shell
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

then allow the binary to run:

```shell
sudo chmod +x /usr/local/bin/docker-compose
```

check version:

```shell
docker-compose -v
```

Make sure you also install PostgreSQL: 
```shell
sudo apt-get -y install postgresql
```


:warning: Note: if a port is being used, end the process in the port with: :warning:

```shell
sudo lsof -i tcp:5432
```
[SHOWS PROCESS ID IN TCP PORT 5432, EXAMPLE: 25537]:
```shell
sudo kill 25537
```

:warning: Note: if there is an issue with your node, run the following (will wipe Docker and PostgreSQL files for a clean node): :warning:

```shell
cd chainlink-lukso
sudo docker rm -vf $(sudo docker ps -aq)
sudo docker rmi -f $(sudo docker images -q)
sudo rm -r -f data
```

5. Test Chainlink Node v2.2.0 with TOML files

Enter directory
```shell
cd chainlink-lukso 
```
Start Chainlink Node
```shell
sudo docker run --platform linux/x86_64/v8 --name chainlink -v /chainlink-lukso:/chainlink -it -p 6688:6688 --add-host=host.docker.internal:host-gateway smartcontract/chainlink:2.2.0 node -config /chainlink/config.toml -secrets /chainlink/secrets.toml start
```

sudo docker run --platform linux/x86_64/v8 --name chainlink -v $HOME/.chainlink-lukso:/chainlink -it -p 6688:6688 --add-host=host.docker.internal:host-gateway smartcontract/chainlink:2.2.0 node -config /chainlink/config.toml -secrets /chainlink/secrets.toml start

6. Interact with Chainlink node interface in weB browser URL:


http://localhost:6688/

