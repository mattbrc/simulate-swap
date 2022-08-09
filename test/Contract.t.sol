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
    // mainnet dai token address
    Dai dai = Dai(0x6B175474E89094C44Da98b954EedeAC495271d0F);

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
            // mainnet multicall(uint256, Bytes[]) hex code 
            memory data = hex"5ae401dc0000000000000000000000000000000000000000000000000000000062f2613d00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000e404e45aaf000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20000000000000000000000006b175474e89094c44da98b954eedeac495271d0f00000000000000000000000000000000000000000000000000000000000001f40000000000000000000000008f952f26d6f256661b86d822648fe62b59c4e691000000000000000000000000000000000000000000000000002386f26fc10000000000000000000000000000000000000000000000000000ea942a9196175d57000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

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
