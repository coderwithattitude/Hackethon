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
        address[] judges;
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
        if(_judges.length == _noJudges) hackathon.judges = _judges;



    }

}