/*** The Address Book

The chairperson:    0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

Proposal names:     Priya, Khushi, Harshit, Vikram
Proposal names:     Priya, Khushi, Harshit, Vikram
(name, bytes32-encoded name, account)

Priya:              0x5072697961000000000000000000000000000000000000000000000000000000  0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2

Khushi:             0x4b68757368690000000000000000000000000000000000000000000000000000  0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

Harshit:            0x4861727368697400000000000000000000000000000000000000000000000000  0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB

Vikram:             0x56696b72616d0000000000000000000000000000000000000000000000000000  0x617F2E2fD72FD9D5503197092aC168c91465E7f2

Contract input argument:
["0x5072697961000000000000000000000000000000000000000000000000000000","0x4b68757368690000000000000000000000000000000000000000000000000000","0x4861727368697400000000000000000000000000000000000000000000000000","0x56696b72616d0000000000000000000000000000000000000000000000000000"],["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB","0x617F2E2fD72FD9D5503197092aC168c91465E7f2"]
***/

// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;
    //title Voting_1
contract Voting_1 {

    //Structure for Voter
    struct Voter {
        uint256 weight; // No. of times vote can be given
        bool voted;   // if true, that person already voted
        uint256 vote; //Whom Vote is given by the voter
    }
    //For Party
    struct Proposal {
        bytes32 name; // Party Name
        uint256 voteCount; // number of accumulated votes
        
    }
 
    uint start;  //start timing of voting
    uint stop;   //end timing of voting
    address public chairperson; //Head of Voting Authority

    //Address of Voter can be called with help of Voters
    mapping(address => Voter) public voters; // Key=>voters  Values=>Voter

    Proposal[] public proposals;
    address[] public voter_List;
    
    /** 
     Create a new ballot to choose one of 'proposalNames'.
     proposalNames names of proposals
     */
    constructor(bytes32[] memory proposalNames, address[] memory voter_list) {
        chairperson = msg.sender; //Gives Address of Owner to chairperson
        voter_List = voter_list; //Puts the list of the address eligible for votes
        
        //Increase the weight of all the voters to 1
        for (uint256 i = 0; i < voter_List.length; i++) {
             voters[voter_List[i]].weight = 1;
        }

        //Put the Proposals in the proposal Array one by one
        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
            
        }
        start = block.timestamp; //ensure that all votes being cast within the specified duration
        stop= start+200;        //endTime is set to 200 seconds after the voting process starts
        //stop_Vote = stop + 200;
    }

    
 function nomination(bytes32 proposalNames) external { 
 require(msg.sender == chairperson,"You are not the chairperson"); 
 require(block.timestamp < stop,"Nomination Closed after time end"); 
 proposals.push(Proposal({name: proposalNames, voteCount: 0})); 
 } 

    
    function timeleft() public  view returns(uint){
        return stop-block.timestamp;
    }


 struct Candidate {
        string candidate_name;
    
        string candidate_description;
        uint8 voteCount;
        string email;
    }

    //candidate mapping

    mapping(uint8=>Candidate) public candidates;

    //voter election_description

    

    //counter of number of candidates

    uint8 numCandidates;

    //counter of number of voters

    uint8 numVoters;

    //function to add candidate to mapping

    function AddCandidate(string memory candidate_name, string memory candidate_description,string memory email) public  {
        uint8 candidateID = numCandidates++; //assign id of the candidate
        candidates[candidateID] = Candidate(candidate_name,candidate_description,0,email); //add the values to the mapping
    }


    function vote(uint256 proposal) external {
        Voter storage sender = voters[msg.sender];
        require(
            //Check if he has the right to vote
            sender.weight != 0,
             "Not in the Voter List"
             ); 
        require(
            //Checks if the person has already voted or not
            !sender.voted,
             "Already voted."
             );
             
        require(
            //set time limit
            block.timestamp < stop
            );
            
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

    /*Calls winningProposal() function to get the index of the winner contained in the proposals array and then
     return winnerName_ the name of the winner*/
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




     function IndianParty(int Priya , int Khushi , int Harshit ) pure public returns (int) {
        int Mysum = Priya + Khushi + Harshit;
        return Mysum;
     }
     function IndianParty() public view returns (uint PriyaVotes, uint KhushiVotes, uint HarshitVotes) {
    for (uint i = 0; i < proposals.length; i++) {
        if (proposals[i].name == "Priya") {
            PriyaVotes = proposals[i].voteCount;
        } else if (proposals[i].name == "Khushi") {
            KhushiVotes = proposals[i].voteCount;
        } else if (proposals[i].name == "Harshit") {
            HarshitVotes = proposals[i].voteCount;
        }
    }
    
}
}
