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

async function getAll(start, target, apaMansionList){
    var apaMansionList = [];
    await getHolders(0,1000,apaMansionList);
    await getHolders(1000,2000,apaMansionList);
    await getHolders(2000,3000,apaMansionList);
    await getHolders(3000,4000,apaMansionList);
    await getHolders(4000,5000,apaMansionList);
    await getHolders(5000,6000,apaMansionList);
    await getHolders(6000,7000,apaMansionList);
    await getHolders(7000,8000,apaMansionList);
    await getHolders(8000,9000,apaMansionList);
    await getHolders(9000,10000,apaMansionList);
    console.log('Len: ', apaMansionList.lenght);
    var json = JSON.stringify(apaMansionList);
    fs.writeFileSync('lucky10000Holders.json', json)
}
function test_list2(){
    let total = 0;
    let ctr = 0;
    list = JSON.parse(loadData('lucky10000Holders.json'));
    console.log(list[2]);
    console.log(Object.keys(list).length);

}
//get10kHolders()
//.then((result)=>{
//var json = JSON.stringify(result);
//console.log(json)
//fs.writeFileSync('lucky10kHolders.json', json)
//});
//test_list2();

//getAll();
test_list2();