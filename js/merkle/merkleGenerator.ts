import { ethers } from "ethers";
import MerkleTree from "./Merkle";

const UNIQUE_ERROR = "List shouldn't have repeated addresses.";

export interface AirdropObject {
  totalGiven: number;
  address: string;
}

function hashToken(account: string, totalGiven: number) {
  return Buffer.from(
    ethers.utils.solidityKeccak256(["address", "uint256"], [account, totalGiven]).slice(2),
    "hex"
  );
}

function generateTree(airdropList: AirdropObject[]) {
  let uniques = new Set<string>();

  let hashedLeaves: Buffer[] = [];
  for (let i = 0; i < airdropList.length; i++) {
    if (uniques.has(airdropList[i].address)) {
      console.log(airdropList[i].address);
      // throw "Airdrop list has repeated elements. Fix it."
    }
    uniques.add(airdropList[i].address);

    hashedLeaves.push(hashToken(airdropList[i].address, airdropList[i].totalGiven));
  }
  hashedLeaves = hashedLeaves.sort();
  return new MerkleTree(hashedLeaves);
}

function getRootAndCount(airdropList: AirdropObject[]): [string, number] {
  let tree = generateTree(airdropList);
  let totalCount = 0;
  for (let obj of airdropList) {
    totalCount += obj.totalGiven;
  }

  return [tree.getHexRoot(), totalCount];
}

function getProofAndTotalGiven(address: string, airdropList: AirdropObject[]): [string[], number] {
  let tree = generateTree(airdropList);

  let result = airdropList.filter(obj => obj.address.toLowerCase() == address.toLowerCase());

  if (result.length > 1) throw "Airdrop list has repeated elements. Fix it.";

  let hashedLeaf = hashToken(result[0].address, result[0].totalGiven);

  return [tree.getHexProof(hashedLeaf), result[0].totalGiven];
}

export default {
  getRootAndCount,
  getProofAndTotalGiven
};
