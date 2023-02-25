// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract Escrow {

    enum State {WAITING_FOR_PAYMENT, WAITING_FOR_DELIVERY, COMPLETE}
    State public currentState;

    address payable public buyer;
    address payable public seller;

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only the buyer can call this function");
        _;
    }

    constructor(address payable _buyer, address payable _seller) public {
        buyer = _buyer;
        seller = _seller;
        currentState = State.WAITING_FOR_PAYMENT;
    }

    function deposit() external {
        require(currentState==State.WAITING_FOR_PAYMENT, "Buyer has already deposited Ether into the contract!");
        currentState = State.WAITING_FOR_DELIVERY;
    }

    function confirmDelivery() external onlyBuyer {
        require(currentState==State.WAITING_FOR_DELIVERY, "Delivery has not been confirmed yet!");
        seller.transfer(address(this).balance);
        currentState = State.COMPLETE;
    }
}


