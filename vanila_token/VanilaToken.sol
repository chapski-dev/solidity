// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract VanilaToken {
  string public name = "VanilaToken";
  string public symbol = "VNT";
  uint8 public decimals = 18;

  // возвращает общее количество токенов в обращении.
  uint256 public totalSupply = 0;

  // возвращает баланс токенов на указанном адресе.
  mapping(address => uint) balanceOf;
  // возвращает количество токенов, которое один адрес может тратить от имени другого.
  mapping(address => mapping(address => uint256)) public allowance; 

  // События для логирования операций
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
    
  constructor(uint256 _initialSupply) {
    totalSupply = _initialSupply * 10 ** decimals;
    balanceOf[msg.sender] = totalSupply;
    emit Transfer(address(0), msg.sender, totalSupply);
  }


  
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(balanceOf[msg.sender] >= _value, "Insufficient balance");
    require(_to != address(0), "Invalid address");

    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;

    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  // Функция для одобрения перевода токенов от имени владельца
  function approve(address _spender, uint256 _value) public returns (bool) {
      require(_spender != address(0), "Invalid spender address");
      
      allowance[msg.sender][_spender] = _value;
      emit Approval(msg.sender, _spender, _value);
      return true;
  }

    // Функция для перевода токенов от одного адреса к другому с использованием ранее выданного разрешения
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        require(_to != address(0), "Invalid address");
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }

}