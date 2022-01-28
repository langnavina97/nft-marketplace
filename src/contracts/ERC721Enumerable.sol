// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./interfaces/IERC721Enumerable.sol";

import "./ERC721.sol";

contract ERC721Enumerable is ERC721, IERC721Enumerable {
    uint256[] private _allTokens;

    // mapping from tokenId to position in _allToken array
    mapping(uint256 => uint256) private _allTokensIndex;

    // mapping of owner to list of all owner tokens
    mapping(address => uint256[]) private _ownedTokens;

    // mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokenIndex;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("totalSupply(bytes4)") ^
                    keccak256("tokenByIndex(bytes4)") ^
                    keccak256("tokenOfOwnerByIndex(bytes4)")
            )
        );
    }

    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }

    function _mint(address _to, uint256 _tokenId) internal override(ERC721) {
        super._mint(_to, _tokenId);
        _addTokensToOwnerEnumeration(_to, _tokenId);
        _addTokensToAllTokenEnumeration(_tokenId);
    }

    // add token to the _allToken array and set the position of the token
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokens[to].push(tokenId);
        _ownedTokenIndex[tokenId] = _ownedTokens[to].length;
    }

    function tokenByIndex(uint256 index)
        public
        view
        override
        returns (uint256)
    {
        require(index < totalSupply(), "Global index is out of bounds!");
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index)
        public
        view
        override
        returns (uint256)
    {
        require(index < balanceOf(owner), "Owner index is out of bounds!");
        return _ownedTokens[owner][index];
    }
}
