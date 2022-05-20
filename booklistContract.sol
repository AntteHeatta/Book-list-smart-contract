// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 <0.9.0;

contract booklistContract {

    //This smart contract application is used to save and fetch books.

    //The data structure for the items stored in the blockchain
    struct booklistStruct {
        uint bookId;        //Each book will have its own unique ID starting from 0
        string bookName;    //Name of the book set by the user (must be unique, duplicates not allowed)
        uint timestamp;     //Timestamp of book saved
    }

    //Mapping for user data
    mapping (address => booklistStruct[] ) myBookList;  //Locates the array of structs based on user's address
    mapping (address => uint) counter;                  //Connects uint value to an address

    //Get methods for retrieving data
    function getName(uint bookId) public view returns (string memory) {
        return myBookList[msg.sender][bookId].bookName;
    }
    function getTime (uint bookId) public view returns (uint) {
        return myBookList[msg.sender][bookId].timestamp;
    }
    function getTotal() public view returns (uint) {
        return counter[msg.sender];
    }

    //Funtion compares the hash values of given bookId and the bookId's in myBookList to prevent finding same bookId
    function checkIfBookExists(string memory _bookName) private view returns (bool) {
        for (uint i = 0; i < myBookList[msg.sender].length; i++) {
            if(keccak256(abi.encodePacked(_bookName)) == keccak256(abi.encodePacked(myBookList[msg.sender][i].bookName))) {
                return false;
            }
        }
        return true;
    }

    //Funtion to check if given bookId lenght is zero. 
    function checkBookIdLenght(string memory _bookName) private pure returns (bool) {
        bytes memory tempBookName = bytes(_bookName);
        if(tempBookName.length == 0) {
            return false;
        } else {
            return true;
        }
    }

    //Function for storing the books on the blockchain
    function addBook(string memory _bookName) public {
        if(checkIfBookExists(_bookName)) { //Checks for duplicates
            if(checkBookIdLenght(_bookName)) { //Checks that bookId lenght > 0
                counter[msg.sender]++;
                myBookList[msg.sender].push(booklistStruct(
                    counter[msg.sender],
                    _bookName,
                    block.timestamp
                ));
            }
        }
    }
}
