// SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

/* 
    as the constructor of ERC721 is :-
    // constructor(string memory name_, string memory symbol_) {
    //     _name = name_;
    //     _symbol = symbol_;
    // }
    So i also need to pass name and symbol for ERC721 in the constructor of this BasicNFT
*/
contract BasicNFT is ERC721 {
    //Each token in this NFT collection is unique and will have a unique token ID 
    //For us we are using a simple tokenCounter representing each tokenId
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToURI;

    constructor() ERC721("Dogie","DOG"){
        s_tokenCounter=0;
    }

    function mintNFT(string memory tokenUri) public{
        s_tokenIdToURI[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender,s_tokenCounter); // _safemint is a fucntion in ERC721.sol to mint a NFT 
        // this will change the balance
        s_tokenCounter++;
    }

    //URI:- its like an endpoint that gives the meta data of the NFT in a standardised Format
    function tokenURI(uint256 tokenId) public view override returns(string memory ){
        return s_tokenIdToURI[tokenId];
    }
}