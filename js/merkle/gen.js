"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const merkleGenerator_1 = __importDefault(require("./merkleGenerator"));
const lotteryWinners_json_1 = __importDefault(require("../lotteryWinners.json"));
console.log(merkleGenerator_1.default.getRootAndCount(lotteryWinners_json_1.default));
