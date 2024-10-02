# PlayLudo

This repository contains the smart contracts source code, interaction scripts and unit test suites for PlayLudo. The repository uses Hardhat as development environment for compilation, testing and deployment tasks.

## What is PlayLudo

PlayLudo implements a ludo game using a smart contract to control different aspects of the game and simulate randomness for dice throws.

## Contracts Documentation & Deployments

### [PlayLudo.sol](https://github.com/obah/ludo-sc/blob/main/contracts/PlayLudo.sol)

The `PlayLudo` contract simulates a simplified version of the classic Ludo board game on the Ethereum blockchain. Players take turns rolling a dice and advancing positions around the board. The first player to complete a full loop wins the game.

- Deployed address (Lisk Testnet): 0xA3E686ec019E71e6aBCabB163757fee56A2EBB04
- [Lisk Sepolia Blockscout verification link](https://sepolia-blockscout.lisk.com/address/0xA3E686ec019E71e6aBCabB163757fee56A2EBB04#code)

Key features:

- `Player Management`: Contract owner can set up players and start the game.
- `Turn-Based Gameplay`: Players take turns to roll the dice and advance their token.
- `Pseudorandom Dice Roll`: Dice rolls are simulated using pseudorandomness based on block timestamp and player address.
- `Win Condition`: The first player to complete the circuit (52 steps) wins the game.
- `Automatic Turn Switching`: The contract automatically advances to the next active player's turn.
- `Multiple Players`: The game requires at least two players to begin and can support multiple participants.

Functions:

- `Constructor`: Initialise the contract with setting the deployer as the owner.
- `setPlayers(address[] memory _players)`: Allows the owner to set the addresses of the participating players.
- `rollDice()`: Allows the player whose turn it is to roll the dice and move their token.
- `movePlayer(address _player, uint _diceRoll)`: Moves the player by the number rolled on the dice.
- `nextTurn()`: Advances the turn to the next active player. If the next player is inactive, it skips to the next active player.
- `_rollDice()`: Generates a pseudorandom number between 1 and 6 using keccak256 hashing with the current block timestamp and player's address.

## Setup and Installation

### Prerequisites

Ensure you have the following installed:

- Node.js
- Hardhat

### Installation

1. Clone the repository:

   ```
   git clone https://github.com/obah/ludo-sc.git
   cd ludo-sc
   ```

2. Install dependencies:
   ```
   npm install
   ```

## Test

To run the tests, use:

```
npx hardhat test
```
