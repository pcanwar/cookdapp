
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

    // 1- deploy both ABC contract and Support contract.
    // 2- mint utility tokens from ABC contract
    // 3- In ABC contract you need to approve amount of tokens to (Support) contract address

contract ABC is ERC20 {
    constructor() ERC20("M", "MM") {}
    function mint( uint256 amount) public  {
        _mint(msg.sender, amount * 10 ** decimals());

    }
}


    // 4- In on (Support) contract, you need to add a ABC contract address uing the add function, to support ABC utility tokens
    // 2- In Support contract, you can use send function to send  (ABC) tokens to an address

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
        addr[_contract] = false;
    }

    
    /**
     * @dev See SafeERC20 {afeApprove, safeTransferFrom}.
     *
     *
     * Requirements:
     *
     * - you need to require `_contract` and `to`, so they cannot be the zero address.. 
     * - `sender` must have a balance of at least `amount`. 
     * - the caller must have allowance for ``sender``'s tokens of at least `amount`.
     */
    function send( IERC20 _contract, address to, uint sendAmount ) public supported( _contract) {
        // require()
        // sell NFT/ create bool / etc
        // do something ... 
        IERC20 token = IERC20(_contract);
        token.safeApprove(address(this), sendAmount);
        token.safeTransferFrom(msg.sender, address(this), sendAmount);
        token.safeTransferFrom(address(this), to, sendAmount);
        

    }

}