//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

//import "../contracts/IERC20.sol";
//import "../contracts/SafeERC20.sol";

// Part1 - one user can store ETH in the contract multiple times but sequentially i.e. only one fund at a time
// Part2 - one user can store ETH in the contract multiple times in parallel
// Part3 - many users can store multiple installments of ETH in the contract
// Part4 - many users can store x number of IERC20 (including ETH) in multiple installments in parallel


// Part1

contract timeLockWallet {

     /* ======= State Variables ====== */

     bool locked; // switched on as soon as user deoposits the fund
     uint48 maturity; // timestamp when funds mature and user can withdraw it
     // {ADD} setting maturity basis user feedback
     uint256 amount; // amount deposited by user
     // {Q} Does contract needs gas to send money back to user account?
     address user_address; // user address

     /* ====== Error Messages ====== */

     //{Q} does it save gas to define error messages separetely?
     string yetToMature = "don/'t FOMO, time not over yet"; // {Q} how to print '
     string fundsUnlocked = "yay! funds unlocked";
     string fundsTransferred = "funds transferred";
     
     // ====== Functions ====== */

     // receive eth & lock it
     receive() external payable {
          if (locked) {
               revert("Receive: wait for deposit to mature");
          } else {
               amount = msg.value;
               user_address = msg.sender;
               locked = true;
               maturity = uint48(block.timestamp) + 300;
          }
     }

     // user can withdraw funds post maturity
     function withdrawFunds() public {
          // {Q} where does the return variable goes/can be seen in a public/external function?
          require(locked,"No funds deposited");
          if (uint48(block.timestamp) > maturity) {
               locked = false;
               maturity = 0;
               payable(user_address).transfer(amount); // {ToDO} store transfer success variable and display it
          } else {
               revert(yetToMature); // {Q} how to send a message but not with an error?
          }
     }

     //share deposit stats
     function deposit_stats() public view returns(
          uint256 amount_,
          address user_address_,
          uint48 maturity_,
          bool locked_
     ) {
          amount_ = address(this).balance;
          user_address_ = user_address;
          maturity_ = maturity;
          locked_ = locked;
     }         
}