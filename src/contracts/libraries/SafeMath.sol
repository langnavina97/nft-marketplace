// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/*
    build functions to perform safe math operations that would
    otherwise replace intuitive preventative measure
    (not provided by Solidity)
*/

library SafeMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 r = x + y;
        require(r >= x, "SafeMath: addition overflow");
        return r;
    }

    function subtract(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 r = x - y;
        require(y <= x, "SafeMath: substraction overflow");
        return r;
    }

    function multiply(uint256 x, uint256 y) internal pure returns (uint256) {
        if (x == 0) {
            // is cheaper (gas costs)
            return 0;
        }
        uint256 r = x * y;
        require(r / x == y, "SafeMath: multiplication overflow");
        return r;
    }

    function divide(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y > 0, "SafeMath: division by zero");
        uint256 r = x / y;
        return r;
    }

    function mod(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y != 0, "SafeMath: modulo by zero");
        return x % y;
    }
}
