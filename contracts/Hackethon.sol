pragma solidity ^0.4.24;

import "../installed_contracts/zeppelin/contracts/math/SafeMath.sol";

contract Hackethon {
    using SafeMath for uint256;
    using SafeMath for uint64;

    struct Hackathon {
        string name;
        address creator;
        uint64 startTime;
        uint64 endTime;
        uint256 maxParticipants;
        address[] participants;
        address[] judges;
        mapping(address => bool) voted;
        mapping(address => Submission) submissions;
        bool ended;
    }

    struct Submission {
        bytes32 submission;
        uint vote;
    }

    Hackathon[] hackathons;

    function newHackthon(
        string _name,
        uint _endTime, 
        address[] _judges,
        address[] _participants,
        uint _maxParticipants) 
        public
        returns(uint256 hackathonId){
            
        hackathons.push(Hackathon({
            name : _name,
            creator : msg.sender,
            startTime : uint64(now),
            endTime : uint64(_endTime),
            maxParticipants : _maxParticipants,
            judges : _judges,
            ended : false,
            participants : _participants
        }));
        hackathonId = hackathons.length - 1;


    }

    function joinHackathon(uint256 _hackathonID) 
        public 
        hackathonEnded(_hackathonID) 
        hasJoined(_hackathonID) 
        returns(bool joined){
        uint256 participantsID = hackathons[_hackathonID].participants.length++;
        require(participantsID < hackathons[_hackathonID].maxParticipants, "number of participants exceeded");
        hackathons[_hackathonID].participants[participantsID] = msg.sender;
        joined = true;
    }

    function endHackathon(uint256 _hackathonID) 
        public 
        onlyHackathonCreator(_hackathonID) 
        hackathonEnded(_hackathonID) 
        returns(bool _ended){
        _ended = hackathons[_hackathonID].ended = true;
    }

    function submitEntry(
        uint256 _hackathonID, 
        bytes32 _submissionUrl) 
        public 
        hasJoined(_hackathonID) 
        hackathonEnded(_hackathonID) 
        returns (bool submitted) {
        hackathons[_hackathonID].submissions[msg.sender].submission = _submissionUrl;
        submitted = true;
    }

    function updateJudges(uint256 _hackathonID,address newJudge, uint256 oldJudgeID) 
        public 
        onlyHackathonCreator(_hackathonID) 
        hackathonEnded(_hackathonID) {
        hackathons[_hackathonID].judges[oldJudgeID] = newJudge;
    }

    function getHackathonInfo(uint256 _hackathonID) 
        public
        view 
        returns(
        address _creator, 
        uint64 _startTime,
        uint64 _endTIme,
        bool _ended
        ){
        _creator = hackathons[_hackathonID].creator;
        _startTime = hackathons[_hackathonID].startTime;
        _endTIme = hackathons[_hackathonID].endTime;
        _ended = hackathons[_hackathonID].ended;
    }

    function getJudges(uint256 _hackathonID) public view returns(address[] _judges){
        require(hackathons[_hackathonID].judges.length != 0);
        _judges = hackathons[_hackathonID].judges;
    }

    function getParticipants(uint256 _hackathonID) public view returns(address[] _participants){
        require(hackathons[_hackathonID].participants.length != 0); 
        _participants = hackathons[_hackathonID].participants; 
    }
    //
    function vote(uint256 _hackathonID, address participant) public {
        uint judgeID = getJudgeID(msg.sender, _hackathonID);
        require(judgeID != 0);
        require(!hackathons[_hackathonID].voted[msg.sender]);
        hackathons[_hackathonID].submissions[participant].vote += 1;
        hackathons[_hackathonID].voted[msg.sender] = true;
    }

    function getWinner(uint _hackathonID) public checkVotes(_hackathonID){
        
    }

    function getJudgeID(address _judge, uint256 _hackathonID) internal view returns (uint) {
        for(uint i = 0; i <= hackathons[_hackathonID].judges.length; i++) {
            if(_judge == hackathons[_hackathonID].judges[i]) return i;
            break;
        }
        return 0;
    }

    modifier hackathonEnded(uint256 _hackathonID) {
        require(hackathons[_hackathonID].ended, "hackathon has ended");
        _;
    }

    modifier onlyHackathonCreator(uint256 _hackathonID) {
        require(msg.sender == hackathons[_hackathonID].creator);
        _;
    }

    modifier hasJoined(uint256 _hackathonID) {
        for(uint i = 0;i < hackathons[_hackathonID].participants.length;i++) {
            require(hackathons[_hackathonID].participants[i] == msg.sender, "already joined hackathon");
        }
        _;
    }

    modifier checkVotes(uint _hackathonID) {
        for (uint i = 0; i <= hackathons[_hackathonID].judges.length;i++) {
            address judgeAddress = hackathons[_hackathonID].judges[i];
            if (!hackathons[_hackathonID].voted[judgeAddress])  return;
        }
        _;
    }

}