"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const ethers_1 = require("ethers");
const Merkle_1 = __importDefault(require("./Merkle"));
const UNIQUE_ERROR = "List shouldn't have repeated addresses.";
function hashToken(account, totalGiven) {
    return Buffer.from(ethers_1.ethers.utils.solidityKeccak256(["address", "uint256"], [account, totalGiven]).slice(2), "hex");
}
function generateTree(airdropList) {
    let uniques = new Set();
    let hashedLeaves = [];
    for (let i = 0; i < airdropList.length; i++) {
        if (uniques.has(airdropList[i].address)) {
            console.log(airdropList[i].address);
            // throw "Airdrop list has repeated elements. Fix it."
        }
        uniques.add(airdropList[i].address);
        hashedLeaves.push(hashToken(airdropList[i].address, airdropList[i].totalGiven));
    }
    hashedLeaves = hashedLeaves.sort();
    return new Merkle_1.default(hashedLeaves);
}
function getRootAndCount(airdropList) {
    let tree = generateTree(airdropList);
    let totalCount = 0;
    for (let obj of airdropList) {
        totalCount += obj.totalGiven;
    }
    return [tree.getHexRoot(), totalCount];
}
function getProofAndTotalGiven(address, airdropList) {
    let tree = generateTree(airdropList);
    let result = airdropList.filter(obj => obj.address.toLowerCase() == address.toLowerCase());
    if (result.length > 1)
        throw "Airdrop list has repeated elements. Fix it.";
    let hashedLeaf = hashToken(result[0].address, result[0].totalGiven);
    return [tree.getHexProof(hashedLeaf), result[0].totalGiven];
}
exports.default = {
    getRootAndCount,
    getProofAndTotalGiven
};
