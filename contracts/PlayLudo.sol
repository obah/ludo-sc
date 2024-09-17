//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./NumberGenerator.sol";

contract PlayLudo {
    NumberGenerator public throwResult;

    uint public boardSize = 52;
    address[] public players;
    uint public activePlayers;
    uint public turn;
    address public winner;

    struct Player {
        uint position;
        bool isActive;
    }

    mapping(address => Player) public playerInfo;

    constructor(address[] memory _players) {
        require(_players.length > 1, "At least two players are required");

        players = _players;
        activePlayers = _players.length;
        throwResult = NumberGenerator(msg.sender);

        for (uint i = 0; i < _players.length; i++) {
            playerInfo[_players[i]] = Player(0, true);
        }
    }

    function rollDice() public returns (uint) {
        require(msg.sender == players[turn], "It's not your turn");
        require(activePlayers > 1, "Game over");

        uint diceRoll = throwResult.rollDice();

        movePlayer(msg.sender, diceRoll);

        nextTurn();

        return diceRoll;
    }

    function movePlayer(address _player, uint _diceRoll) internal {
        Player storage player = playerInfo[_player];

        if (player.isActive) {
            player.position = (player.position + _diceRoll) % boardSize;

            if (player.position == 0) {
                player.isActive = false;
                activePlayers--;
                winner = _player;
            }
        }
    }

    function nextTurn() internal {
        do {
            turn = (turn + 1) % players.length;
        } while (!playerInfo[players[turn]].isActive);
    }
}
