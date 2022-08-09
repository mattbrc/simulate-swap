// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";

// for cheatcodes
interface Vm {
    function prank(address) external;

    function warp(uint256) external;
}

// Verify we received DAI
interface Dai {
    function balanceOf(address) external view returns (uint256);
}

contract ContractTest is DSTest {
    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    Dai dai = Dai(0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735);

    address constant myAddress = 0x8F952F26d6F256661b86d822648fe62B59c4E691;
    // SwapDAI metamask address
    address constant swapDai = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;

    function testSwap() public {
        // verify we are actually forking
        emit log_named_uint(
            "Current ether balance of myAddress",
            myAddress.balance
        );

        emit log_named_uint(
            "Dai balance of myAddress before",
            dai.balanceOf(myAddress)
        );

        bytes
            memory data = hex"5ae401dc0000000000000000000000000000000000000000000000000000000062f1cd8d00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000e4472b43f3000000000000000000000000000000000000000000000000016345785d8a0000000000000000000000000000000000000000004885eb69c6b29cca5c7e5a9fef00000000000000000000000000000000000000000000000000000000000000800000000000000000000000008f952f26d6f256661b86d822648fe62b59c4e6910000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c778417e063141139fce010982780140aa0cd5ab000000000000000000000000c7ad46e0b8a400bb3c915120d284aafba8fc473500000000000000000000000000000000000000000000000000000000";

        // set the next call's msg.sender as myAddress
        vm.prank(myAddress);

        (bool sent, ) = payable(swapDai).call{value: 0.5 ether}(data);
        require(sent, "failed");

        emit log_named_uint(
            "Dai balance of myAddress after",
            dai.balanceOf(myAddress)
        );
    }
}
