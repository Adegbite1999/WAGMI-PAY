// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MerkleERC20Claim {
    //@notice ERC20-claimee inclusion root
    bytes32 immutable merkleRoot;
    string public bizName;
    string public bizSymb;


    // EVENT
    event Claim(address, uint256);
    // @notice Mapping of address who have claimed salaries
    mapping(address => bool) public hasClaimedSalary;

            // ============== ERRORS=================
            error AlreadyClaimed();
            error NotInMerkle();

            constructor(
                string memory _name,
                string memory _symbol,
                bytes32 _merkleRoot
            ){
            bizName = _name;
            bizSymb = _symbol;
            merkleRoot = _merkleRoot;
            }

    /// ==================FUNCTIONS ===============

    //@notice Allows claiming salary if address is part of merkle tree
    //@param msg.sender: address of claimee
    //@param amount: amount of salary owed to claimee (employee)
    // @param proof merkle proof to prove address and amount are in merkle tree

    function claim(uint256 amount, bytes32[] calldata proof) external {
        // Throw error if address has already claimed salary
        if(hasClaimedSalary[msg.sender]) revert AlreadyClaimed();
            bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));
            bool isValidLeaf = MerkleProof.verify(proof, merkleRoot, leaf);
            if(!isValidLeaf) revert NotInMerkle();
            hasClaimedSalary[msg.sender] = true;

            // Emit claim event
            emit Claim(msg.sender, amount);
    }

    // verify merkle proof, or revert if not in tree



}
