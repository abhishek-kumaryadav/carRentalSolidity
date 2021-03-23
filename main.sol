pragma solidity >=0.7.0 <0.8.0;
// SPDX-License-Identifier: MIT
contract carRental{
struct Car{
    string id;
    string model;
    uint mileage;
    uint avail; // 0:waiting 1:running 2:finished
    uint startBlock;
    uint ttf;
}
struct Location{
    uint locid;
    uint carCount;
    int x;
    int y;
}
struct Owner{
    string name;
    uint id;
    uint locCount;
    uint earnings;
    bool exists;
}
struct Renter{
    string aadhar;
    uint balance;
    bool exists;
}

    uint countOwner=0;
    mapping(address => Owner) public ownersMap;
    address[] owners;
    uint countRenter=0;
    mapping(address => Renter) public rentersMap;
    address[] renters;
    mapping(uint => Location[]) public locations;
    mapping(uint => Car[]) public cars;
    
function createOwner  (string memory _name)
public
alreadyPresent
    //check if owner alread present
    //check if renter present
returns (bool success)
{
    countOwner++;
    ownersMap[msg.sender].name=_name;
    ownersMap[msg.sender].id=countOwner;
    ownersMap[msg.sender].earnings=0;
    ownersMap[msg.sender].exists=true;
    ownersMap[msg.sender].locCount=0;
    owners.push(msg.sender);
    return true;
    
}
function createRenter(string memory _aadhar)
public
alreadyPresent
returns (bool success)
{
    countRenter++;
    rentersMap[msg.sender].aadhar=_aadhar;
    rentersMap[msg.sender].balance=0;
    rentersMap[msg.sender].exists=true;
    return true;
}

function addLocations(int  _x, int  _y, uint  _ownerId)
public
checkLocation(_x, _y,_ownerId)
returns (bool success)
{
    ownersMap[msg.sender].locCount++;
    uint locationCount=ownersMap[msg.sender].locCount;
    locations[ownersMap[msg.sender].id].push(Location({
        x:_x,
        y:_y,
        locid:10*_ownerId+locationCount,
        carCount:0
    }));
    return true;
}
function addCars(string memory _id, string memory _model, uint _mileage, uint _locIndex, uint _ownerId, uint _locid)
public
carCheck(_ownerId, _locid, _locIndex)
    // check sender loc and owner id to be same as sent from request
returns (bool success)
{
    cars[(locations[ownersMap[msg.sender].id][_locIndex]).locid].push(Car({
        id:_id,
        model:_model,
        mileage:_mileage,
        avail:0,
        startBlock:0,
        ttf:0
    }));
    return true;
}

// addJourney()
// completeJourney()
modifier alreadyPresent{
    assert(ownersMap[msg.sender].exists==true||rentersMap[msg.sender].exists==true);
    _;
}
modifier carCheck(uint _ownerId, uint _locid, uint _locIndex){
    assert(ownersMap[msg.sender].id!=_ownerId);
    assert(locations[ownersMap[msg.sender].id][_locIndex].locid==_locid);
    _;
}
modifier checkLocation(int _x, int _y, uint _ownerId){
    assert(ownersMap[msg.sender].id==_ownerId);
    _;
}
}
