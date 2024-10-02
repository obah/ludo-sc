//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract PlayLudo {
    address immutable OWNER;
    address winner;
    address[] public players;

    uint8 diceSides = 6;
    uint8 steps = 52;
    uint8 activePlayers;
    uint8 turn;

    struct Player {
        uint8 position;
        bool isActive;
    }

    mapping(address => Player) public playerInfo;

    constructor() {
        OWNER = msg.sender;
    }

    function setPlayers(address[] memory _players) external {
        require(msg.sender == OWNER, "UNATHOURIZED_ACCESS");
        require(_players.length > 1, "INSUFFICIENT_PLAYERS");

        players = _players;
        activePlayers = uint8(_players.length);

        for (uint8 i = 0; i < _players.length; i++) {
            require(_players[i] != address(0), "ADDRESS_ZERO");

            playerInfo[_players[i]] = Player(0, true);
        }
    }

    function rollDice() external returns (uint) {
        require(msg.sender == players[turn], "WRONG_TURN");
        require(activePlayers > 1, "GAME_ENDED");

        uint diceRoll = _rollDice();

        movePlayer(msg.sender, diceRoll);

        nextTurn();

        return diceRoll;
    }

    function movePlayer(address _player, uint _diceRoll) private {
        Player storage player = playerInfo[_player];

        if (player.isActive) {
            player.position = uint8((player.position + _diceRoll) % steps);

            if (player.position == 0) {
                player.isActive = false;
                activePlayers = activePlayers - 1;
                winner = _player;
            }
        }
    }

    function nextTurn() private {
        do {
            turn = (turn + 1) % uint8(players.length);
        } while (!playerInfo[players[turn]].isActive);
    }

    function _rollDice() private view returns (uint8) {
        bytes32 _randomiser = keccak256(
            abi.encodePacked(block.timestamp, msg.sender)
        );

        uint256 _side = (uint256(_randomiser) % diceSides) + 1;

        return uint8(_side);
    }
}
