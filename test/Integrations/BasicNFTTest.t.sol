//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Test} from "lib/forge-std/src/Test.sol";
import {DeployBasicNFT} from "script/DeployBasicNFT.s.sol";
import {BasicNFT} from "src/BasicNFT.sol";


contract BasicNFTTest is Test {
    DeployBasicNFT public deployer;
    BasicNFT public basicNFT;
    address public USER = makeAddr("user");
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNFT();
        basicNFT = deployer.run();

    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        //ERC721 has a function name wich returns the _name state variable
        string memory ObtainedName = basicNFT.name();
        // assertEq(expectedName,ObtainedName);
        //or we can compare the hash of strings
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(ObtainedName)));
    }

    function testCanMintandHaveBalence() public{
        vm.prank(USER);
        basicNFT.mintNFT(PUG);

        assert(basicNFT.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(basicNFT.tokenURI(0))) == keccak256(abi.encodePacked(PUG)));
    }


}