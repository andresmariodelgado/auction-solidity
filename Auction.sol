// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction { 
    // Auction duration: 2 days
    // Base price of 1 ether is taken as current supply
    
    uint256 private currentOffer = 1 ether;
    address private currentAddress; 
    uint256 private endOfAuction;
    address private owner; 
    struct  Bidders  {
        address bidder;
        uint256 value;
    }
    Bidders[] private offerList;
    mapping (address => uint256 ) private acummOfers;
    address[] private keyList;
    mapping(address => bool) private isInKeyList;
    event NewOffer(address indexed sender, uint256 value, uint256 time);
    event AuctionEnded(address sender, uint256 value, uint256 time);

    
    constructor(){
        endOfAuction = block.timestamp + 2 days; 
        owner = msg.sender;
        
    }
    modifier onlyOwner() { 
        require(owner == msg.sender,"Return blocked, you are not the owner" );
        _;
    }
    modifier activeAuction() { 
        require(block.timestamp < endOfAuction, "Auction ended");
        _;
    }
    modifier validprice() {
        require(msg.value > (currentOffer + currentOffer * 5 / 100),"Invalid Offer");
        _;
    }
    modifier auctionEnded() { 
        require(block.timestamp >= endOfAuction, "still active auction");
        _;
    }
    function bid() external payable activeAuction() validprice() { 
        currentOffer = msg.value;
        currentAddress = msg.sender;
          
        // We keep the history of offers
        offerList.push(Bidders(msg.sender, msg.value));

        // We save the accumulated amount by address
        acummOfers[msg.sender] += msg.value;

        // We store the keys, that is, the addresses of the accumulated data,
        // in a list, taking care not to repeat the keys.
        if (!isInKeyList[msg.sender]) {
            keyList.push(msg.sender);
            isInKeyList[msg.sender] = true;
        }

        // We issue the event with address,amount and time. 
        emit NewOffer(msg.sender, msg.value, block.timestamp); 

        // We extend the auction if we are in the last 10 minutes.
        if (block.timestamp >= (endOfAuction - 10 * 60)) { 
            endOfAuction = ( block.timestamp + 10 * 60 );
        }
    }

    // Withdrawal of funds while the auction is active
    function withdrawal() external activeAuction {

        require(acummOfers[msg.sender] > 0, "There has already been a total withdrawal");
      
        // Prevents the current highest bidder from withdrawing their offer.
        require(msg.sender != currentAddress, "You cannot withdraw while you are the highest bidder");
        
        if ( msg.sender == currentAddress ) { 
           uint256 retiroDisponible =  acummOfers[msg.sender] - currentOffer;
           require (retiroDisponible != 0, "Being the best offer, there is no more to withdraw");
           acummOfers[msg.sender] = retiroDisponible;  
        }
        uint256 amount = acummOfers[msg.sender];
        if ( msg.sender == currentAddress ) { 
            acummOfers[msg.sender] = currentOffer; 
             } else { 
                     acummOfers[msg.sender] = 0;
        }     
        (bool result, ) = msg.sender.call{value: amount}("");
        require(result, "Withdrawal of funds failed");
    }

    // Show offers
    function showOfferList()external view returns (Bidders[] memory) {
        return offerList;
    }

    // Show Winner, for this the auction must have ended
    function showWinner() external view auctionEnded returns (address , uint256) { 
        return (currentAddress,currentOffer);
    }

    // The auction owner returns deposits to unsuccessful bidders with a 2% discount.
    function refund() external auctionEnded onlyOwner {
        for (uint256 i = 0; i < keyList.length; i++) {
            address user = keyList[i];
            uint256 total = acummOfers[user];
            if (user != currentAddress ) { 
                    if (total > 0) {
                        acummOfers[user] = 0;

                        // 98% to the user, 2% goes to the owner
                        uint256 refundAmount = (total * 98) / 100;
                        
                        (bool result, ) = user.call{value: refundAmount}("");
                        require(result, "Fallo el reembolso");
                    }  
            }

        // Issues the Auction Ended event with the winner, bid, and end date    
        emit AuctionEnded(currentAddress, currentOffer, endOfAuction); 
        }
    }

}