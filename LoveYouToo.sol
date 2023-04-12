pragma solidity ^0.5.0; import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.1/contracts/token/ERC20/ERC20.sol"; import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.1/contracts/token/ERC20/ERC20Detailed.sol"; contract LoveYouToo is ERC20, ERC20Detailed { // Structure to record user bids struct Bid { address bidder; uint amount; } // Array to store user bids Bid[] public bids; // Contract owner address address public owner; // Maximum auction duration in seconds (1 hour) uint public constant MAX_AUCTION_DURATION = 1 hours; // Auction start time uint public auctionStartTime; // Event to inform users when a new bid is placed event NewBid(address bidder, uint amount); // Event to inform users when an auction has ended event AuctionEnded(address winner1, address winner2); constructor() ERC20Detailed("Love You Too", "LYT", 18) public { _mint(msg.sender, 40000000 * (10 ** uint256(decimals()))); owner = msg.sender; } // Function to allow users to place a bid function placeBid(uint _amount) public { // Check that the user has enough LYT tokens to cover their bid require(balanceOf(msg.sender) >= _amount, "Insufficient balance"); // Record the user's bid bids.push(Bid(msg.sender, _amount)); // Emit an event to inform users that a new bid has been placed emit NewBid(msg.sender, _amount); } // Function to start the auction function startAuction() public { // Check that the function is called by the contract owner require(msg.sender == owner, "Only the owner can start the auction"); // Record the auction start time auctionStartTime = block.timestamp; } // Function to allow the contract owner to end an auction function endAuction() public { // Check that the function is called by the contract owner require(msg.sender == owner, "Only the owner can end the auction"); // Check that the maximum auction duration has not been exceeded require(block.timestamp <= auctionStartTime + MAX_AUCTION_DURATION, "Auction has already ended"); // Check that there are at least two bids require(bids.length >= 2, "Not enough bids"); // Find the two highest bids Bid memory highestBid = bids[0]; Bid memory secondHighestBid = bids[1]; for (uint i = 2; i < bids.length; i++) { if (bids[i].amount > highestBid.amount) { secondHighestBid = highestBid; highestBid = bids[i]; } else if (bids[i].amount > secondHighestBid.amount) { secondHighestBid = bids[i]; } } // Transfer the LYT tokens from the highest bidder to the contract owner _transfer(highestBid.bidder, owner, highestBid.amount); // Emit an event to inform users that the auction has ended and announce the winners emit AuctionEnded(highestBid.bidder, secondHighestBid.bidder); }
