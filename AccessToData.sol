pragma solidity ^0.4.10;



//this code aims to let owners to control access to their database using freeze/defreezed option 

//this first contract choose an administrator of the system 


contract Administrator {
address public Admin;
	
	function Administrator(){
		Admin=msg.sender;
	}

	modifier onlyAdmin { 
		require(msg.sender==Admin); 
		_; 
	}
	
	function ChangeAdmin(address newAdmin) onlyAdmin {
		Admin=newAdmin;
	}

}


//main contract 
contract AccessControl is Administrator{
 
 mapping (address => bool) public AddressStates;
 
 mapping (address => mapping (address => bool)) public HasAccess;


//Intializing function
	function AccessControl() public{
		AddressStates[msg.sender]=true;
		HasAccess[msg.sender][msg.sender]=true;
	}


 //this create public event on the blockchain to notify clients 

 event _changeAccess(address indexed Owner, address indexed User,bool WhetherAccess);
 event _changeAccountState(address indexed Account,bool Frozen);//True=Frozen , falsoe=unfrozen 

//modifier , only unforzen account can change accesses

	modifier OnlyUnfrozen { 
		require(AddressStates[msg.sender] == false); 
		_; 
	}


//change state of account 
	function SetStates(address AddressToSet,bool Value) public onlyAdmin{
		AddressStates[AddressToSet]=Value;
		_changeAccountState(AddressToSet, Value);
	}


	function GetSender() public returns(address MsgSender) {
		return msg.sender;
	}

//change access to certain account 
	function controlAccess(address User,bool WhetherAccess) public OnlyUnfrozen{
		HasAccess[msg.sender][User]=WhetherAccess;
		_changeAccess(msg.sender,User,WhetherAccess);
	}


}