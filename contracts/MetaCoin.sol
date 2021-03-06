pragma solidity ^0.4.2;

import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts.

contract MetaCoin {
	mapping (address => uint) balances;
	uint public jackpot;

	struct Lottery {
	    address user_address;
	    uint ticket_val;
        }

    Lottery[] public lotterys;


	event Transfer(address indexed _from, address indexed _to, uint _value);
	event BuyLotteryEvent(address indexed _from, uint _value);

	function MetaCoin() {
		balances[tx.origin] = 10000;
		jackpot = 0;
	}

	function sendCoin(address receiver, uint amount) returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		Transfer(msg.sender, receiver, amount);
		return true;
	}

	function getBalanceInEth(address addr) returns(uint){
		return ConvertLib.convert(getBalance(addr),99);
	}

	function getBalance(address addr) returns(uint) {
		return balances[addr];
	}

	function buyLottery(uint amount) returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
        lotterys.push(Lottery({
            user_address: msg.sender,
            ticket_val: amount
        }));
        if (jackpot + amount >= 100) {
            amount = 100 - jackpot;
            balances[msg.sender] -= amount;
            jackpot += amount;
            BuyLotteryEvent(msg.sender, amount);
            drawLottery();
        } else {
            balances[msg.sender] -= amount;
            jackpot += amount;
            BuyLotteryEvent(msg.sender, amount);
        }
		return true;
	}

	function drawLottery() {
	    uint random_number = uint(block.blockhash(block.number-1))%100;
	    uint count = 0;
        for (uint i = 0; i < lotterys.length; i++) {
            count += lotterys[i].ticket_val;
            if (count >= random_number){
                balances[lotterys[i].user_address] += jackpot;
	            jackpot = 0;
            }
        }
        Lottery[] temp;
        lotterys = temp;
	}

	function getJackpot() returns(uint) {
		return jackpot;
	}
}
