// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';
import './IMedianOracle.sol';

contract MarketRateProvider is ChainlinkClient, ConfirmedOwner {
  uint256 public latestRate;
  mapping(address => bool) public nodes;
  address public consumer;

  MedianOracle medianOracle;

  event MarketRateUpdated(uint256 indexed rate);

  constructor(address _owner, address _link) ConfirmedOwner(_owner) {
    setChainlinkToken(_link);
  }

  function fulfillMarketRate(bytes32 _rate) public {
    require(nodes[msg.sender], 'Unknown node.');
    latestRate = uint256(_rate);
    emit MarketRateUpdated(latestRate);
    if (consumer != address(0x0)) {
      medianOracle = MedianOracle(consumer);
      medianOracle.pushReport(latestRate);
    }
  }

  function setNodePermission(address _node, bool _permission) public onlyOwner {
    nodes[_node] = _permission;
  }

  function setConsumerAddress(address _consumer) public {
    consumer = _consumer;
  }

  function getChainlinkToken() public view returns (address) {
    return chainlinkTokenAddress();
  }

  function withdrawLink() public onlyOwner {
    LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
    require(link.transfer(msg.sender, link.balanceOf(address(this))), 'Unable to transfer');
  }
}
