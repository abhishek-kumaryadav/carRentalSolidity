// SPDX-License-Identifier: GPL-3.0
    
pragma solidity >=0.4.22 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../contracts/CarRental.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {

    //  'beforeAll' runs before all other tests
    // More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    CarRental carRentalToTest;
    function beforeAll() public {
        // Here should instantiate tested contract
        carRentalToTest = new CarRental();
    }

    function checkSuccess() public {
        // Use 'Assert' to test the contract, 
        // See documentation: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.equal(carRentalToTest.getOwnerSize(),0,"Empty owner list");
        Assert.equal(carRentalToTest.getRenterSize(),0,"Empty renter List");
    }

    function checkSuccess2() public {
        // Use the return value (true or false) to test the contract
        carRentalToTest.createOwner("First owner");
        bool success=carRentalToTest.addLocations(5,10);
        Assert.equal(success,true,"Location added");
        Assert.equal(carRentalToTest.getOwnerSize(),1,"1 Element");
        Assert.equal(carRentalToTest.getFirstLocationId(msg.sender),11,"check id");
        // Assert.equal(carRentalToTest.getLocationSize(msg.sender),1,"1 Location");
        
        
    }
    
    // function checkFailure() public {
    //     Assert.equal(uint(1), uint(2), "1 is not equal to 2");
    // }

    // /// Custom Transaction Context
    // /// See more: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    // /// #sender: account-1
    // /// #value: 100
    // function checkSenderAndValue() public payable {
    //     // account index varies 0-9, value is in wei
    //     Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
    //     Assert.equal(msg.value, 100, "Invalid value");
    // }
}
