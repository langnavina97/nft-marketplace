// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./ERC721Connector.sol";

contract CryptoBirdz is ERC721Connector {
    // array to store our nfts
    string[] public cryptoBirdz;
    mapping(string => bool) _cryptoBirdzExists;

    function mint(string memory _cryptoBird) public {
        require(!_cryptoBirdzExists[_cryptoBird], "CryptoBird already exists");
        cryptoBirdz.push(_cryptoBird);
        uint256 id = cryptoBirdz.length - 1;

        _mint(msg.sender, id);

        _cryptoBirdzExists[_cryptoBird] = true;
    }

    constructor() ERC721Connector("CryptoBird", "CBIRD") {}
}
