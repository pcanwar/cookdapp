// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


  // Oracle and client contracts work together
  // second: the Client contract is for reading from Oracle contract
import './interface/IOracle.sol';

contract Client {
// in this contract exmaple, there one interface to get the price from the Oracle contract
// 1- IOracle file contains Oracle contract functions, but here we use only getData function from the Oracle contract

IOracle public oracle;
// _oracle os the the Oracle contract address
constructor(address _oracle) {
    oracle = IOracle(_oracle);
}

  // foo is for geting the data(price), 
  // there is a requirement if the timestamp was 10 mins ago, 
  // the reporter needs to update the price by using the updateData() func in the Oracle contract. 
  function foo() view external returns(  uint){
    bytes32 key = keccak256(abi.encodePacked('BTC/USD'));
    (bool result, uint timestemp , uint data) = oracle.getData(key);
    require(result == true, 'could not get price');
    require(timestemp >= block.timestamp - 10 minutes, 'Old Price');
    return data;
    //do something with price;

  }
}