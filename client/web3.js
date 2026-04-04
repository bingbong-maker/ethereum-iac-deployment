const Web3 = require("web3");

//Connect to RPC node (port 8547 from docker-compose)
const web3 = new Web3("http://localhost:8547");

(async () => {
    try {
        const blockNumber = await web3.eth.getBlockNumber();
        console.log("Current block number:", blockNumber);

        const accounts = await web3.eth.getAccounts();
        console.log("Accounts:", accounts);
    } catch (err) {
        console.error("Error connecting to node:", err);
    }
})();