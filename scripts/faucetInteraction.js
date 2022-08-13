//Source material: https://www.dappuniversity.com/articles/web3-js-intro

//Need to import web3 Linux:
//sudo npm install web3

//RPC LOCAL [LIKE GANACHE], TESTNET [ACTUAL BLOCKCHAIN TO CONNECT TO LIKE RINKEBY]
const createRawTransaction = require('ethereumjs-tx').Transaction;
const common = require('ethereumjs-common');
const Web3 = require('web3')

const devWalletaddress = '0xc1202e7d42655F23097476f6D48006fE56d38d4f' // Your account address goes here
const devTestnetPrivateKey = Buffer.from(process.env.devTestnetPrivateKey, 'hex')

const rpcURL = 'wss://ws.rpc.l16.lukso.network' // Your RPC URL goes here
const web3 = new Web3(rpcURL)

//HIDE KEY WITH "Linux Environment Variables" https://www.youtube.com/watch?v=himEMfYQJ1w

const contractAddress_JS = '0xE1Ec78D6170d632D540948a3D53982209E32A007'
const contractABI_JS =
[{"anonymous":false,"inputs":[],"name":"faucetWithdraw","type":"event"},{"inputs":[],"name":"withdrawDirect","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"relayCaller","type":"address"}],"name":"withdrawRelay","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"relayAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"userPreviousWithdrawTime","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]
const contractDefined_JS = new web3.eth.Contract(contractABI_JS, contractAddress_JS)

//Check if value was set
function checkValueLatest() {
  contractDefined_JS.methods.relayAddress().call((err, balance) => {
    console.log({ err, balance })
  })
}

function createAndSendTx() {
  // Transfer some tokens
    web3.eth.getTransactionCount(devWalletaddress, (err, txCount) => {
      const txObject = {
        nonce:    web3.utils.toHex(txCount),
        gasLimit: web3.utils.toHex(30000), // Raise the gas limit to a much higher amount
        gasPrice: web3.utils.toHex(web3.utils.toWei('10', 'gwei')),
        to: contractAddress_JS,
        data: contractDefined_JS.methods.withdrawRelay("0x66C1d8A5ee726b545576A75380391835F8AAA43c").encodeABI()
    }

    console.log("DATA: ")
    console.log(contractDefined_JS.methods.withdrawRelay("0x66C1d8A5ee726b545576A75380391835F8AAA43c").encodeABI())

    // const chain = common.default.forCustomChain(
    //   'mainnet',{
    //     name: 'l16',
    //     networkId: 2828,
    //     chainId: 97
    //   },
    //   'petersburg'
    // )
    // var rawTx = new createRawTransaction(rawData, {common: chain});
    //
    // tx.sign(devTestnetPrivateKey)
    // const serializedTx = tx.serialize()
    // const raw = '0x' + serializedTx.toString('hex')
    // // Broadcast the transaction hash and check for errors
    //   web3.eth.sendSignedTransaction(raw, (err, txHash) => {
    //   console.log('err:', err, 'txHash:', txHash)
    // })

  })
}

checkValueLatest();
createAndSendTx();

const web3Sub = new Web3(process.env.rinkebyWebSocketSecureEventsInfuraAPIKey)
const eventsListener = new web3Sub.eth.Contract(contractABI_JS, contractAddress_JS)

// //Subscribe to event.
eventsListener.events.faucetWithdraw({
     fromBlock: 'latest'
 }, function(error, eventResult){})
 .on('data', function(eventResult){
    //console.log(eventResult)
   //Call the get function to get the most accurate present state for the value.
   console.log("EVENT DETECTED! NEW STATE VALUE: ")

   checkValueLatest();

   })
 .on('changed', function(eventResult){
     // remove event from local database
 })
 .on('error', console.error);
