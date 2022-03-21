// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7 <0.9.0;

contract PseudoRandomGenerator {
    uint256 private _seed;

    constructor() {
        _seed = block.timestamp * block.number;
    }

    function genRandom() public {
        if (_seed > (2 ** 32)) {
            _seed = _seed % (2 ** 32);
        }
        _seed = _seed * 23 + block.number;
    }

    function getDiceRoll() public view returns (uint256) {
        return _seed % 6 + 1;
    }
}