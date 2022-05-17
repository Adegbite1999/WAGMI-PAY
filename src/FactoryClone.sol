// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./MerkleSalaryClaim.sol";
import "openzeppelin-contracts/contracts/proxy/Clones.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";


contract PayrollFactory is Ownable{
  using Clones for *;
  address public payrollAddress;
  event payrollCreated(address indexed newPayroll); 
  address[] payrollAddresses; 

  constructor(){
      payrollAddress = address (new MerkleSalaryClaim());

  }

  function CreatePayroll() public {
    address clonePayroll = Clones.clone(payrollAddress);
    payrollAddresses.push(clonePayroll);
    emit payrollCreated(clonePayroll);
  
  }
  function getAllpayrolls() public view returns(address[] memory _Allpayrolls){
      _Allpayrolls = payrollAddresses;
  }
}