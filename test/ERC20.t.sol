// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

import {Test, console2, StdStyle} from "forge-std/Test.sol";
import {ERC20} from "../src/ERC20.sol";

contract BaseSetup is Test, ERC20 {
    address internal alice;
    address internal bob;

    constructor() ERC20("Test", "TST", 18) {}

    function setUp() public virtual {
        // NOTE: setup for the test (runs before every test case)
        alice = makeAddr("alice");
        bob = makeAddr("bob");

        _mint(alice, 300e18);

        console2.log(StdStyle.red("setup"));
    }
}

contract ERC20TransferTest is BaseSetup {
    function setUp() public override {
        BaseSetup.setUp();
    }

    // NOTE: every test function must start with the word "test"
    // NOTE: and has to be declared as "public" to be run
    function testTransfersTokenCorrectly() public {
        // NOTE: prank means the next transaction is executed in the context
        // NOTE: of alice being the caller (msg.sender)
        vm.prank(alice);
        bool success = this.transfer(bob, 100e18);

        assertTrue(success);
        assertEq(balanceOf[alice], 200e18);
        assertEq(balanceOf[bob], 100e18);
    }
    
    function testCannotTransferMoreThanBalance() public {
        vm.prank(alice);
        // NOTE: expectRevert means that the next transaction should revert
        vm.expectRevert("ERC20: insufficient balance");
        this.transfer(bob, 400e18);
    }

    function testEmitsTransferEvent() public {
        vm.expectEmit(
            true, // check 1st indexed parameter
            true, // check 2nd indexed parameter
            false, // check 3rd indexed parameter (since we don't have a third index)
            true  // check data parameter
        );
        // NOTE: we should follow the `vm.expectEmit` with the event
        // NOTE: that we expect to be emitted
        emit Transfer(alice, bob, 150e18);
        vm.prank(alice);
        this.transfer(bob, 150e18);
    }
}
