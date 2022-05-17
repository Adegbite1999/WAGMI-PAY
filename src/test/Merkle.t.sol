pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Test.sol";
import "../MerkleSalaryClaim.sol";
import "forge-std/console2.sol";

contract FactoryTest is DSTest, Test {
    MerkleSalaryClaim merkleSalaryClaim;

    function setUp() public{
        merkleSalaryClaim = new MerkleSalaryClaim();
    }
    // function testsetPayement() public{
    //     vm.expectRevert("not enough money to pay employees");
    //     merkleSalaryClaim.setPayement();
        
    // }
    function testAddEmployees() public{
        merkleSalaryClaim.AddEmployees( 0x365Bc7A7B4D8Fe5d45F77aD67BC5bD4F9a748C20, 3e18);
        merkleSalaryClaim.AddEmployees( 0x365Bc7A7B4D8Fe5d45F77aD67BC5bD4F9a748C20, 5e18);
        merkleSalaryClaim.AddEmployees( 0x365Bc7A7B4D8Fe5d45F77aD67BC5bD4F9a748C20, 3e18);
        // vm.expectRevert("not enough money to pay employees");
        merkleSalaryClaim.setPayement{value: 20e18}();
        
        
    }
    
    function testtransferOut() public{
        
        // vm.expectRevert("salary payment ongoing");
        merkleSalaryClaim.transferOut();
        // vm.prank(address(this));
        // vm.warp(1209600);
        // assertFalse(true);
        merkleSalaryClaim.transferOut();
        // changeHoax(merkleSalaryClaim());

    }
    function testupdateMerkleRoot() public{
        merkleSalaryClaim.updateMerkleRoot(0x61c7c43e255825f7f5063ece0849495f28e5865c536d43abea38ec56b0ce9e35);
    }

    
    



}