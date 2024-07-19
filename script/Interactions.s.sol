//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNFT} from "src/BasicNFT.sol";

contract MintBasicNFT is Script{
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    function run() external {
        //we always want to be working with the most recently deployed BasicNFT
        //so we will use the cyfrin foundry devops 
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNFT", block.chainid);
        mintNFTonContract(mostRecentlyDeployed);
    }

    function mintNFTonContract(address LatestDeployedNFT) public {
        vm.startBroadcast();
        BasicNFT(LatestDeployedNFT).mintNFT(PUG);//This part is casting the address LatestDeployedNFT to the BasicNFT contract type.
        vm.stopBroadcast();
    }
}