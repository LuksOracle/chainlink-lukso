const Web3 = require('web3')

const rpcURL = "https://rpc.l16.lukso.network"// Your RPC URL goes here
const web3 = new Web3(rpcURL)

const controllerPrivateKey = "0x" + process.env.devTestnetPrivateKey;
const myUpAddress = '0x8414F1BaC5fCdA2C274A4a78D0D62109f1Cbb6C8';

const UniversalProfileContract = require('@lukso/lsp-smart-contracts/artifacts/UniversalProfile.json');
const KeyManagerContract = require('@lukso/lsp-smart-contracts/artifacts/LSP6KeyManager.json');

async function myFunction() {

const myUniversalProfile = new web3.eth.Contract(
  UniversalProfileContract.abi,
  myUpAddress,
);

const keyManagerAddress = await myUniversalProfile.methods.owner().call();
// console.log(keyManagerAddress)
const KeyManager = new web3.eth.Contract(
  KeyManagerContract.abi,
  keyManagerAddress,
);

const controllerAccount =
  web3.eth.accounts.privateKeyToAccount(controllerPrivateKey);
const channelId = 0; // Can be any number that your app will use frequently.
// Channel IDs prevent nonce conflicts, when many apps send transactions to your keyManager at the same time.

const nonce = await KeyManager.methods
  .getNonce(controllerAccount.address, channelId)
  .call();

  const abiPayload = myUniversalProfile.methods.execute(
      0, // The OPERATION_CALL value. 0 for a LYX transaction
      '0xE1Ec78D6170d632D540948a3D53982209E32A007', // Recipient address
      web3.utils.toWei('0'), // amount of LYX to send in wei
      '0x7cc201d200000000000000000000000066c1d8a5ee726b545576a75380391835f8aaa43c' // Call data, to be called on the recipient address, or '0x'
  ).encodeABI() ;

  const chainId = await web3.eth.getChainId(); // will be 2828 on l16

const message = web3.utils.soliditySha3(chainId, keyManagerAddress, nonce, {
  t: 'bytes',
  v: abiPayload,
});

const signatureObject = controllerAccount.sign(message);
const signature = signatureObject.signature;

console.log(signature)
console.log(nonce)
console.log(abiPayload)

// const executeRelayCallTransaction = await KeyManager.methods
//   .executeRelayCall(signature, nonce, abiPayload)
//   .send();

}

myFunction();
