
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

    // 1- mint tokens
    // 2- Approve amount of tokens from (ABC) contract to (Support) contract

contract ABC is ERC20 {
    constructor() ERC20("M", "MM") {}
    function mint( uint256 amount) public  {
        _mint(msg.sender, amount );
    }
}

    // 1- Add a ABC contract address uing the add function on (Support) contract
    // 2- On (Support) contract you can use sendtx to send  (ABC) tokens 

contract Support {

    using SafeERC20 for IERC20; 

    mapping(IERC20 => bool) addr;

    modifier supported(IERC20 _contract) {
        require( addr[_contract] == true );
        _;
    }

    function add(IERC20 _contract) public {
        require(addr[_contract] == false);
        addr[_contract] = true;
    }

    function remove(IERC20 _contract) public {
        require(addr[_contract] == true);
        addr[_contract] = true;
    }

    function send( IERC20 _contract, address to, uint sendAmount ) public supported( _contract) {
        // sell NFT/ create 
        // do something ... 
        IERC20 token = IERC20(_contract);
        token.safeApprove(address(this), sendAmount);
        token.safeTransferFrom(msg.sender, address(this), sendAmount);
        token.safeTransferFrom(address(this), to, sendAmount);

    }

}