// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";

/*  
    a. NFT to point to an address
    b. Keep track of the token ids
    c. Keep track of tocken owner addresses to token ids
    d. Keep track of how many tokens an owner address has
    e. Create an event that emits a transfer log - contract address, where it is being minted to, the id 
    */

contract ERC721 is ERC165, IERC721 {
    /*event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );*/

    // Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens
    mapping(address => uint256) private _numberOfTokens;

    // Mapping from tokenId to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256(
                    "balanceOf(bytes4)^ownerOf(bytes4)^transferFrom(bytes4)"
                )
            )
        );
    }

    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "Owner query for non-existent token");
        return _numberOfTokens[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        require(
            _tokenOwner[_tokenId] != address(0),
            "Owner query for non-existent token"
        );
        return _tokenOwner[_tokenId];
    }

    function exists(uint256 _tokenId) internal view returns (bool) {
        address owner = _tokenOwner[_tokenId];
        return owner != address(0);
    }

    function _mint(address _to, uint256 _tokenId) internal virtual {
        // requires that the address isn't zero
        require(_to != address(0), "ERC721 minting to the zero address");
        // requires that the token does not already exists
        require(!exists(_tokenId));
        // we are adding a new address with a token id for minting
        _tokenOwner[_tokenId] = _to;
        // keeping track of each address that is minting and adding
        _numberOfTokens[_to]++;

        emit Transfer(address(0), _to, _tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(_to != address(0), "Error - transfer to a zero address");
        require(_from != address(0), "Error - transfer from a zero address");
        require(
            ownerOf(_tokenId) == _from,
            "Trying to transfer a token the sender does not own"
        );
        _tokenOwner[_tokenId] = _to;
        _numberOfTokens[_from]--;
        _numberOfTokens[_to]++;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        //require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    /*function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(owner == _to, "Aprroval to current owner");
        require(
            msg.sender == owner,
            "Current caller is not the owner of the token"
        );
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        returns (bool)
    {
        address owner = ownerOf(tokenId);
        // || getApproved(spender) - does not exist here, exists in openzeppelin
        return (spender == owner);
    }*/
}
