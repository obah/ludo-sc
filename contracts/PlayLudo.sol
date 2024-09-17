//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./NumberGenerator.sol";

contract PlayLudo {
    error INSUFFICIENT_PLAYERS();

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
        require(_players.length > 1, "INSUFFICIENT_PLAYERS");

        players = _players;
        activePlayers = _players.length;
        throwResult = NumberGenerator(msg.sender);

        for (uint i = 0; i < _players.length; i++) {
            require(_players[i] != address(0), "ADDRESS_ZERO");

            playerInfo[_players[i]] = Player(0, true);
        }
    }

    function rollDice() external returns (uint) {
        require(msg.sender == players[turn], "WRONG_TURN");
        require(activePlayers > 1, "GAME_ENDED");

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
                activePlayers = activePlayers - 1;
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
