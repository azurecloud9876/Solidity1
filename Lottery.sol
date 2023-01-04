// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Lottery {
    address public owner;
    address[] public players;
    address[] public gameWinners;
    
    constructor() {
        owner = msg.sender;
    }

    receive()  external payable {
        require(msg.value == 1 ether);
        players.push(msg.sender);

    }

    //fallback() external payable{}

    function getBalance() public view returns (uint256) {
        require(msg.sender == owner,"only contract owner can see the balance");
        return address(this).balance;
    }

    function pickWinner() public {
        require(msg.sender == owner,"only contract owner can pick the winner");
        require(players.length >= 3,"Atleast 3 players should be participated to choose the winner");

        uint256 r = random();
        address winner;

        uint256 index = r%players.length;
        winner = players[index];
        gameWinners.push(winner);

        delete players;

        (bool success, ) = winner.call{value: getBalance()}("");
        require(success,"Transfer failed");

    }

    function random() internal view returns (uint256) {

        return uint256(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));

    }
}
