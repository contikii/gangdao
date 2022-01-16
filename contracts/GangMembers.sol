// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

// import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


contract GangMembers is Initializable, ERC721Upgradeable, ERC721URIStorageUpgradeable  { 
    using Counters for Counters.Counter;
    Counters.Counter private _memberIdCounter;

    uint8 constant maxMembers = 12;    
    
    
    mapping(uint => address) public idToMember;


    function initialize(string calldata name, string calldata symbol) initializer public {
      __ERC721_init_unchained(name, symbol);
      __ERC721URIStorage_init(); // not sure if 100% necessar
    }

    function mint(address to) public returns (uint) {
        uint currentId = _memberIdCounter.current();
        require(currentId <= maxMembers, "gang is full, join another one!");

       
        _mint(to, currentId);
        idToMember[currentId] = to;
        _memberIdCounter.increment();

        return currentId;
    }
    
    // TODO remove many of the unnecessary string memories being passed around, expensive
    function setTokenURI(uint tokenId, string memory metadataURI) external returns (string memory) {
        require(ownerOf(tokenId) == msg.sender, "you don't own that nft baby");

        _setTokenURI(tokenId, metadataURI);
        return metadataURI;
    }



    function _burn(uint256 tokenId) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}