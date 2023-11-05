// SPDX-License-Identifier: Unlicenced
pragma solidity 0.8.18;
contract TokenContract {

uint tokensInEther = 5;

uint balance;

 address public owner;
 struct Receivers {
 string name;
 uint256 tokens;
 }
 mapping(address => Receivers) public users;

 modifier onlyOwner(){
 require(msg.sender == owner);
 _;

 }

 constructor(){
 owner = msg.sender;
 users[owner].tokens = 100;
 }

 function double(uint _value) public pure returns (uint){
 return _value*2;
 }

 function register(string memory _name) public{
 users[msg.sender].name = _name;
 }

 function giveToken(address _receiver, uint256 _amount) onlyOwner public{
 require(users[owner].tokens >= _amount);
 users[owner].tokens -= _amount;
 users[_receiver].tokens += _amount;
 }

 function buyToken() onlyOwner public payable{
    require(users[owner].tokens > 0, "Tokens insuficiente");
    require(msg.value > tokensInEther ,"Cantidad de Ether insuficiente");
    uint tokensToBuy = msg.value/tokensInEther;
    users[owner].tokens = users[owner].tokens + tokensToBuy;

   set(msg.value);
 }

    function set(uint x) public {
        balance = x;
    }

    function get() public view returns (uint) {
        return balance;
    }

}


