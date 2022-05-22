pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../factory.sol";

contract FactoryTest is DSTest {
    SalaryClaimFactory salaryClaimFactory;

    function setUp() public{
        salaryClaimFactory = new SalaryClaimFactory();
    }
    function testcreatePayroll() public returns(address, address){
       
        return (salaryClaimFactory.createPayroll("Gold"));
    }
    



}