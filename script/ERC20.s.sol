// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

import {Script} from "forge-std/Script.sol";
import {ERC20} from "../src/ERC20.sol";

contract ERC20Script is Script {
    ERC20 public erc20;

    function setUp() public {}

    function run() public {
        uint256 key = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(key);

        erc20 = new ERC20("Test", "TST", 18);

        vm.stopBroadcast();
    }
}
