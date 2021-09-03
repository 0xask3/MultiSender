How to Use:

1.
Install necessary dependencies
```
npm install
```
2.
Create .env file following content
```
MNEMONIC = "Your mnemonic"
ROPSTEN = "wss://ropsten.infura.io/ws/v3/your api key"
RINKEBY = "wss://rinkeby.infura.io/ws/v3/your api key"
MAINNET = "wss://mainnet.infura.io/ws/v3/your api key"
BSCTESTNET = "https://bsc-dataseed.binance.org/"
BSCMAINNET = "https://bsc-dataseed.binance.org/"
ETHERAPI = "Your etherscan API"
BSCSCAN = "Your bscscan API"
```
3.
Compile the contracts
```
truffle compile
```
4.
Deploy on desired network (for example rinkeby)
```
truffle migrate --network rinkeby
```
5.
Verify the code
```
truffle run verify MultiSender --network rinkeby
```
6.
Done :)
