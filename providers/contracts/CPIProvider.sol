// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';
import './IMedianOracle.sol';

contract CPIProvider is ChainlinkClient, ConfirmedOwner {
  uint256 public latestCpi;
  mapping(address => bool) public nodes;
  address public consumer;

  MedianOracle medianOracle;

  event CPIUpdated(uint256 indexed cpi);

  constructor(address _owner, address _link) ConfirmedOwner(_owner) {
    setChainlinkToken(_link);
  }

  function fulfillCpi(bytes32 _cpi) public {
    require(nodes[msg.sender], 'Unknown node.');
    latestCpi = uint256(_cpi);
    emit CPIUpdated(latestCpi);
    if (consumer != address(0x0)) {
      medianOracle = MedianOracle(consumer);
      medianOracle.pushReport(latestCpi);
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
