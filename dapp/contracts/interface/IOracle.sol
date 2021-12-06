// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
interface IOracle {

    // 1st
    function updateData(bytes32 key, uint usdload, uint tokenLoad) external;
    function getData(bytes32 key) external view returns(bool result, uint timestemp, uint usdload);
    
    // 2nd
    function toUSD() external view returns(uint );
    function getUSDPrice(uint _price) external view returns(uint);
    function getETHPrice(uint _price) external view returns(uint);

    // 3rd
    

}
