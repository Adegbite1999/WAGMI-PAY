// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
// import "openzeppelin-contracts/contracts/access/Ownable.sol";
//https://github.com/Openzeppelin/
contract MerkleSalaryClaim  {
    //@notice ERC20-claimee inclusion root
    bytes32 merkleRoot;
    bool activatePayment;
    uint startTime;
    uint public TotalSalary;
    

    struct ContractDEtails{
        address ContractAddress;
        address owner;
        string bizName;


    }
    ContractDEtails public contractDetails;

   

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

        //============== CONSTRUCTOR =============//
        constructor(string memory _name, address _Admin){
        contractDetails.owner = _Admin;
        contractDetails.bizName = _name;
        contractDetails.ContractAddress = address(this);

    }
    //===============modifiers===================//
    modifier onlyOwner(){
        require(contractDetails.owner == msg.sender, "Only Admin can call this function");

        _;
    }


    /// ==================FUNCTIONS ===============


//@notice: update merkleRoot if a new employee is added or removed.
    function updateMerkleRoot(bytes32 _merkleRoot) public onlyOwner{
        merkleRoot = _merkleRoot;
    }

    //@notice Allows claiming salary if address is part of merkle tree
    //@param msg.sender: address of claimee
    //@param amount: amount of salary owed to claimee (employee)
    // @param proof merkle proof to prove address and amount are in merkle tree

    //@notice Allows claiming salary if address is part of merkle tree
    //@param msg.sender: address of claimee
    //@param amount: amount of salary owed to claimee (employee)
    // @param proof merkle proof to prove address and amount are in merkle tree
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

    //@notice Allows Admin to set time for payment send 
    // Ethers to smart contract for emoloyer to come claim their salary
    function setPayement() external payable onlyOwner{
        require(msg.value >= TotalSalary, "not enough money to pay employees");
        activatePayment = true;
         startTime = block.timestamp;
    }

    //@notice Allows Admin to set time for payment send 
    // Ethers to smart contract for emoloyer to come claim their salary
    function setValue() external payable onlyOwner{
        require(msg.value >= 0, "make sure to pay enough Salary");
        activatePayment = true;
         startTime = block.timestamp;
    }

    ////@notice Allows Admin transferOut the balance in the smart contract
    
    //@notice Allows Admin to Add Employees and their Salary
    //@param _eployees address of employees to be added
    //@param _salary amount of salary an employer is entitle to pay

    function AddEmployees(address _employee, uint _salary) public onlyOwner returns (Staff[] memory _staffsPayroll){
        Staff memory staffsPayrolls = Staff(_employee, _salary);
        StaffsPayroll.push(staffsPayrolls);
        _staffsPayroll = seeEMployees();
        TotalSalary = TotalSalary + _salary;

    }
    ////@notice returns employees in the firms

    function seeEMployees() public view returns(Staff[] memory _staffsPayroll){
        _staffsPayroll = StaffsPayroll;

    }
    ////@notice Allows Admin to change Admin
    function changeAdmin(address newOwner)  public onlyOwner returns(address){
        contractDetails.owner = newOwner;
        return contractDetails.owner;

    }

    function transferOut() public onlyOwner{
        require(block.timestamp - startTime >= 1209600, "salary payment ongoing");
        payable(msg.sender).transfer(address(this).balance);
        activatePayment = false;

    }
    ////@notice returns the current Admin
    function getAdmin() public view  returns(address){
        return contractDetails.owner;
    }
receive() external payable{}


 
    
}
