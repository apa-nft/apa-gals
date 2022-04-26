const { ethers } = require("ethers");
const fs = require('fs');
const provider = new ethers.providers.WebSocketProvider('wss://speedy-nodes-nyc.moralis.io/a27119144876c9a3da4aba9f/avalanche/mainnet/ws');
let abiJson = fs.readFileSync('ApaAbi.json');
const apaAbi = JSON.parse(abiJson);
apaContract = new ethers.Contract('0x880Fe52C6bc4FFFfb92D6C03858C97807a900691',apaAbi , provider ); // for read only, change with signer


async function getHolders(start, target, apaMansionList){
    for (let i = start; i < target; i++) {
        const result = await apaContract.ownerOf(i)
        if (result == "0x770a4C7f875fb63013a6Db43fF6AF9980fcEb3b8"){
          continue;
        }
        apaMansionList.push(result);
    }
    return apaMansionList    
  }




function createPreviousWinnersDict(lotteryWinners) {
    const lotteryWinnersDict = fs.readFileSync(lotteryWinners)
    const data = JSON.parse(lotteryWinnersDict.toString());
    const winnersDict = {}
    data.forEach(function(value){
        winnersDict[value['address']] = true
      });
    return winnersDict;
}


createPreviousWinnersDict('lotteryWinners.json')