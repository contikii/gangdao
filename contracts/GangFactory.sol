// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./IGnosisSafe.sol";
import "./Gang.sol";

// TODO import gnosis safe Interface and use it to call getOwners on contract
// TODO another ERC165 validation check in place? 

contract GangFactory {
    // address of original gangmembers contract
    address public membersBase;
    // address of original gang contract
    address public gangVault;

    // gangToken => gangmembers
    mapping(address => address[]) gangYellowPages;

    // constructor (address _membersBase, address _gangVault) {
    //     membersBase = _membersBase;
    //     gangVault = _gangVault;
    // }
    constructor (address _gangVault) {
        membersBase = address(0);
        gangVault = _gangVault;
    }


    function createGang(string memory name) external returns (address) {
        // get owners of multisig
        address[] memory owners = IGnosisSafe(msg.sender).getOwners();
        require(owners.length > 0, "function needs to be called by a gnosis safe."); // this can be spoofed quite easily..
        
        address newGang = Clones.clone(gangVault);
        gangYellowPages[newGang] = owners;

        Gang(newGang).initialize(name, 2, owners);  // pass multisig otherwise factory will be the owner of all things
        Gang(newGang).mint(msg.sender);
        
        return newGang;
    }
}



/*

next: 
    - create simpleGang nft, embed owners somehow?
    - actually lol y not cap the whole thing at simply 12 hahah
    - add counter for gangNumber
*/