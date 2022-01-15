// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./IGnosisSafe.sol";

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
    constructor () {
        membersBase = address(0);
        gangVault = address(0);
    }


    // #view if nothign happens right babty
    function createGang() external view returns (address[] memory){
        // get owners of function calling multisig
        address[] memory owners = IGnosisSafe(msg.sender).getOwners();
        return owners;
    }


}