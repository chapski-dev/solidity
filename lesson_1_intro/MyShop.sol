// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MyShop {
    /** 
      address - тип переменной
      public - открытость для метода contract.call() - чтения значения переменной owner
      owner - название переменной
     */
    address public owner;

    /** mapping - своего рода обьект,
        где address - кто отрпавил
        uint - сумму денег (число)
        payments - название обьекта
     */
    mapping(address => uint) public payments;

    constructor() {
        // код для деплоя
        owner = msg.sender;
    }
    /**
      function payForItem - публичный метод для отправки денег на контракт
      payable - обозначает что данный метод вызывается для проведения операций с деньгами (платежами)
      msg - обьект который приходит в смарт контракт при взаимодействии и включающий в себя:
      msg.sender - отправитель средтсв 
      msg.value - количествно средств в wei
     */
    function payForItem() public payable {
        payments[msg.sender] = msg.value;
    }

    // function withdrawAll - публичный метод для получения денег с контракта на андрес владельца контракта
    function withdrawAll() public {
        /** переменная _to и _thisContract - это переменные хранящаеся только во время исполнения функции
         и стоящие гораздо меньше чем переменные state, которые будут записаны в блокчейн,
         и стоящие из-за этого гораздо больше.
        */ 

        // address payable _to - указывается адрес кому выплачивается средства
        address payable _to = payable(owner);

        // address _thisContract - указывается контекст(this) адреса контракта
        address _thisContract = address(this);

        /**
          метод перевода где у контракта КОМУ - вызывается метод transfer
          и в него указывается сумма перевода
         */ 
        _to.transfer(_thisContract.balance);
    }
}
