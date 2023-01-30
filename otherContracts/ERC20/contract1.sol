// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GLDToken {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);
}
