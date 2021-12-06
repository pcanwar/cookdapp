import React, { useState } from 'react';


import Web3 from "web3";
import Web3Modal from 'web3modal';
import WalletConnectProvider from '@walletconnect/web3-provider';

import CoinGecko from 'coingecko-api';

import Client from "../contracts/Client.json";
import Oracle from "../contracts/Oracle.json";
import onChain from "../contracts/onChain.json";



export default function TestComponent() {

    const CoinGeckoClient = new CoinGecko();

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


 

    // connect to a wallet
    async function connectToWallet() {

        const connect = await web3Modal.connect();
        const web3 = new Web3(connect);

        const accounts = await web3.eth.getAccounts();
        setWeb3(web3);

        setAccounts(accounts);
        setCurrentStatus('Connect')

        const networkID = await web3.eth.net.getId();

        const deployedOracle = Oracle.networks[networkID];
        const oracleContractInstance = new web3.eth.Contract(
            Oracle.abi,
            deployedOracle && deployedOracle.address
        );
        setOracleContractInstance(oracleContractInstance);

    
        // Client contract
        const deployedClient = Client.networks[networkID];
        const clientContractInstance = new web3.eth.Contract(
            Client.abi,
            deployedClient && deployedClient.address
        );
        setClientContractInstance(clientContractInstance);
        
        
        // onChain contract
        const deployedonChain = onChain.networks[networkID];
        const onChainContractInstance = new web3.eth.Contract(
            onChain.abi,
            deployedonChain && deployedonChain.address
        );
        setOnChainContractInstance(onChainContractInstance);

        // web3.eth.handleRevert = true
    }


    async function setAccount(accountInout) { 
        await oracleContractInstance.methods.updateReporter(accountInout, true).send({from: accounts[0]} );
    }

    async function updateData () {
        const response = await CoinGeckoClient.coins.fetch('bitcoin', {});
        let currentPrice = parseFloat(response.data.market_data.current_price.usd);
        currentPrice = parseInt(currentPrice * 100);
        
        await oracleContractInstance.methods.updateData(
              web3.utils.soliditySha3('BTC/USD'), currentPrice).send({from: accounts[0]});

        console.log(`new price for BTC/USD ${currentPrice} updated on-chain`);


    }

    async function foo() {
        await clientContractInstance.methods.foo().call().then(res=>{
                console.log(res)
        });
    }

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
        // await onChainContractInstance.methods.getPrice(checkPirce).call().then(res=>{
        //     console.log(res)
        // });


    }


    // async function setAmount(amountInput) {
    //     await onChainContractInstance.methods.setAmount(amountInput).send({from: accounts[0]});

    // }

    async function setPairAddresses(pairAddress) { 
        await onChainContractInstance.methods.setPairAddresses(pairAddress).send({from: accounts[0]} );
    }






    return (
        <div className='main__container'>
            <h1>Example: </h1>
            <div className='left__container'>
                <button onClick={() => connectToWallet()}>Connect Wallet</button>
            </div>
            {currentStatus} : {accounts[0]}
            <div>
            <hr></hr>
            <p>
                <br></br>
                <label> 
                    Allow an account to update the price <br></br>
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



            {/* <div>
            <p>
                <br></br>
                <label> 
                <button onClick={() => setAmount(amountInput)}>  Enter Amount 
                </button>
                <input type="text" pattern="[0-9]*" 
                    onChange={event => setAmountInput(event.target.value)}>
                </input>
                      
                </label>
                </p>

            </div> */}

            <div>
            <p>
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
                <label> 
                <button onClick={() => getEthPriceFeed()}>  ETH Price :
                </button> 
              
                     is: {priceFeedLable}
                    
                </label>
            </p>
            <label>  </label>


            </div>


            </div>
    )
}
