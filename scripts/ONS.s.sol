// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Script.sol";

import { ONS } from "contracts/ONS.sol";

contract ONSScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        new ONS();
    }
}
