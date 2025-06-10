# 🪙 Auction in Solidity - Auction.sol

## Overview improvements

This project contains a smart contract in Solidity that implements a basic auction, with a defined base bid, fixed duration, partial withdrawal for non-winning bidders while the auction is active, and total withdrawal of all non-winning offers after the auction ends. A persistent history of all bidders is maintained, including the winner and their final bid amount.

## File

- `Auction.sol`: Main contract that handles all auction logic.

## Key Features

• Automatically starts the auction when deployed (2-day duration, with a base offer of 1 ether).

• Registers successive bids only if they are at least 5% higher than the current one.

• Maintains a full bidder history.

• Refunds accumulated funds (except the final winning offer).

• Emits events (`NewOffer`, `AuctionEnded`).

## Modifiers and Restrictions

• `onlyOwner`: Only the owner can execute deposit refunds once the auction ends.

• `activeAuction`: Ensures the auction is still ongoing.

• `validprecio`: Validates that a new offer is higher than the current one.

## Key Structures and Variables

• `Bidders[] offerList`: Bid history with address and amount.

• `mapping(address => uint256) acummOfers`: Accumulated amount per bidder.

• `keyList[]`: List of unique keys for iteration.

• `event NewOffer`: Signals a new offer was made.

• `event AuctionEnded`: Signals the end of the auction.

## Refunds and Deduction Logic

• Only the auction owner can refund all non-winning offers (excluding the winner).

• A 2% fee is deducted and remains in the contract.

• The winner does not receive a refund for their final offer. If they have unclaimed earlier offers during the auction, they may withdraw them.

## Author

Developed by Andrés Delgado for educational and exploratory purposes in blockchain and decentralized auctions.
