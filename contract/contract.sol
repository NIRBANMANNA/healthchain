// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthChain {

    // The contract owner (e.g., hospital admin)
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Struct to represent a patient's health record
    struct HealthRecord {
        string name;
        uint age;
        string diagnosis;
        string treatment;
        address patientAddress;
    }

    // Mapping from patient address to their health record
    mapping(address => HealthRecord) private records;

    // Mapping to allow doctors (or admins) to access records
    mapping(address => bool) public authorizedDoctors;

    // Events for transparency
    event RecordAdded(address patient);
    event RecordUpdated(address patient);
    event DoctorAuthorized(address doctor);

    // Modifier to restrict certain functions to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    // Modifier to allow only authorized doctors or the patient
    modifier onlyAuthorized(address _patient) {
        require(
            msg.sender == _patient || authorizedDoctors[msg.sender],
            "Not authorized"
        );
        _;
    }

    // Add a doctor (only the owner can do this)
    function authorizeDoctor(address _doctor) public onlyOwner {
        authorizedDoctors[_doctor] = true;
        emit DoctorAuthorized(_doctor);
    }

    // Patients can add their own record
    function addRecord(
        string memory _name,
        uint _age,
        string memory _diagnosis,
        string memory _treatment
    ) public {
        HealthRecord memory newRecord = HealthRecord(
            _name,
            _age,
            _diagnosis,
            _treatment,
            msg.sender
        );
        records[msg.sender] = newRecord;
        emit RecordAdded(msg.sender);
    }

    // Patients or doctors can update an existing record
    function updateRecord(
        address _patient,
        string memory _diagnosis,
        string memory _treatment
    ) public onlyAuthorized(_patient) {
        HealthRecord storage record = records[_patient];
        record.diagnosis = _diagnosis;
        record.treatment = _treatment;
        emit RecordUpdated(_patient);
    }

    // View a record (only the patient or authorized doctor can view)
    function viewRecord(address _patient)
        public
        view
        onlyAuthorized(_patient)
        returns (string memory, uint, string memory, string memory)
    {
        HealthRecord memory record = records[_patient];
        return (
            record.name,
            record.age,
            record.diagnosis,
            record.treatment
        );
    }
}
