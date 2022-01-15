// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/utils/Strings.sol";


contract Gang is Initializable, ERC721Upgradeable, ERC721URIStorageUpgradeable  {
    address public multisig;
    uint16 public maxMembers;
    uint public gangNumber;
    address[] public members;
    uint counter;

    function initialize(string memory name, uint _gangNumber, address[] calldata _owners) public initializer {
        maxMembers = 12;
        gangNumber = _gangNumber;
        counter = 1;
        __ERC721_init_unchained(name, "GANG");
        members = _owners;
        multisig = msg.sender;
    }

    function mint(address to) public {
        _mint(to, counter);
        counter ++;
    }
    
    // not sure why these need to be overridden
    function _burn(uint256 tokenId) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        _burn(tokenId);
    }


    function tokenURI(uint256 tokenId) public view override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return tokenURI(tokenId);
    }
}


/*
TODO 
    - add method to contract to read out nft from address? Hmm let's see, by calling dad_contract probably best



*/