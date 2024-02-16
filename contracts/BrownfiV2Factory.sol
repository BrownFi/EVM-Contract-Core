pragma solidity =0.5.16;

import './interfaces/IBrownfiV2Factory.sol';
import './BrownfiV2Pair.sol';

contract BrownfiV2Factory is IBrownfiV2Factory {
    address public feeTo;
    address public feeToSetter;
    address public kSetter;
    bytes32 public constant INIT_CODE_HASH = keccak256(abi.encodePacked(type(BrownfiV2Pair).creationCode));

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
        kSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'BrownfiV2: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'BrownfiV2: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'BrownfiV2: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(BrownfiV2Pair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IBrownfiV2Pair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'BrownfiV2: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'BrownfiV2: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }

    function setKSetter(address _kSetter) external {
        require(msg.sender == kSetter, 'BrownfiV2: FORBIDDEN');
        kSetter = _kSetter;
    }
}
