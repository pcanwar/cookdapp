// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;
import "./chainlink/interface/AggregatorV3Interface.sol";
import "./uniswap/Interface/IUniswapV2Pair.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

// https://docs.chain.link/docs/ethereum-addresses/
// https://docs.chain.link/docs/ethereum-addresses/#Rinkeby%20Testnet

// in this contract exmaple, there are two interfaces to get the price of two tokens pair
// for example ETH to USDC 
// 1- chainlink : AggregatorV3Interface file and we only use latestRoundData function 
// 2- uniswap : IUniswapV2Pair. 
// 3- IERC20Metadata interface contains IERC20 interface
//  IERC20Metadata Interface functions from the ERC20 standard. (name(), decimals(), and symbol() functions are from ERC20 standard).

contract onChain is Ownable {
    // the interface of chainlink is usdETHPriceFeed
    AggregatorV3Interface private usdETHPriceFeed;
    // the interface of uniswap or sushiswap is pair
    IUniswapV2Pair private pair;
    // to store an amount
    uint private amount;


    // _pairAddress: the address of the pair address in uniswap or sushiswap
    // each pair has two tokens for example ETH <-> USDC or USDC <-> ETH
    // example of a pair address :  0x7e8d0e1ad361eba94abc06898f52d9e2c4cda04b :: ETH <-> Dai, (ETH == WETH)

    constructor (address _pairAddress) {
        require( _pairAddress != address(0) , "ZERO_ADDRESS");
        // pair is to keep the address of the pair address that have two tokens
        pair = IUniswapV2Pair(_pairAddress);
        // usdETHPriceFeed is chainlink pair of two tokens  
        usdETHPriceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e); // from chainlink feed price site.
    }

    // getEthPriceFeed from chainlink pair address using the function latestRoundData in the interface . 
    // in this function, it only returns the price of this pair 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e as
    // it was added in the constructor
    function getEthPriceFeed () external view returns (int) {
        (,int price,,,) = usdETHPriceFeed.latestRoundData();
        return price / 1e8; // 10 ** 8
    }


    // pairAddress: to add uniswap pair address, this is similar to the constructor.
    function setPairAddresses (address pairAddress) external onlyOwner {
        require(address(pairAddress) != address(0), "ZERO_ADDRESS");
        pair = IUniswapV2Pair(pairAddress);
    }
    

    // _amount is for getting the a price of 1 ETH for example.
    function getPrice(uint _amount) external view returns(uint){
        require(_amount > 0, "ZERO");
        IERC20Metadata tokenEthUsdc = IERC20Metadata(pair.token1()); // 
        // pair.getReserves returns the reserves of first pair of the token and the second pair of the token.
        // it is used to price trades and distribute liquidity
        (uint usd  , uint weth,) = pair.getReserves(); 
        // tokenEthUsdc.decimals() uses the decimals function in the IERC20Metadata interface 
        uint res  = usd*(10 ** tokenEthUsdc.decimals()); // functions from the ERC20 standard.
        // some tokens have different decimals for example 18, 8, 6, and etc.
        return((_amount * res )/weth); 
    }

}