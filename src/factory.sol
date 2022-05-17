// SPDX-License-Identifier: MIT
pragma solidity >0.4.23 <0.9.0;
import "./MerkleSalaryClaim.sol";
contract SalaryCalimFactory {
    MerkleSalaryClaim[] private Payroll;

  event payrollCreated(MerkleSalaryClaim indexed newPayroll); 

    function createPayroll() public returns(MerkleSalaryClaim){
        MerkleSalaryClaim _payroll = new MerkleSalaryClaim();
        Payroll.push(_payroll);
    emit payrollCreated(_payroll);

        return _payroll;

    }
    // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    function allPayrolls()
        public
        view
        returns (MerkleSalaryClaim[] memory coll)
    {
        return Payroll;
    }
}