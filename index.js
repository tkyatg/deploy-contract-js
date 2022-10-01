fs = require("fs");

const file = fs.readFileSync("./contract/base.sol").toString();
console.log(file);
