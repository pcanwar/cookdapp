// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interface/IOracle.sol';
contract Client {
  
  IOracle public oracle;

constructor(address _oracle) {
    oracle = IOracle(_oracle);
}

  function foo() view external returns(  uint){
    bytes32 key = keccak256(abi.encodePacked('BTC/USD'));
    (bool result, uint timestemp , uint data) = oracle.getData(key);
    require(result == true, 'could not get price');
    require(timestemp >= block.timestamp - 10 minutes, 'Old Price');
    return data;
    //do something with price;

  }
}