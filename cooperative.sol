// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ResearchTeamRegistration {
    struct Member {
        string name;
        string role;
        string profile;
        bool isRegistered;
    }

    address public admin;
    mapping(address => Member) public members;
    address[] public memberAddresses;

    event MemberRegistered(address indexed memberAddress, string name, string role, string profile);
    event MemberUpdated(address indexed memberAddress, string name, string role, string profile);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender].isRegistered, "Only registered members can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerMember(address _memberAddress, string memory _name, string memory _role, string memory _profile) public onlyAdmin {
        require(!members[_memberAddress].isRegistered, "Member is already registered");

        members[_memberAddress] = Member({
            name: _name,
            role: _role,
            profile: _profile,
            isRegistered: true
        });

        memberAddresses.push(_memberAddress);
        emit MemberRegistered(_memberAddress, _name, _role, _profile);
    }

    function updateMemberDetails(string memory _name, string memory _role, string memory _profile) public onlyMember {
        Member storage member = members[msg.sender];

        member.name = _name;
        member.role = _role;
        member.profile = _profile;

        emit MemberUpdated(msg.sender, _name, _role, _profile);
    }

    function getMemberDetails(address _memberAddress) public view returns (string memory, string memory, string memory, bool) {
        Member memory member = members[_memberAddress];
        return (member.name, member.role, member.profile, member.isRegistered);
    }

    function getAllMembers() public view returns (address[] memory) {
        return memberAddresses;
    }
}
