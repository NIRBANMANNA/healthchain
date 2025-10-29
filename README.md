# healthchain
# 🏥 HealthChain - Secure Health Record Tracker on Blockchain

## 🧠 Project Description
**HealthChain** is a simple decentralized health record management system built using **Solidity**.  
It allows patients to securely store, update, and share their medical records on the **Ethereum blockchain**, ensuring transparency, security, and immutability.  

This project is beginner-friendly and serves as a great starting point for learning how to handle **access control**, **data privacy**, and **smart contract design** in Solidity.
<img width="1908" height="852" alt="Screenshot 2025-10-29 135403" src="https://github.com/user-attachments/assets/63613166-6990-4c82-ac89-868885974e8e" />



---

## ⚙️ What It Does
- Patients can **create** and **update** their personal health records.  
- Doctors can be **authorized** by the system owner to view or modify patient records.  
- Only the **patient** or an **authorized doctor** can access specific records.  
- Every record change is logged and traceable on the blockchain.  

---

## ✨ Features
✅ **Secure Data Access** — Only verified doctors and the patient can access or update records.  
✅ **Transparent Authorization** — Contract owner (admin) controls doctor permissions.  
✅ **Immutable Records** — All data stored on-chain is tamper-proof.  
✅ **Beginner-Friendly Solidity** — Clean, well-commented code for easy learning.  
✅ **Event Logging** — Emits events for record creation, updates, and doctor authorization.  

---

## 🔗 Deployed Smart Contract
**Ethereum Network (Testnet):** [View on Etherscan](XXX)

---

## 💻 Smart Contract Code
```solidity
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

