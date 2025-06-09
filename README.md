# 🪙 Auction in Solidity - Auction.sol

## Overview

This project contains a smart contract written in Solidity that implements a simple auction, with a defined base bid, duration, partial withdrawal for non-winning bidders while the auction is active, and total withdrawal for all non-winning bids at the end of the auction. A persistent record of all bidders is kept, including the winner and the final bid amount.

## 📦 File

- `Auction.sol`: Main contract handling all auction logic.

## 🚀 Key Features

- Automatically starts the auction when deployed (2-day duration, with a 1 ether base offer).
- Accepts successive bids only if they are at least 5% higher than the current highest bid.
- Maintains a full bid history.
- Refunds accumulated funds (except the final winning bid).
- Emits key events (`NewOffer`, `AuctionEnded`).

## 🔐 Modifiers and Restrictions

- `onlyOwner`: Only the auction owner can execute refunds after the auction ends.
- `activeAuction`: Validates that the auction is still ongoing.
- `validprecio`: Ensures a new offer is greater than the current one.

## 🧱 Key Structures and Variables

- `Bidders[] offerList`: History of bids with address and amount.
- `mapping(address => uint256) acummOfers`: Accumulated offer per address.
- `keyList[]`: Unique list of addresses to iterate.
- `event NewOffer`: Emits when a new offer is placed.
- `event AuctionEnded`: Emits when the auction ends.

## 💸 Refund Logic and Deductions

- Only the auction owner can issue refunds (excluding the winner).
- A 2% fee is retained by the contract when refunding.
- The winner does not receive a refund for their final bid, but may withdraw previous offers if not yet claimed during the auction.

## 🧑‍💼 Author

Developed by Andrés Delgado for educational and exploratory purposes in blockchain and decentralized auction environments.
