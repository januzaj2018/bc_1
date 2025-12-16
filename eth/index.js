
const API_KEY = "I1KSHIWNBXWSPKPM2TCNE7AY1QAHUM9NSC";
const TX_HASH = "0xe9bd7e3a4d02c7bd9e8468dc206e7c3b16a5eb65865b65b3bd701278e2c50e0b";
function hexToDecimalBigInt(hex) {
    if (!hex) return BigInt(0);
    return BigInt(hex);
}

function hexToBigInt(hex) {
    const clean = hex.startsWith("0x") ? hex.slice(2) : hex;
    const v = BigInt("0x" + clean);
    return v;
}

function parseWord(word) {
    if (word.startsWith("0x")) word = word.slice(2);
    const hex = "0x" + word;
    const value = hexToBigInt(word);
    return {
        hex: hex,
        decimal: value.toString(10)
    };
}

function extractAddressesFromWord(word) {
    const w = word.startsWith("0x") ? word.slice(2) : word;
    if (w.length !== 64) return null;
    const last20 = w.slice(64 - 40);
    if (/^[0-9a-fA-F]{40}$/.test(last20)) {
        return "0x" + last20;
    }
    return null;
} function weiToEther(wei) {
    const WEI_IN_ETH = BigInt(10) ** BigInt(18);
    const eth = wei / WEI_IN_ETH;
    const remainder = wei % WEI_IN_ETH;
    const fractional = remainder.toString().padStart(18, '0').substring(0, 4);

    return `${eth}.${fractional}`;
}

async function getTransactionDetails(txhash, apiKey) {
    const apiUrl = `https://api.etherscan.io/v2/api?chainid=1&module=proxy&action=eth_getTransactionByHash&txhash=${TX_HASH}&apikey=${apiKey}`;
    console.log(`Fetching details for: ${txhash}`);
    const apiUrl2 = `https://api.etherscan.io/v2/api?chainid=1&module=proxy&action=eth_getTransactionReceipt&txhash=${TX_HASH}&apikey=${apiKey}`
    try {
        const response = await fetch(apiUrl);
        // const response2 = await fetch(apiUrl2)
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        // const data2 = await response2.json();
        if (!data.result || data.status === "0") {
            console.error("Error/Result not found:", data.message || "No transaction data returned. Check hash/network.");
            return null;
        }
        // const gasUsage = hexToDecimalBigInt(data2.result.gasUsed);
        const tx = data.result;
        const nonce = hexToDecimalBigInt(tx.nonce);
        const gasPriceWei = hexToDecimalBigInt(tx.gasPrice);
        const gasPriceGwei = Number(gasPriceWei) / 1e9; // 1 Gwei = 10^9 Wei
        const gasLimit = hexToDecimalBigInt(tx.gas);
        const valueWei = hexToDecimalBigInt(tx.value);
        const valueEth = weiToEther(valueWei);
        const inputData = tx.input;
        const fromAddress = tx.from;
        const toAddress = tx.to;

        console.log("\nDECODED TRANSACTION DETAILS");
        console.log(`Hash: ${tx.hash}`);
        console.log(`Block Number: ${hexToDecimalBigInt(tx.blockNumber).toString()}`);
        console.log(` Nonce: ${nonce.toString()}`);
        console.log(` From: ${fromAddress}`);
        console.log(` To: ${toAddress}`);
        console.log(` Value: ${valueEth} ETH (${valueWei.toString()} Wei)`);
        console.log(` Gas Price: ${gasPriceGwei.toFixed(2)} Gwei (${gasPriceWei.toString()} Wei)`);
        console.log(` Gas Limit: ${gasLimit.toString()} units`);
        // console.log(` Gas Used: ${gasUsage.toString()}`)
        // console.log(` Transcation fee: ${gasUsage * gasPriceGwei}`)
        const normalized = inputData.startsWith("0x") ? inputData.slice(2) : inputData;
        const selector = "0x" + normalized.slice(0, 8);
        const rest = normalized.slice(8);

        const chunks = [];
        for (let i = 0; i < rest.length; i += 64) {
            chunks.push("0x" + rest.slice(i, i + 64).padEnd(64, '0'));
        }
        console.log(` Input Data (Hex): ${inputData}`);
        console.log(` Function Selector: ${selector}`)
        console.log(` Arugments:`)
        for (let i = 0; i < chunks.length; i++) {
            const w = chunks[i];
            const parsed = parseWord(w);
            const addr = extractAddressesFromWord(w);
            let line = ` [${i}] hex=${parsed.hex}  decimal=${parsed.decimal}`;
            if (addr) line += `  address=${addr}`;
            console.log(line);
        }

        return tx;

    } catch (error) {
        console.error("An error occurred during the API call:", error.message);
        return null;
    }
}

getTransactionDetails(TX_HASH, API_KEY);
