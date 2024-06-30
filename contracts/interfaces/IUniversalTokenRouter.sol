pragma solidity >=0.5.0;

interface IUniversalTokenRouter {
  function pay(bytes memory payment, uint256 amount) external;
}