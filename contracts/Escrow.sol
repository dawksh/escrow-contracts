// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/tokens/ERC721/IERC721.sol";
import "@openzeppelin/contracts/tokens/ERC721/IERC721Receiver.sol";

/// @title Escrow721
/// @author Daksh Kulshrestha
/// @notice Escrow Contract for ERC721 tokens

contract Escrow721 is IERC721Receiver {
    address public immutable seller;
    address public immutable buyer;
    uint256 public deadline;
    uint256 tokenID;
    uint256 amount;
    IERC721 tokenContract;

    constructor(
        address _seller,
        address _buyer,
    ) {
        seller = _seller;
        buyer = _buyer;
        deadline = _deadline;
        tokenID = _tokenID;
    }

    function initialize(address contractAddress, uint _tokenID, uint _amount) external {
        require(msg.sender == seller, "Error: Only seller can initialize");
        tokenContract = IERC721(contractAddress);
        bool s = tokenContract.transferFrom(seller, address(this), _tokenID);
        require(s, "Token Transfer Unsuccessful");
        amount = _amount;
        tokenID = _tokenID;
    }

}
