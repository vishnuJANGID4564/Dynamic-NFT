//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";
 
contract MoodNFT is ERC721 {

    //errors
    error MoodNFT__CantFlipMoodAsNotTheOwnerNeitherApproved();

    uint256 private s_tokenCounter;
    string private s_HappySVGImageUri;
    string private s_SadSVGImageUri;

    enum Mood{
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory sadsvgImageUri, string memory happysvgImageUri) ERC721("Mood NFT", "MN"){
        s_HappySVGImageUri = happysvgImageUri;
        s_SadSVGImageUri = sadsvgImageUri;
        s_tokenCounter=0;
    }

    //we are allowing anybody to mint these
    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY; // setting default Happy
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        //we want that only the owner can change the mood
        //ERC721 has a buildIn fucntion for checking Approved or owner
        // if(!_isApprovedOrOwner(msg.sender,tokenId)){
        //     revert MoodNFT__CantFlipMoodAsNotTheOwnerNeitherApproved();
        // }

        if(s_tokenIdToMood[tokenId]==Mood.HAPPY){
            s_tokenIdToMood[tokenId]=Mood.SAD;
        }else{
            s_tokenIdToMood[tokenId]=Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns(string memory){ // ERC721 also has a fucntion _baseURI
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns(string memory ){
        //what we will be doing is that instead of passing the SVG text we will be passing the Already encoded SVG
        // But How?
        // MetaData -> JSON Object ---Encoded using OpenZepplin Base64 package---> JSON Token URI 
                    //OpenZepplin Base64 package -> used to transform bytes32 data into base64 string, Especially for building URL-safe TokenURI 
        
        string memory imageUri;
        if(s_tokenIdToMood[tokenId] == Mood.HAPPY){
            imageUri = s_HappySVGImageUri;
        }
        else{
            imageUri = s_SadSVGImageUri;
        }

        return
            string(
                abi.encodePacked(
                    //adding the baseURI so that it becomes ready to used by Browser
                    _baseURI(),
                    Base64.encode(
                        //Now applying Base64 to this to get that large encode string that we got from the terminal via base64 -i example.svg
                        bytes( 
                            //we need to convert this into bytes so that base64 laga sake
                            abi.encodePacked(
                                '{"name":"',
                                name(),
                                '", "description" : "The NFT that reflects the owner mood", "attributes" : [{"trait_type" :"moodiness", "value":100}], "image" : "',
                                imageUri,
                                '"}'
                            )
                        )
                    )
                )
            );
                                                 

    }

}