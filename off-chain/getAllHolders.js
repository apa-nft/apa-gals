const { ethers } = require("ethers");
const fs = require('fs');
const provider = new ethers.providers.WebSocketProvider('wss://speedy-nodes-nyc.moralis.io/a27119144876c9a3da4aba9f/avalanche/mainnet/ws');
let abiJson = fs.readFileSync('ApaAbi.json');
const apaAbi = JSON.parse(abiJson);
apaContract = new ethers.Contract('0x880Fe52C6bc4FFFfb92D6C03858C97807a900691',apaAbi , provider ); // for read only, change with signer



const loadData = (path) => {
    try {
      return fs.readFileSync(path, 'utf8')
    } catch (err) {
      console.error(err)
      return false
    }
}


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



async function getHoldersAtAGivenBlock(start, target){
  mylist = []
  for (let i = start; i < target; i++) {
      const result = await apaContract.ownerOf(i ,{ blockTag: 13979378 })
      if (result == "0x770a4C7f875fb63013a6Db43fF6AF9980fcEb3b8"){
        continue;
      }
      console.log(result);
      mylist.push(result);
  }
  var json = JSON.stringify(mylist);
  fs.writeFileSync('lucky10000Holders13979378.json', json)
  return mylist  
}

getHoldersAtAGivenBlock(0,10000)

