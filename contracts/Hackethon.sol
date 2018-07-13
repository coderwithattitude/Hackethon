pragma solidity ^0.4.24;

import "../installed_contracts/zeppelin/contracts/math/SafeMath.sol";

contract Hackethon {
    using SafeMath for uint256;
    using SafeMath for uint64;

    struct HackathonStruct {
        address creator;
        uint64 startDate;
        uint64 endDate;
        uint256 noJudges;
    }

    HackathonStruct[] hackathons;

    //mapping (address => HackathonStruct) hackathons;
    mapping (address => address[]) judges;



}