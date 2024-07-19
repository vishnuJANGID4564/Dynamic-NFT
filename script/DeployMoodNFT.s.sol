//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {MoodNFT} from "src/MoodNFT.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

contract DeployMoodNFT is Script {
    function run() external returns(MoodNFT){
       string memory sadSVG = vm.readFile("./img/Sad.svg");
       string memory happySVG = vm.readFile("./img/Happy.svg");

       vm.startBroadcast();
       MoodNFT moodNFT = new MoodNFT(
        svgToImageURI(sadSVG),svgToImageURI(happySVG)
       );
       vm.stopBroadcast();

       return moodNFT;
    }

    // throught this function we aim to encode any svg file 
    function svgToImageURI(string memory svg) public pure returns(string memory){
        string memory baseUri = "data:image/svg+xml;base64,";
        // now simmilar to how we Encoded in MoodNFT.sol 
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseUri,svgBase64Encoded));
    }
}