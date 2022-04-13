import M from "./merkleGenerator";
import Lucky from "../lotteryWinners.json";

console.log(M.getRootAndCount(Lucky));
console.log(M.getProofAndTotalGiven("0x328739e4901Cd242072353Ec377D72Fb87EcA876",Lucky));
