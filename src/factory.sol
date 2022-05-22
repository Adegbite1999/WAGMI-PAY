// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.6;
import "./MerkleSalaryClaim.sol";
contract SalaryClaimFactory {
    address[] private Payroll;

  event payrollCreated(address indexed newPayroll, address indexed owner); 

    function createPayroll(string memory _name) public returns(address, address){
        MerkleSalaryClaim _payroll = new MerkleSalaryClaim(_name, msg.sender);
        Payroll.push(address(_payroll));
    emit payrollCreated(address(_payroll), msg.sender);
    return (address(_payroll), msg.sender);


    }
    
    function allPayrolls()
        public
        view
        returns (address[] memory coll)
    {
        return Payroll;
    }
}