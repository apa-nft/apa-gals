### Workflow for APA Gals Lottery

1. Pick all holders at a given point in time. 

   `node getAllHolder.js`

   This will write all the holder to a json file called `lucky10000Holders.json`. Keep in mind that the marketplace is excluded and the list will have less than 10000 in the end.

2. Generate the onchain [seed](https://snowtrace.io/address/0xEB85eC0BCF12319454FCF7a3632Bc601F0b52BD2#events) and read it from the contract events 

3. Generate the `lotteryWinners.json` to feed into the Merkle Tree.

4. Generate the Merkle tree root and use it in the Apa Gals contract.

   1. Assuming you have a `ts-config.json`, and `tsc` installed, you simply navigate to the `merkle` folder:
      ```
      tsc
      node gen.js
      ```
      This will generate and print the Merkle root and the total quantity.

   2. Call the set root function from the contract with the root.

   3. To generate a proof for testing, you can edit the `genProof.js` (assuming it is already generated with `tsc`) and change the address there. The script will output the proof and the allowance for the given address.

#### Typescript related issues

* You have to generate the config file with `tsc --init`if it doesnt exist. If the compilation fails due to some error, you might wanna check the config file and edit it. `"resolveJsonModule": true,` had to be out-commented in our case.

* If you are starting from scratch with only `.ts` files, you will need to run:

  ```
  npm i --save-dev @types/node
  npm install ethers --save-dev
  npm install ethereumjs-util --save-dev
  ```


### Contracts

|          |                                            |
| -------- | ------------------------------------------ |
| APA Gals | 0x7600088fb72941a9139669d7f6cb4e717ec05c87 |
| Market   | 0x9615fc5890f4585b14aabf433d0f73aacffec348 |
| Lottery  | 0xEB85eC0BCF12319454FCF7a3632Bc601F0b52BD2 |



