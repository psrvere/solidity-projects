//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

//import "../contracts/IERC20.sol";
//import "../contracts/SafeERC20.sol";

// Part1 - one user can store ETH in the contract multiple times but sequentially i.e. only one fund at a time
// Part2 - one user can store ETH in the contract multiple times in parallel
// Part3 - many users can store x number of IERC20 (including ETH) in multiple installments in parallel

// Part3

contract timeLockWallet {

     /* ======= State Variables ====== */

     struct Deposit {
          bool locked;        // locked = true from deposit time till maturity
          uint48 maturity;    // maturity = fund transfer block timestamp + 300 secs (5 mins)
          uint256 amount;     // amount deposited
     }

     Deposit[] public deposits;         // deposit data of user

     mapping (address => uint256) public payouts; // payouts to be made to each user
     mapping (address => uint256) public indexes; // store the last index (starting from 0) of Deposit added for a user
     mapping (address => mapping(uint256 => Deposit)) public notes; // user wise mapping for each deposit made

     /* ====== Error Messages ====== */

     //{Q} does it save gas to define error messages separetely?
     string yetToMature = "don\'t FOMO, time not over yet"; // {Q} how to print ' - using \
     string fundsUnlocked = "yay! funds unlocked";
     string fundsTransferred = "funds transferred";
     
     // ====== Functions ====== */

     // receive eth & lock it
     receive() external payable {
          
          // add deposit
          uint256 _depositIndex = deposits.length;
          Deposit memory deposit = Deposit(true, uint48(block.timestamp)+180, msg.value);
          deposits.push(deposit);
 
          // update index to user index mapping
          indexes[msg.sender] += 1;
          uint256 _index = indexes[msg.sender];

          // add note to user notes mapping
          notes[msg.sender][_index-1] = deposits[_depositIndex];
     }

     function userPayout() internal returns (uint256 lockedFunds_) {
          require(deposits.length != 0, "No funds deposited yet!");   // covers non-initialisation case
          for (uint256 i; i < indexes[msg.sender]; i++) {
               if (notes[msg.sender][i].maturity < uint48(block.timestamp)) {
                    payouts[msg.sender] += notes[msg.sender][i].amount;
                    delete notes[msg.sender][i];
               } else {
                    lockedFunds_ += deposits[i].amount;
               }
          }
     }

     function withdrawFunds() public {

          uint256 lockedFunds;
          lockedFunds = userPayout();

          if (payouts[msg.sender] == 0 && lockedFunds == 0) {
               revert("Funds Already withdrawn");
          } else if (payouts[msg.sender] == 0 && lockedFunds !=0) {
               revert(yetToMature);
          } else {
               uint256 payoutHolder;
               payoutHolder = payouts[msg.sender];
               payouts[msg.sender] = 0;
               payable(msg.sender).transfer(payoutHolder);
          }
     }
}