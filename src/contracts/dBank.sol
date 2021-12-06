// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {

  //assign Token contract to variable
  Token private token;

  //add mappings
  mapping(address => uint) public etherBalanceOf;
  mapping(address => uint) public timeOfDeposit;
  mapping(address => bool) public isDeposited;
  //add events
  event Deposit(address indexed depositor, uint amount, uint timestamp);
  event Withdraw(address indexed depositor, uint amount, uint depositTime, uint intrest);
  //pass as constructor argument deployed Token contract
  constructor(Token _token) public {
    token = _token; //assign token deployed contract to variable
  }

  function deposit() payable public {
    require(isDeposited[msg.sender] == false); //check if msg.sender didn't already deposited funds
    require(msg.value >= 1e16); //check if msg.value is >= than 0.01 ETH

    etherBalanceOf[msg.sender] += msg.value;  //increase msg.sender ether deposit balance

    timeOfDeposit[msg.sender] += block.timestamp; //start msg.sender hodling time

    isDeposited[msg.sender] = true;  //set msg.sender deposit status to true
    emit Deposit(msg.sender, msg.value, block.timestamp); //emit Deposit event
  }

  function withdraw() public {
    require(isDeposited[msg.sender] == true); //check if msg.sender deposit status is true
    uint etherDeposited = etherBalanceOf[msg.sender]; //assign msg.sender ether deposit balance to variable for event

    uint hodlTime = block.timestamp - timeOfDeposit[msg.sender];  //check user's hodl time

    uint interestPerSecond = 31668017 * (etherBalanceOf[msg.sender] / 1e16);  //calc interest per second at 10% APY
    uint accruedInterest = hodlTime * interestPerSecond;       //calc accrued interest

    msg.sender.transfer(etherDeposited); //send eth to user
    token.mint(msg.sender, accruedInterest);//send interest in tokens to user

    timeOfDeposit[msg.sender] = 0;
    etherBalanceOf[msg.sender] = 0;  //reset depositer data
    isDeposited[msg.sender] = false;
    
    emit Withdraw(msg.sender, etherDeposited, hodlTime, accruedInterest);
    //emit event
  }

  function borrow() payable public {
    //check if collateral is >= than 0.01 ETH
    //check if user doesn't have active loan

    //add msg.value to ether collateral

    //calc tokens amount to mint, 50% of msg.value

    //mint&send tokens to user

    //activate borrower's loan status

    //emit event
  }

  function payOff() public {
    //check if loan is active
    //transfer tokens from user back to the contract

    //calc fee

    //send user's collateral minus fee

    //reset borrower's data

    //emit event
  }
}