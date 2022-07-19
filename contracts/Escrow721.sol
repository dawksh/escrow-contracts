// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

/// @title Escrow721
/// @author Daksh Kulshrestha
/// @notice Escrow Contract for ERC721 tokens

contract Escrow721 is IERC721Receiver {
    address public immutable seller;
    address public immutable buyer;
    uint256 public deadline;
    uint256 public tokenID;
    uint256 public amount;
    IERC721 public tokenContract;
    bool isLive;

    constructor(address _seller, address _buyer) {
        seller = _seller;
        buyer = _buyer;
    }

    function initialize(
        address contractAddress,
        uint256 _tokenID,
        uint256 _amount,
        uint256 _deadline
    ) external {
        require(msg.sender == seller, "Error: Only seller can initialize");
        tokenContract = IERC721(contractAddress);
        tokenContract.transferFrom(seller, address(this), _tokenID);
        deadline = _deadline;
        amount = _amount;
        tokenID = _tokenID;
    }

    function pay() external payable {
        require(isLive, "Escrow not active");
        require(msg.sender == buyer, "Caller not the Buyer");
        require(msg.value == amount, "Not enough funds");
        tokenContract.transferFrom(address(this), buyer, tokenID);
        payable(seller).transfer(msg.value);
    }

    function cancelEscrow() external {
        require(block.timestamp > deadline, "Deadline not crossed");
        isLive = false;
        tokenContract.transferFrom(address(this), seller, tokenID);
    }

    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _data
    ) external pure override returns (bytes4) {
        _operator;
        _from;
        _tokenId;
        _data;
        return 0x150b7a02;
    }
}
