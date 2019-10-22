//pragma solidity >=0.4.22 <0.6.0;
pragma solidity ^0.4.25;
contract Delegate{
    
    address public owner;
    function Delegate(address _owner){
        
        owner = _owner;
    }
    
    function pwn(){
        
        owner = msg.sender;
    }

}

contract Delegation{
    
    address public owner;
    Delegate delegate;
    
    function Delegation(address _delegateAddress){
        
        delegate = Delegate(_delegateAddress);
        owner = msg.sender;
    }
    
    function(){
        
        if(delegate.delegatecall(bytes4(keccak256("pwn()")))){
            this;
        }
    }
}
