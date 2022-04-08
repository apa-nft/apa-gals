const { ethers } = require("ethers");
const { log } = require("console");
const fs = require('fs');

const readline = require('readline').createInterface({
    input: process.stdin,
    output: process.stdout
  })
const provider = new ethers.providers.WebSocketProvider('wss://speedy-nodes-nyc.moralis.io/a27119144876c9a3da4aba9f/avalanche/testnet/ws');
let abiJson = fs.readFileSync('lottery.json');
const apaLotteryABI = JSON.parse(abiJson);
APALottery = new ethers.Contract('0xc2455c6f01250cbbf20231a0d8f0d55dc6804a44' , apaLotteryABI , provider ); // for read only, change with signer

const loadData = (path) => {
    try {
      return fs.readFileSync(path, 'utf8')
    } catch (err) {
      console.error(err)
      return false
    }
}
const holderList =  JSON.parse(loadData('lucky10kHolders.json'));


let winnerIdCount = 1;
let winnerDict = {};
let duplicate = {}
APALottery.on('winnerId', function(id){

    index = id.toNumber();
    console.log("Id: ",index, winnerIdCount);
    let winnerAddress = holderList[index];
    if (winnerAddress in winnerDict){
        let currentCount = winnerDict[winnerAddress];
        winnerDict[winnerAddress] = currentCount + 1;
    }
    else{
        winnerDict[winnerAddress] = 1;
    }
    winnerIdCount++;    
    if(winnerIdCount == 901){
        convertWinnerIdDictToMerkleList(winnerDict)
    }
    
});

function convertWinnerIdDictToMerkleList(dict) {
    let lotteryWinners = [];
    for (const [key, value] of Object.entries(dict)) {
        let temp_dict = {'address':key, 'totalGiven': value};
        lotteryWinners.push(temp_dict);
        
    }
      let list = JSON.stringify(lotteryWinners);
      fs.writeFileSync('lotteryWinners.json', list)
        
 }





