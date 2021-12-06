// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

interface IUniswapV2Pair {
    function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) ;
    function token0() external view returns (address);
    function token1() external view returns (address);

}