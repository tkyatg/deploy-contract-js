fs = require("fs");
solc = require("solc");

const file = fs.readFileSync("simple-contract/initial.sol").toString();
const input = {
  language: "Solidity",
  sources: {
    "simple-contract/initial.sol": {
      content: file,
    },
  },

  settings: {
    outputSelection: {
      "*": {
        "*": ["*"],
      },
    },
  },
};

const output = JSON.parse(solc.compile(JSON.stringify(input)));
console.log("Result : ", output); // solidity compile and json parse result.
const abi = output.contracts["simple-contract/initial.sol"]["initial"].abi;
console.log("ABI: ", abi); // need for access to contract
const bytecode =
  output.contracts["simple-contract/initial.sol"]["initial"].evm.bytecode
    .object;
console.log("BYTE_CODE: ", bytecode); // use for deploy contract
