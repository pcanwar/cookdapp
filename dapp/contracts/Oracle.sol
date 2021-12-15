// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
  // Oracle and client contracts work together
  // First, the oracle contract to read offchain data
contract Oracle {

struct Data {
    uint date; //  timestamp
    uint payload; // price
  }

  address public admin;

  mapping(address => bool) public reporters;
  mapping(bytes32 => Data) public data; // mapping the struct, so we get from each key a different result


  // admain of this contract
  constructor(address _admin) {
    admin = _admin;
  }


  // first the admin needs to add a reporter to update the price
  function updateReporter(address reporter, bool isReporter) external {
    require(msg.sender == admin, 'only admin');
    reporters[reporter] = isReporter;
  }


  // only reporter can run updateData function to update a price 
  function updateData(bytes32 key, uint payload) external {
    require(reporters[msg.sender] == true, 'only reporters');
    data[key] = Data(block.timestamp, payload);
  }


  // return the time and price from the struct data
  function getData(bytes32 key)
    external
    view
    returns(bool result, uint timestemp, uint payload) {
    if(data[key].date == 0) {
      return (false, 0, 0);
    }
    return (true, data[key].date, data[key].payload);
  }


}