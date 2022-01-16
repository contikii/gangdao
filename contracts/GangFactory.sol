// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./IGnosisSafe.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


import "./GangMembers.sol";
import "./Gang.sol";

// TODO import gnosis safe Interface and use it to call getOwners on contract
// TODO another ERC165 validation check in place? 

contract GangFactory is ERC721, ERC721URIStorage, ERC721Enumerable {
    using Counters for Counters.Counter;

    address public membersBase; 
    // address public gangBase;
    Counters.Counter private _gangIdCounter;


    mapping(uint => address) tokenToMultisig;
    mapping(uint => bool) pfpChanged;

    mapping(address => address[]) multisigToMembers; 
    mapping(uint => address) tokenToMembers; 



    constructor (address _memberBase) ERC721("gangDAO group tokens", "GANG") {
        membersBase = _memberBase;
    }


    function createGang(string memory name, string memory symbol) external returns (uint gangId, address membersContract) {
        address[] memory owners = IGnosisSafe(msg.sender).getOwners();

        require(owners.length > 0, "function needs to be called by a gnosis safe."); // this can be spoofed quite easily for now
        require(owners.length <= 12, "squads degenerate fast if they're bigger than 12");
    
        multisigToMembers[msg.sender] = owners;

        uint gangToken = _gangIdCounter.current();
        _mint(msg.sender, gangToken);
        _gangIdCounter.increment();

        tokenToMultisig[gangToken] = msg.sender;

        address members = Clones.clone(membersBase);
        tokenToMembers[gangToken] = members;

        GangMembers(members).initialize(name, symbol);
        for (uint i = 0; i < owners.length; i ++) {
            GangMembers(members).mint(owners[i]);
        }
                
        return (gangToken, members);
    }

    function setTokenURI(uint tokenId, string memory metadataURI) external returns (string memory) {
        require(ownerOf(tokenId) == msg.sender, "only owner can change token information, once");
        require(!pfpChanged[tokenId], "you already changed metadata");

        _setTokenURI(tokenId, metadataURI);
        return metadataURI;
    }

    function mintMembers(string memory name, string memory symbol) external returns (address) {// what more do you want to customize?
        address[] memory owners = IGnosisSafe(msg.sender).getOwners();
        require(owners.length > 0, "function needs to be called by a gnosis safe."); 
        require(owners.length <= 12, "squads degenerate fast if they're bigger than 12");

        address members = Clones.clone(membersBase);
        // store this somewhere
        

        GangMembers(members).initialize(name, symbol);
        for (uint i = 0; i < owners.length; i ++) {
            GangMembers(members).mint(owners[i]);
        }
        
        return members;
    }

     
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }


}

/*

next: 
    - create simpleGang nft, embed owners somehow?
    - actually lol y not cap the whole thing at simply 12 hahah
    - add counter for gangNumber
*/