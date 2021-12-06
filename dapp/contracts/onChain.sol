// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "./chainlink/interface/AggregatorV3Interface.sol";
import "./uniswap/Interface/IUniswapV2Pair.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

// https://docs.chain.link/docs/ethereum-addresses/
// https://docs.chain.link/docs/ethereum-addresses/#Rinkeby%20Testnet

contract onChain is Ownable {

    AggregatorV3Interface private usdETHPriceFeed;
    IUniswapV2Pair private pair;
    uint private amount;

    constructor (address _pairAddress) {
        // require( address(_usdEth) != address(0) , "ZERO_ADDRESS");
        require( _pairAddress != address(0) , "ZERO_ADDRESS");
        pair = IUniswapV2Pair(_pairAddress);
        usdETHPriceFeed = AggregatorV3Interface(0xdCA36F27cbC4E38aE16C4E9f99D39b42337F6dcf);
    }

    function getEthPriceFeed () external view returns (int) {
        (,int price,,,) = usdETHPriceFeed.latestRoundData();
        return price / 1e18; // 10 ** 18
    }

    // address :  0x7e8d0e1ad361eba94abc06898f52d9e2c4cda04b LP:: ETH-Dai

    function setPairAddresses (address pairAddress) external onlyOwner {
        require(address(pairAddress) != address(0), "ZERO_ADDRESS");
        pair = IUniswapV2Pair(pairAddress);
    }

    function getPrice(uint _amount) external view returns(uint){
        require(_amount > 0, "ZERO");
        IERC20Metadata tokenEthUsdc = IERC20Metadata(pair.token1());
        (uint usd  , uint weth,) = pair.getReserves();
        uint res  = usd*(10 ** tokenEthUsdc.decimals());
        return((_amount * res )/weth); 
    }

}