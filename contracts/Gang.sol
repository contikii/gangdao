// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

// LOL I'm retarded this doesn't need to be cloned hahah.

contract Gang is Initializable, ERC721Upgradeable, ERC721URIStorageUpgradeable  {
    uint16 constant maxMembers = 12;
    address public multisig;
    uint private _gangNumber;
    address[] public members;

    // Note on modifiers, need ownership controls if you're planning to set them both ways, e.g certain methods here can only be called by gangFactory, and gangFactory uses this as base.

    function initialize(string memory name, address[] calldata _owners, address _multisig) public initializer {
        _gangNumber = 1;
        __ERC721_init_unchained(name, "GANG");
        __ERC721URIStorage_init_unchained();
        members = _owners;
        multisig = _multisig;
    }

    function mint(address to) public {
        _mint(to, _gangNumber);
        _gangNumber ++;
    }
    
    // not sure why these need to be overridden
    function _burn(uint256 tokenId) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        _burn(tokenId);
    }

    // todo make it so profilepic can be changed, but only once. would be nice if it defaulted to something cool but that's optional
    function tokenURI(uint256 tokenId) public view override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return tokenURI(tokenId);
    }
}


/*
TODO 
    - add method to contract to read out nft from address? Hmm let's see, by calling dad_contract probably best
    - also all potential superfluidy logic should go in here
*/