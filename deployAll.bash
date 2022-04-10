#!/bin/bash

forge create APALottery --rpc-url $ETH_RPC_URL --private-key $PRIV_KEY --from $ETH_FROM

forge create APAGals --rpc-url $ETH_RPC_URL --private-key $PRIV_KEY --from $ETH_FROM --constructor-args "APA Gals" --constructor-args "APAG" --constructor-args "https://partyanimals.xyz/apagals/id/"

forge create APAGalMarket --rpc-url $ETH_RPC_URL --private-key $PRIV_KEY --from $ETH_FROM --constructor-args "0x2f6A61279BBAf96Ef567d625cAc8082cFDb9096B" --constructor-args "3" 

forge flatten src/Market.sol -o MarketFlattened.sol
forge flatten src/APALottery.sol -o APALotteryFlattened.sol
forge flatten src/APAGals.sol -o APAGalsFlattened.sol
