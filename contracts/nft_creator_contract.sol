//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTCreator is ERC721URIStorage, Ownable {
    uint256 public tokenIdCounter = 0;

    constructor() ERC721("NFTm dApp", "NFTm") {}

    function mint(address _to, string calldata _uri) external {
        uint256 _tokenId = tokenIdCounter;
        _mint(_to, _tokenId);
        _setTokenURI(_tokenId, _uri);
        tokenIdCounter++;
    }
}
