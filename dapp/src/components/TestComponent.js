// this is a Functional Component 

import React, { useState } from 'react';

// import react, web3, web3modal, and @walletconnect/web3-provider. You can install these packages and import them


import Web3 from "web3";
import Web3Modal from 'web3modal';
import WalletConnectProvider from '@walletconnect/web3-provider';

// import the API
import CoinGecko from 'coingecko-api';

// 
// import the ABI of each contracts that you want to connect to
// first you need to learn how to use truffle to migrate/deoply the contracts
import Client from "../contracts/Client.json";
import Oracle from "../contracts/Oracle.json";
import onChain from "../contracts/onChain.json";

export default function TestComponent() {

    // connect to CoinGecko API. 
    const CoinGeckoClient = new CoinGecko();


    // connect to wallet connect 
    // more info: https://github.com/Web3Modal/web3modal
    const web3Modal = new Web3Modal({
        providerOptions: {
            walletconnect: {
            package: WalletConnectProvider,
            options: {
              infuraId: 'a2cb9be6ad7f409691534766f386c3a0'
            }
        },}
    });
    

    // Input hooks
    const [web3, setWeb3] = useState(null);
    const [accounts, setAccounts] = useState(null);
    const [clientContractInstance, setClientContractInstance] = useState(null);
    const [oracleContractInstance, setOracleContractInstance] = useState(null);
    const [onChainContractInstance, setOnChainContractInstance] = useState(null);
    const [priceFeedLable, setPriceFeedLable] = useState(null);

    const [currentStatus, setCurrentStatus] = useState('')
    const [accountInout, setAccountInput] = useState('');
    // const [amountInput, setAmountInput] = useState('');
    const [pairAddress, setPairAddress] = useState('');
    const [priceLable, setPriceLable] = useState('');

    const [checkPirce, setCheckPirce] = useState('');


 

    // First you must connect to a wallet
    async function connectToWallet() {
        // connect to the wallet using web3: https://web3js.readthedocs.io/en/v1.5.2/
        const connect = await web3Modal.connect();
        const web3 = new Web3(connect);
        // set web3 to use it in any func in this file
        setWeb3(web3);


        const accounts = await web3.eth.getAccounts();
        setAccounts(accounts);
        // const account = await web3.eth.getAccounts();


     
        // 

        setCurrentStatus('Connect'); // 


        // connect to the Oracle contract 
        const networkID = await web3.eth.net.getId();
        const deployedOracle = Oracle.networks[networkID];
        const oracleContractInstance = new web3.eth.Contract(
            Oracle.abi,
            deployedOracle && deployedOracle.address
        );
        setOracleContractInstance(oracleContractInstance);

    
        // connect to the client contract
        const deployedClient = Client.networks[networkID];
        const clientContractInstance = new web3.eth.Contract(
            Client.abi,
            deployedClient && deployedClient.address
        );
        setClientContractInstance(clientContractInstance);
        
        
        // connect to the onChain contract
        const deployedonChain = onChain.networks[networkID];
        const onChainContractInstance = new web3.eth.Contract(
            onChain.abi,
            deployedonChain && deployedonChain.address
        );
        setOnChainContractInstance(onChainContractInstance);

    }


    // off chain  it uses client and  oracle contracts
    //
    //
    //
    //
    //
    //
    // 

    // call updateReporter function from the oracle contract
    // to give a permission for an X address to update the price
    async function setAccount(accountInout) { 
        await oracleContractInstance.methods.updateReporter(accountInout, true).send({from: accounts[0]} );
    }

    // the  X address then can call the API to updateData in the oracle contrac
    async function updateData () {
        const response = await CoinGeckoClient.coins.fetch('bitcoin', {});

        let currentPrice = parseFloat(response.data.market_data.current_price.usd);
        currentPrice = parseInt(currentPrice * 100);
        


        await oracleContractInstance.methods.updateData(
              web3.utils.soliditySha3('BTC/USD'), currentPrice).send({from: accounts[0]});

        console.log(`new price for BTC/USD ${currentPrice} updated on-chain`);


    }


    // now anyone can call the foo func in client contract 
    async function foo() {
        await clientContractInstance.methods.foo().call().then(res=>{
                console.log(res)
        });
    }


    // on chain, it uses the onchain contract
    //
    //
    //
    //
    //
    //
    // 
    async function getEthPriceFeed() {
        const priceFeedLable =  await onChainContractInstance.methods.getEthPriceFeed().call();
        setPriceFeedLable(priceFeedLable);
    }


    async function getPrice(checkPirce) {
    try {
        const priceLable = await onChainContractInstance.methods.getPrice(Number(checkPirce)).call();
        // .then(res=>{
        //     console.log(res)
        // });
        setPriceLable(priceLable);

    } catch (error){
        await onChainContractInstance.methods.getPrice(
            Number(checkPirce)).call(
                {from: accounts[0]}).then().catch(revertReason => console.log({ revertReason }))
    }


    }


    async function setPairAddresses(pairAddress) { 
        await onChainContractInstance.methods.setPairAddresses(pairAddress).send({from: accounts[0]} );
    }






    return (
        <div className='main__container'>

            <h1>Example: </h1>
            <div className='left__container'>
                <button onClick={() => connectToWallet()}>Connect Wallet</button>
            </div>
            {currentStatus} :  
            {accounts}
            <div>
            <hr>
            </hr>
            <p>
                <br></br>
                <label> 
                    Allow an account to update the price (coingecko API) <br></br>
                <button onClick={() => setAccount(accountInout)}>  Enter account 
                </button>
                    : <input type="text" size="50"
                    onChange={event => setAccountInput(event.target.value)}>
                    </input>
                      
                </label>
                </p>

            </div>
 

            <div>
        
            <p>
                <br></br>
                
                <label> 
                <button onClick={() => updateData()}>  Update data  
                </button>
                      
                </label>
                </p>

            </div>


            <div>
            <p>
                <br></br>
                <label> 
                <button onClick={() => foo()}>  foo : 
                </button>
                 
           
                </label>
                </p>

            </div>


            <div>
            <hr></hr>
            <p>
                <br></br>
                <label> 
                <button onClick={() => setPairAddresses(pairAddress)}>  Set Pair  : 
                </button>
                    <input type="text" size="50"
                    onChange={event => setPairAddress(event.target.value)}>
                    </input>
                      
                </label>
                </p>
                

            </div>

            <div>
            <p>
            From sushiswap smart contract :
                <br></br>
                <label> 
                <button onClick={() => getPrice(checkPirce)}>  The Price :
                </button> 
                <input type="text" pattern="[0-9]*" 
                    onChange={event => setCheckPirce(event.target.value)}>
                </input>
                     is: {priceLable} USD.
                    
                </label>
            </p>
            <label>  </label>


            </div>


            <div>
            <p>
                <br></br>
                From Chainlink smart contract :
                <br></br>
                <label> 
                <button onClick={() => getEthPriceFeed()}>  ETH Price 
                </button> 
              
                     is: {priceFeedLable}
                    
                </label>
            </p>
            <label>  </label>


            </div>


            </div>
    )
}
