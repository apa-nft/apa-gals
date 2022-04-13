
const loadData = (path) => {
    try {
      return fs.readFileSync(path, 'utf8')
    } catch (err) {
      console.error(err)
      return false
    }
}
const fs = require('fs');
const x = {'0x123123123213123213': 1, '0x345348543543985': 2, '0x12312312312321312' : 3};
function convertWinnerIdDictToMerkleList(dict) {
    let lotteryWinners = [];
    for (const [key, value] of Object.entries(dict)) {
        let temp_dict = {'address':key, 'totalGiven': value};
        lotteryWinners.push(temp_dict);
        
    }
      let list = JSON.stringify(lotteryWinners);
      fs.writeFileSync('lotteryWinners.json', list)
        
 }

 //convertWinnerIdDictToMerkleList(x);
 const holderList =  JSON.parse(loadData('holdersList.json'));
 console.log(holderList[27])