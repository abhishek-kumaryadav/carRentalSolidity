pragma solidity >=0.7.0 <0.8.0;
// SPDX-License-Identifier: MIT
contract carRental{
struct Car{
    uint id;
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
alreadyPresentOwner
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
alreadyPresentRenter
returns (bool success)
{
    countRenter++;
    rentersMap[msg.sender].aadhar=_aadhar;
    rentersMap[msg.sender].balance=10000;
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
    locations[ownersMap[msg.sender].id][_locIndex].carCount++;
    uint ccount=locations[ownersMap[msg.sender].id][_locIndex].carCount;
    cars[(locations[ownersMap[msg.sender].id][_locIndex]).locid].push(Car({
        id:_locid*10+ccount,
        model:_model,
        mileage:_mileage,
        avail:0,
        startBlock:0,
        ttf:0
    }));
    return true;
}

function addJourney(address _ownerAddress, uint _ownerId, uint _locIndex, uint _carIndex, uint _dst)
public
alreadRunning( _ownerAddress,_ownerId, _locIndex, _carIndex)
returns (bool success)
{
    cars[(locations[_ownerId][_locIndex].locid)][_carIndex].startBlock=block.number;
    cars[locations[_ownerId][_locIndex].locid][_carIndex].avail=1;
    cars[locations[_ownerId][_locIndex].locid][_carIndex].ttf=_dst/10;
}
function completeJourney( address _ownerAddress,uint _ownerId, uint _locIndex, uint _carIndex)  // Sent by Renter
public
checkJourneyComplete(_ownerAddress,_ownerId, _locIndex, _carIndex)
{
    cars[locations[_ownerId][_locIndex].locid][_carIndex].avail=2;  
}
function returnCar(uint _ownerId, uint _locIndex, uint _carIndex)
public
checkReturn( _ownerId,  _locIndex, _carIndex)
{
    cars[locations[ownersMap[msg.sender].id][_locIndex].locid][_carIndex].avail=0;
}
modifier alreadyPresentOwner{
    assert(ownersMap[msg.sender].exists!=true);
    _;
}
modifier alreadyPresentRenter{
    assert(rentersMap[msg.sender].exists!=true);
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
modifier alreadRunning( address _ownerAddress,uint _ownerId, uint _locIndex, uint _carIndex){
    assert(ownersMap[_ownerAddress].id==_ownerId);
    assert(ownersMap[_ownerAddress].locCount>=_locIndex);
    assert(locations[ownersMap[_ownerAddress].id][_locIndex].carCount>=_carIndex);
    assert(rentersMap[msg.sender].exists==true);
    assert(cars[locations[ownersMap[_ownerAddress].id][_locIndex].locid][_carIndex].avail==0);
    _;
}
modifier checkJourneyComplete( address _ownerAddress,uint _ownerId, uint _locIndex, uint _carIndex){
    assert(ownersMap[_ownerAddress].id==_ownerId);
    assert(ownersMap[_ownerAddress].locCount>=_locIndex);
    assert(locations[ownersMap[_ownerAddress].id][_locIndex].carCount>=_carIndex);
    assert(rentersMap[msg.sender].exists==true);
    assert(cars[locations[ownersMap[_ownerAddress].id][_locIndex].locid][_carIndex].avail==1);
    _;
}
modifier checkReturn(uint _ownerId, uint _locIndex, uint _carIndex){
    uint stBlock=cars[locations[ownersMap[msg.sender].id][_locIndex].locid][_carIndex].startBlock;
    uint timeTF=cars[locations[ownersMap[msg.sender].id][_locIndex].locid][_carIndex].ttf;
    assert(cars[locations[ownersMap[msg.sender].id][_locIndex].locid][_carIndex].avail==2);
    assert(stBlock+timeTF<=block.number);
    _;
}
}
