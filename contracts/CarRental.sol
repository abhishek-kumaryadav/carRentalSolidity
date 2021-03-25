pragma solidity >=0.7.0 <0.8.0;
// SPDX-License-Identifier: MIT
contract CarRental{
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

    uint public countOwner=0;
    mapping(address => Owner) public ownersMap;
    address[] public owners;
    uint public countRenter=0;
    mapping(address => Renter) public rentersMap;
    address[] public renters;
    mapping(uint => Location[]) public locations;
    mapping(uint => Car[]) public cars;

function getOwnerSize()
public
returns (uint length)
{
    length=  owners.length;
}
function getRenterSize()
public
returns (uint length)
{
    length=  renters.length;
}
function getLocationSize(address add)
public
returns (uint length)
{
    if(ownersMap[add].locCount==locations[ownersMap[add].id].length)
    {
        return ownersMap[add].locCount;
    } 
    return 99;
}
function getFirstLocationId(address add)
public
returns (uint id)
{
    return locations[ownersMap[add].id][0].locid;    
}
function createOwner  (string memory _name)
public
isOwnerNot
    //check if owner alread present
    //check if renter present
returns (bool success)
{
    countOwner++;
    ownersMap[msg.sender].name=_name;
    ownersMap[msg.sender].id=countOwner;
    ownersMap[msg.sender].locCount=0;
    ownersMap[msg.sender].earnings=0;
    ownersMap[msg.sender].exists=true;
    owners.push(msg.sender);
    return true;
    
}
function createRenter(string memory _aadhar)
public
isRenterNot
returns (bool success)
{
    countRenter++;
    rentersMap[msg.sender].aadhar=_aadhar;
    rentersMap[msg.sender].balance=10000;   // No actual transaction is taking place and this balance is used to simulate transaction
    rentersMap[msg.sender].exists=true;
    renters.push(msg.sender);
    return true;
}

function addLocations(int  _x, int  _y)
public
isOwner(msg.sender)
// checkLocation(_x, _y) CHeck location x,y doesn't already exists
returns (bool success)
{
    ownersMap[msg.sender].locCount+=1;
    uint locationCount=ownersMap[msg.sender].locCount;
    Location memory temp;
    temp.x=_x;
    temp.y=_y;
    temp.locid=10*ownersMap[msg.sender].id+locationCount;
    temp.carCount=0;
    locations[ownersMap[msg.sender].id].push(temp);
    return true;
}
function addCars(string memory _id, string memory _model, uint _mileage, uint _locIndex)
public
isOwner(msg.sender)
locationExists(msg.sender,_locIndex)
    // check if location exists
    // Also add a check is car already exists
returns (bool success)
{
    locations[ownersMap[msg.sender].id][_locIndex].carCount++;
    uint ccount=locations[ownersMap[msg.sender].id][_locIndex].carCount;
    uint thisLocId=(locations[ownersMap[msg.sender].id][_locIndex]).locid;
    Car memory _temp;
    _temp.id=thisLocId*10+ccount;
    _temp.model=_model;
    _temp.mileage=_mileage;
    _temp.avail=0;
    _temp.startBlock=0;
    _temp.ttf=0;
    cars[(locations[ownersMap[msg.sender].id][_locIndex]).locid].push(_temp);
    return true;
}

function addJourney(uint _ownerId, uint _locIndex, uint _carIndex, uint _dst)
public
carExists(_ownerId, _locIndex, _carIndex)
isRenter
isCarFree(_ownerId, _locIndex, _carIndex)
returns (bool success)
{
    uint getToArray=_ownerId*10+_locIndex;
    cars[getToArray][_carIndex].startBlock=block.number;
    cars[getToArray][_carIndex].avail=1;
    cars[getToArray][_carIndex].ttf=_dst/10;
}
function completeJourney(uint _ownerId, uint _locIndex, uint _carIndex)  // Sent by Renter
public
// checkJourneyComplete(_ownerAddress,_ownerId, _locIndex, _carIndex)
{
    cars[locations[_ownerId][_locIndex].locid][_carIndex].avail=2;
    rentersMap[msg.sender].balance-=100;
}
function returnCar(uint _ownerId, uint _locIndex, uint _carIndex)
public
canReturn( _ownerId,  _locIndex, _carIndex)
{
    cars[locations[ownersMap[msg.sender].id][_locIndex].locid][_carIndex].avail=0;
    ownersMap[msg.sender].earnings+=100;
    
}



modifier isOwnerNot{
    assert(ownersMap[msg.sender].exists!=true);
    _;
}
modifier isRenterNot{
    assert(rentersMap[msg.sender].exists!=true);
    _;
}
modifier isOwner(address add){
    assert(ownersMap[add].exists==true);
    _;
}
modifier isRenter{
    assert(rentersMap[msg.sender].exists==true);
    _;
}
modifier locationExists(address add, uint _locIndex){
    assert(ownersMap[add].locCount>=_locIndex);
    _;
}
modifier ownerExists(uint _ownerId){
    assert(ownersMap[owners[_ownerId-1]].exists==true);
    _;
}
modifier carExists(uint _ownerId, uint _locIndex,uint _carIndex){
    assert(locations[_ownerId][_locIndex].carCount>=_carIndex);
    _;
}

modifier isCarFree( uint _ownerId, uint _locIndex, uint _carIndex){
    assert(cars[locations[_ownerId][_locIndex].locid][_carIndex].avail==0);
    _;
}
modifier canReturn(uint _ownerId, uint _locIndex, uint _carIndex){
    bool m1=cars[locations[ownersMap[msg.sender].id][_locIndex].locid][_carIndex].avail==2;
    bool m2=(block.number-cars[locations[ownersMap[msg.sender].id][_locIndex].locid][_carIndex].startBlock)>=block.number-cars[locations[ownersMap[msg.sender].id][_locIndex].locid][_carIndex].ttf;
    assert(m1||m2);
    _;
}
}
