 pragma solidity ^0.4.10;


//set owner 

contract Owned {
    address _owner;

    function Owned() {
        _owner = msg.sender;
    }

    modifier ownerOnly() {
        if (msg.sender == _owner)
            _;
    }

    function getOwner()  constant public returns (address ownerAddress) {
        ownerAddress = _owner;
    }

    function transferOwnership(address newOwner) ownerOnly {
        _owner = newOwner;
    }
}




//Do the stamp 


contract DocStamp is Owned {

    //set the structure of record 
    struct Record { 
        string UserName;
        uint timeStamp;
    }

    // sha256 => Record
    mapping(bytes32 => Record) _records;
    uint _recordCount;

    function DocStamp(uint initialPrice) {
        _recordCount = 0;
    }

    
    
    function getCount() constant ownerOnly returns (uint) {
        return _recordCount;
    }

    function stampDirect(string ownerUserName, string Doc) ownerOnly {
        bytes32 sha=sha256(Doc);

        require(!isRecorded(sha));
        
        Record memory rec = Record(ownerUserName, now);
        _records[sha] = rec;
        _recordCount = _recordCount + 1;
    }

  
    function isRecorded(bytes32 sha) constant returns (bool) {
        return _records[sha].timeStamp != 0;
    }
    
    function lookup(string Doc) constant returns(string, uint) {
        bytes32 sha=sha256(Doc);
        Record memory rec = _records[sha];
        return (rec.UserName, rec.timeStamp);
    }

   
}