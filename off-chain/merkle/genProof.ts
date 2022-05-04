import M from "./merkleGenerator";
import Lucky from "./newLotteryWinners.json";

console.log(M.getRootAndCount(Lucky));
console.log(M.getProofAndTotalGiven("0xB555F4A58Af40B1B4854010fA85Adb4dF2C81e69",Lucky));
