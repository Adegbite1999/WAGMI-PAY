// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./MerkleSalaryClaim.sol";
import "openzeppelin-contract/contracts/proxy/Clones.sol";
import "openzeppelin-contract/contracts/access/Ownable.sol";


contract PayrollFactory is Ownable, Clones{
  address public payrollAddress;
  event payrollCreated(address indexed newPayroll); 
  address[] payrollAddresses; 

  constructor(address _payrollAdress){
      payrollAddress = _payrollAdress;

  }

  function CreatePayroll(string _name) public {
    address clonePayroll = clone(payrollAddress);
    payrollAddresses.push(clonePayroll);
    emit payrollCreated(clonePayroll);
  
  }
  function getAllpayrolls() view returns(address[] memory _Allpayrolls){
      _Allpayrolls = payrollAddresses;
  }
}