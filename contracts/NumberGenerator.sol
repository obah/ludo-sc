//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract NumberGenerator {
    uint8 diceSides = 6;

    function rollDice() external view returns (uint8) {
        bytes32 _randomiser = keccak256(
            abi.encodePacked(block.timestamp, msg.sender)
        );

        uint256 _side = (uint256(_randomiser) % diceSides) + 1;

        return uint8(_side);
    }
}
