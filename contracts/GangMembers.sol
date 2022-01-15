pragma solidity ^0.8.3;

// import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


contract GangMembers is Initializable, ERC721Upgradeable, ERC721URIStorageUpgradeable  {
    address public gangFactory;

    uint8 public maxMembers;

    function initialize(string calldata name, string calldata symbol, uint8 members) initializer public {
      __ERC721_init_unchained(name, symbol);
      maxMembers = members;

      // maybe mint everything in here or too much gas? 
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
