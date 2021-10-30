pragma solidity >= 0.7.0 <0.9.0;

//1. this contract will allow only the Creator to create new coins
// anyone can send coins to each othher without a need for registering w/ username + PW. All you need is an ETH keypair 

contract Coin {
    address public minter;
    // maps addresses to uints and stores as publicly accessible "balances". 
    mapping(address => uint) public balances;
    
    
    // an Event is an inheritable member of a contract. An event is emitted, it stores arguments passed in traction logs. 
    event Sent(address from, address to, uint amount);
    
    // only called when we initially deploy contract 
    constructor() public {
        minter = msg.sender;
    }
 
    modifier onlyOwner() {
        require(msg.sender == minter);
        _;
    }
    
    
    // 1
    // ensure only the owner can send coins  
    // make new coins and send them to an address
    function mint(address receiver, uint amount) public onlyOwner {
        balances[receiver] += amount;
    }
    
    error insufficientBalance(uint requested, uint available);
    
    // send any amount of coins to an existing address
    function send(address receiver, uint amount) public {
       // if trying to send a larger amount than the sender actually has: 
       if(amount > balances[msg.sender]) 
       revert insufficientBalance({
           requested: amount,
           available:  balances[msg.sender]
       });
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        
        // emit event
        emit Sent(msg.sender, receiver, amount);
    }
}