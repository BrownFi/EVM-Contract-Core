pragma solidity =0.5.16;

import '../BrownFiERC20.sol';

contract ERC20 is BrownFiERC20 {
    constructor(uint _totalSupply) public {
        _mint(msg.sender, _totalSupply);
    }
}
