// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract MerkleERC20Claim {
    //@notice ERC20-claimee inclusion root
    bytes32 immutable merkleRoot;
    bool activatePayment;
    uint40 startTime;
    string public bizName;
    string public bizSymb;

    struct Staff{
        address employee;
        uint salary;
    }

    Staff[] public StaffsPayroll;


    // EVENT
    event Claim(address, uint256);
    // @notice Mapping of address who have claimed salaries
    mapping(address => bool) public hasClaimedSalary;

            // ============== ERRORS=================
            error AlreadyClaimed();
            error NotInMerkle();


    /// ==================FUNCTIONS ===============

    //@notice Allows claiming salary if address is part of merkle tree
    //@param msg.sender: address of claimee
    //@param amount: amount of salary owed to claimee (employee)
    // @param proof merkle proof to prove address and amount are in merkle tree

//@notice: update merkleRoot if a new employee is added or removed.
    function updateMerkleRoot(bytes32 _merkleRoot) public onlyOwner{
        merkleRoot = _merkleRoot;
    }

    function claim(uint256 amount, bytes32[] calldata proof) external payable {
        //throw err if payment time has not been calculated
        require(activatePayment, "not pament period");
        //throw error if not claimed in 14days
        require(block.timestamp - startTime <= 1209600, "time to claim salary elapsed");
        // Throw error if address has already claimed salary
        if(hasClaimedSalary[msg.sender]) revert AlreadyClaimed();
            bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));
            bool isValidLeaf = MerkleProof.verify(proof, merkleRoot, leaf);
            if(!isValidLeaf) revert NotInMerkle();
            hasClaimedSalary[msg.sender] = true;
            payable(msg.sender).transfer(amount);
            // Emit claim event
            emit Claim(msg.sender, amount);
    }
    function setPayement() external payable onlyOwner{
        require(msg.value >= 1 ether, "not enough money to pay employees");
        activatePayment = true;
         startTime = block.timestamp;
    }
  
// deduct/reduce funds
    function transferOut() public onlyOwner{
        require(block.timestamp - startTime >= 1209600, "salary payment ongoing");
        payable(owner()).transfer(address(this).balance);
        activatePayment = false;

    }
    function AddEmployees(address _employee, uint _salary) public onlyOwner returns (Staff[] memory _staffsPayroll){
        StaffsPayroll.push({employee:_employee, salary:_salary});
        _staffsPayroll = seeEMployees();

    }
    function seeEMployees() public view returns(Staff[] memory _staffsPayroll){
        _staffsPayroll = StaffsPayroll;

    }
    

receive() external payable{}


 
    
}
