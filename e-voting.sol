/*** The Address Book

The Chairperson:    0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

Proposal names:     Alice, Betty, Cecilia, Dana
Proposal names:     Alice, Betty, Cecilia, Dana
(name, bytes32-encoded name, account)

Alice:              0x416c696365000000000000000000000000000000000000000000000000000000  0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2

Betty:              0x4265747479000000000000000000000000000000000000000000000000000000  0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

Cecilia:            0x436563696c696100000000000000000000000000000000000000000000000000  0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB

Dana:               0x44616e6100000000000000000000000000000000000000000000000000000000  0x617F2E2fD72FD9D5503197092aC168c91465E7f2

Contract input argument:
["0x416c696365000000000000000000000000000000000000000000000000000000","0x4265747479000000000000000000000000000000000000000000000000000000","0x436563696c696100000000000000000000000000000000000000000000000000","0x44616e6100000000000000000000000000000000000000000000000000000000"],["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB","0x617F2E2fD72FD9D5503197092aC168c91465E7f2"]
***/

// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

contract Voting_1 {
    //Structure for Voter
    struct Voter {
        uint256 weight; // No. of times vote can be given
        bool voted; // Vote given or not ie. TRUE or FALSE
        // address delegate; // Whom to give his votter rights
        uint256 vote; //Whom Vote is given by the voter
    }
    //For Party
    struct Proposal {
        bytes32 name; // Party Name
        uint256 voteCount; //Votes Given
    }
 
    uint start;
    uint stop;
    address public chairperson; //Head of Voting Authority

    //Address of Voter can be called with help of Voters
    mapping(address => Voter) public voters; // Key=>voters  Values=>Voter

    Proposal[] public proposals;
    address[] public voter_List;

    constructor(bytes32[] memory proposalNames, address[] memory voter_list) {
        chairperson = msg.sender; //Gives Address of Owner to chairperson
        voter_List = voter_list; //Puts the list of the address eligible for votes
        start = block.timestamp;
        stop= start+100;
        //Increase the weight of all the voters to 1
        for (uint256 i = 0; i < voter_List.length; i++) {
             voters[voter_List[i]].weight = 1;
        }

        //Put the Proposals in the proposal Array one by one
        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
            
        }
    }
    
    function timeleft() public  view returns(uint){
        return stop-block.timestamp;
    }

    function vote(uint256 proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Not in the Voter List"); //Check if he has the right to vote
        require(!sender.voted, "Already voted."); //Checks if the person has already voted or not
        require(block.timestamp < stop);
        sender.voted = true;
        sender.vote = proposal; //Stores the index no. of the person who got the vote
        sender.weight = sender.weight - 1; //After Voting Decrease the weight of the voter so that he can't vote twice
        proposals[proposal].voteCount += 1; //Increase the no. of vote of the candidates by 1
    }

    //Count the winner and returns the index of the person who won
    function winningProposal() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        for (uint256 p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    //Returns the name of the candidates who won
    function winnerName() external view returns (string memory) {
        bytes32 winnerName1 = proposals[winningProposal()].name;
        uint8 i = 0;
        while (i < 32 && winnerName1[i] != 0) {
            i++;
        }
        bytes memory winnerName_ = new bytes(i);
        for (i = 0; i < 32 && winnerName1[i] != 0; i++) {
            winnerName_[i] = winnerName1[i];
        }
        return string(winnerName_);
    }
}