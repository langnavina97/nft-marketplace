// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract ERC721Metadata {
    string private _name;
    string private _symbol;

    constructor(string memory name, string memory symbol) {
        _name = name;
        _symbol = symbol;
    }

    function getName() external view returns (string memory) {
        return _name;
    }

    function getSymbol() external view returns (string memory) {
        return _symbol;
    }
}
