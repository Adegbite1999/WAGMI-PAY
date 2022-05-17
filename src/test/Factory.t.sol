pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../factory.sol";

contract FactoryTest is DSTest {
    SalaryCalimFactory salaryCalimFactory;

    function setUp() public{
        salaryCalimFactory = new SalaryCalimFactory();
    }
    function testcreatePayroll() public{
        salaryCalimFactory.createPayroll();
        
    }
    



}