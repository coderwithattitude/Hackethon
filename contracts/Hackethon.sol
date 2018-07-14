pragma solidity ^0.4.24;

import "../installed_contracts/zeppelin/contracts/math/SafeMath.sol";

contract Hackethon {
    using SafeMath for uint256;
    using SafeMath for uint64;

    struct HackathonStruct {
        address creator;
        uint64 startTime;
        uint64 endTime;
        uint256 noJudges;
        uint256 noParticipants;
        address[] participants;
        address[] judges;
        bool ended;
    }

    HackathonStruct[] hackathons;

    //mapping (address => HackathonStruct) hackathons;
    //mapping (address => address[]) judges;

    function newHackthon(uint _endTime, uint256 _noJudges, address[] _judges) public returns(uint256 hackathonId){
        hackathonId = hackathons.length++;
        HackathonStruct storage hackathon = hackathons[hackathonId];
        hackathon.creator = msg.sender;
        hackathon.startTime = uint64(now);
        hackathon.endTime = uint64(_endTime);
        hackathon.noJudges = _noJudges;
        hackathon.ended = false;
        if(_judges.length == _noJudges) hackathon.judges = _judges;



    }

    function joinHackathon(uint256 _hackathonID) public hackathonEnded(_hackathonID) returns(bool joined){
        uint256 participantsID = hackathons[_hackathonID].participants.length++;
        require(participantsID < hackathons[_hackathonID].noParticipants, "number of participants exceeded");
        hackathons[_hackathonID].participants[participantsID] = msg.sender;
        joined = true;
    }

    function endHackathon(uint256 _hackathonID) public onlyHackathonCreator(_hackathonID) hackathonEnded(_hackathonID) returns(bool _ended){
        _ended = hackathons[_hackathonID].ended = true;
    }

    modifier hackathonEnded(uint256 _hackathonID) {
        require(hackathons[_hackathonID].ended, "hackathon has ended");
        _;
    }

    modifier onlyHackathonCreator(uint256 hackathonID) {
        require(msg.sender == hackathons[hackathonID].creator);
        _;
    }

    

}