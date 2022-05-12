// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MerkleERC20Claim {
    //@notice ERC20-claimee inclusion root
    bytes32 immutable merkleRoot;

    // @notice Mapping of address who have claimed salaries
    mapping(address => bool) public hasClaimedSalary;

    // ERRORS
    error AlreadyClaimed();
    error NotInMerkle();


}
