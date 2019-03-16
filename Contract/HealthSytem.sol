pragma solidity >=0.4.22 <0.6.0;  //means you can compile this code with any version from 0.4 upwards to

        //Milestone 1
//Data structure : Person, ePrescription, medicalHistory, laboratory
//registerNewPatient
//updatePatientMedicalRecord
//updateMedicalPickup
//updateEprescription
//updateMedicalRecord
//signDonorForm

        //Milestone 2
//new data structure : actions
//allows the pharmacist to confirm prescription delivery.
//allow the patient to request examinations, immunity, and vaccination.
//allow the physician to initiate a refill e-prescription for the patient.
//notify the patient with the refill medication due date.
//allow the physician to request examinations.
//allow the physician to initiate a sick-leave form for the patient.

        //Milestone 3
//new array data types for each data structure, to be used as local storage for looping and searching.
//allow the physician to view the patient medical record.
//allows the pharmacist to view prescribed prescriptions.
//allow the patient to view prescribed e-prescription history.
//allow the patient to view his medical examinations results.
//allow the patient to view his medical records and history.
//allow the physician to share patient cases with the other physicians.

        //Milestone 3
//allow the patient to request medication refill. - done
//allow the patient to request a donation of blood donation, organs donation and after death donation.
//allow the patient to print medical declarations.
//allow the physician to share patient cases with the other physicians.
//allow the physician to initiate an E-Prescription for patients.

        //Milestone 4
//Designated three users with their own addresses
//allow the patient to request medication refill. - done
//allow the patient to request a donation of blood donation, organs donation and after death donation.
//allow the patient to print medical declarations.
//allow the physician to share patient cases with the other physicians.
//allow the physician to initiate an E-Prescription for patients.

//This is basically a master class (blockchain has two different types of classes)
contract HealthSystem {

//This is semi minor class, which is blockchain data structure that gets stored on the blockchain.  It is also very simular to a class structure.  We are using this to construct
//our databases fields you specified. 
    struct Person {
        uint NID;
        bytes32 name;
        uint gender;
        uint DOB;
        uint age;
        bytes32 city;
        bytes32 socialStatus;
        uint careerStatus;
        bool sharedMedicationPickup;
        bool signedDonator;
        bytes32 notes;
    }
    
    struct ePrescription {
        uint NID;
        uint prescriptionID;
        bytes32 prescriptionName;
        uint prescriptionDate;
        bytes32 prescriptionDescription;
        uint PrescriptionRefillDate;
        bytes32 drugName;
        uint pharmacistID;
        uint PrescriptionLastPickup;
    }
    
    struct medicalHistory {
        uint NID;
        uint operationsID;
        bytes32 operationsName;
        uint operationsDate;
        bytes32 operationsDescription;
    }
    
    struct laboratory {
        uint NID;
        uint laboratoryID;
        bytes32 laboratoryName;
        uint testDate;
        bytes32 testDescription;
        uint requestID;
        
    }
    
    struct action { //This data strucure will be used as a management database which we can initiate particular actions.
        uint NID;
        bool sickLeave;
        bool reniewMedication;
        bool updatePatient;
        bool donationForm;
        bool newPatient;
        bool deletePatient;
        bool shareData;
        bool viewData;
        bool requestExamination; 
        bool prescriptionRefill;
        bool bloodDonator;
        bool organDonator;       
    }



    //this is a non-traversable data structure which looks kind of like an array, but one you cannot search.  You can only update.  We are creating objects of the above 
    //minor classes and placing them within the below data structure, for each entry (so there may be 300 entries in the person mapping, representing 300 data rows.)
    mapping(address => Person) persons;
    Person[] personsArray;

    mapping(address => ePrescription) ePrescriptions; 
    ePrescription[] ePrescriptionsArray;

    mapping(address => medicalHistory) medicalHistorys; 
    medicalHistory[] medicalHistorysArray;

    mapping(address => laboratory) laboratorys; 
    laboratory[] laboratorysArray;

    mapping(address => action) actions; 
    action[] actionsArray;
    //blockchain specific data type.  Its a wallet address.
    address payable server; //Owner of contract
    address payable patientAccount;
    address payable physicianAccount;
    address payable pharmacist;


    //These are events which will pop up in system processes, to help coders like us debug and see the outputs.
    event newPatient(address blockchainID_, uint time); 
    event patientUpdated(address blockchainID_, uint time);
    event MedicalPickup(address blockchainID_, uint time);
    event DonationForm(address blockchainID_, uint time);
    event prescriptionUpdated(address blockchainID_, uint time);
    event medicalHistoryUpdate(address blockchainID_, uint time);
    
    constructor() public {
        server = msg.sender; //creates a global of the contract creator etherium address
        patientAccount = 0x684f64e6b16f48bff4c017d5eb68793d7e181e85; 
        physicianAccount = 0x684f64e6b16f48bff4c017d5eb68793d7e181e85;
        pharmacist = 0x684f64e6b16f48bff4c017d5eb68793d7e181e85;
    }
    
    
    //New patient register
    function registerNewPatient(uint NID_, bytes32 name_, uint gender_, uint DOB_, uint age_, bytes32 city_, bytes32 socialStatus_, uint careerStatus_) //data inputs
        public payable returns (address) { //data outputs
        
        require (msg.sender == server); //security - only run function of you are the contract owner (meaning a staff member for us).
        
        //This is creating new blank entries in the blockchain mapping, preparing for use and update when we need it.  As you can see, I am using the blockchainID_ as 
        //the master key within the database to inform the software what row to update.  This will be updated to reflect NID once the search functions are implimented.

        //To interact with these from a front end position, you only need to call the desiered function, giving the input you require, and capturing the output.  The output
        //of these functions will be alot, allowing you full flexability to choose what data to place / not place in front of the user.

        address blockchainID_ = msg.sender;
        persons[blockchainID_].NID = NID_; //This is simply applying the input NID_ to the object persons, where the blockchainID_ is the owner.  As stated, this will be changed to NID.
        persons[blockchainID_].name = name_;
        persons[blockchainID_].gender = gender_;
        persons[blockchainID_].DOB = DOB_;
        persons[blockchainID_].age = age_;
        persons[blockchainID_].city = city_;
        persons[blockchainID_].socialStatus = socialStatus_;
        persons[blockchainID_].careerStatus = careerStatus_;
        persons[blockchainID_].signedDonator = false;
        persons[blockchainID_].sharedMedicationPickup = false;
        persons[blockchainID_].notes = "";

        ePrescriptions[blockchainID_].NID = NID_;
        ePrescriptions[blockchainID_].prescriptionID = 0;
        ePrescriptions[blockchainID_].prescriptionName = "";
        ePrescriptions[blockchainID_].prescriptionDate = 0;
        ePrescriptions[blockchainID_].prescriptionDescription = 0;
        ePrescriptions[blockchainID_].PrescriptionRefillDate = 0;
        ePrescriptions[blockchainID_].drugName = 0;
        ePrescriptions[blockchainID_].pharmacistID = 0;
        ePrescriptions[blockchainID_].PrescriptionLastPickup = 0;
   
        medicalHistorys[blockchainID_].NID = NID_;
        medicalHistorys[blockchainID_].operationsID = 0;
        medicalHistorys[blockchainID_].operationsName = 0;
        medicalHistorys[blockchainID_].operationsDate = 0;
        medicalHistorys[blockchainID_].operationsDescription = 0;
        
        laboratorys[blockchainID_].NID = NID_;
        laboratorys[blockchainID_].laboratoryID = 0;
        laboratorys[blockchainID_].laboratoryName = 0;
        laboratorys[blockchainID_].testDate = 0;
        laboratorys[blockchainID_].testDescription = "";

        actions[blockchainID_].NID = NID_;
        actions[blockchainID_].sickLeave = false;
        actions[blockchainID_].reniewMedication = false;
        actions[blockchainID_].updatePatient = false;
        actions[blockchainID_].donationForm = false;
        actions[blockchainID_].newPatient = false;
        actions[blockchainID_].deletePatient = false;
        actions[blockchainID_].shareData = false;
        actions[blockchainID_].viewData = false;
        actions[blockchainID_].requestExamination = false;
        actions[blockchainID_].prescriptionRefill = false;
        actions[blockchainID_].bloodDonator = false;
        actions[blockchainID_].organDonator = false;

        emit newPatient(blockchainID_, now); //causing the above defined event to emit
        return blockchainID_;
        
    }    
    
    //System should allow the Physician to update patient medical record.
    function updatePatientMedicalRecord(uint NID_, bytes32 name_, uint gender_, uint DOB_, uint age_, bytes32 city_, bytes32 socialStatus_, uint careerStatus_, bytes32 notes_)
        public payable returns (address) { //public means this an outfacing function that can be queried.  Payable means it is allowed to change the state of the blochain,
                                            //therefore costs gas to run.  These outfacing functions and payable statues will change as the software develops, they are 
                                            //public just for testing at the moment.
            
        require (msg.sender == server);
            
        address blockchainID_ = msg.sender;
        persons[blockchainID_].NID = NID_;
        persons[blockchainID_].name = name_;
        persons[blockchainID_].gender = gender_;
        persons[blockchainID_].DOB = DOB_;
        persons[blockchainID_].age = age_;
        persons[blockchainID_].city = city_;
        persons[blockchainID_].socialStatus = socialStatus_;
        persons[blockchainID_].careerStatus = careerStatus_;
        persons[blockchainID_].notes = notes_; // used for patients to note make requests for examinations
        emit patientUpdated(blockchainID_, now);
        return blockchainID_;

    }
    
    // Patient to allow authorisation for relitives to recieve medication via the e-prescription system.
    function updateMedicalPickup(uint NID_, bool sharedMedicationPickup_) public payable returns (address) {
        require (msg.sender == server);
        
        address blockchainID_ = msg.sender;
        persons[blockchainID_].sharedMedicationPickup = true;
        emit MedicalPickup(blockchainID_, now);
        return blockchainID_;
    }
    
    //Update / reniew e-prescription record
    function updateEprescription(uint NID, uint prescriptionID, bytes32 prescriptionDescription_, uint PrescriptionRefillDate_, uint pharmacistID_) public payable returns (address) {
        require (msg.sender == server);
        
        address blockchainID_ = msg.sender;
        
        ePrescriptions[blockchainID_].prescriptionDescription = prescriptionDescription_;
        ePrescriptions[blockchainID_].PrescriptionRefillDate = PrescriptionRefillDate_;
        ePrescriptions[blockchainID_].pharmacistID = pharmacistID_;
        
        emit prescriptionUpdated(blockchainID_, now);
        return blockchainID_;
    }
    //Physician to update medical record
    function updateMedicalRecord(uint NID_, uint operationsID_, bytes32 operationsName_, uint operationsDate_, bytes32 operationsDescription_) public payable returns (address) {
        require (msg.sender == server);
        
        address blockchainID_ = msg.sender;
        
        medicalHistorys[blockchainID_].operationsID = operationsID_;
        medicalHistorys[blockchainID_].operationsName = operationsName_;
        medicalHistorys[blockchainID_].operationsDate = operationsDate_;
        medicalHistorys[blockchainID_].operationsDescription = operationsDescription_;
        
        emit medicalHistoryUpdate(blockchainID_, now);
        return blockchainID_;
    }
    //signDonorForm
    function signDonorForm(uint NID_) public payable returns (address) {
        require (msg.sender == server);
        address blockchainID_ = msg.sender;
        
        persons[blockchainID_].signedDonator = true;
    }

    //pharmacist to confirm prescription delivery.
    function confirmPrescriptionDelivery(uint NID_,uint prescriptionID) public payable returns (address) {
        require (msg.sender == server);
        address blockchainID_ = msg.sender;

        ePrescriptions[blockchainID_].PrescriptionLastPickup = now; //updates the medication pickup time / date to cuirrent time /date.
    }

    //patient to request examinations, immunity, and vaccination
    function patientRequestExamination(uint NID_, bytes32 notes_) public payable returns (address) {
        require (msg.sender == server);
        address blockchainID_ = msg.sender;

        persons[blockchainID_].notes = notes_; //This is where a patient will have their examamination requests placed
    }

    //notify the patient with the refill medication due date.
    function refillEprescription(uint NID_, uint prescriptionID) public payable returns (address) {
        uint time = 604800 * 3; //three weeks in value of seconds.  This code assumes a person gets 4 weeks supply of medication.
        address blockchainID_ = msg.sender;

        if (ePrescriptions[blockchainID_].PrescriptionRefillDate < now + time) { //if the date last prescription is more than 3 weeks ago 
            if (ePrescriptions[blockchainID_].PrescriptionLastPickup < now) { //If the last prescription was actually picked up
                 if(ePrescriptions[blockchainID_].PrescriptionLastPickup < now + time) { //if pickup of prescription was more than 3 weeks ago
                    ePrescriptions[blockchainID_].prescriptionDate = now; // updates prescription date to today
                    ePrescriptions[blockchainID_].PrescriptionRefillDate = now + time; //updates refil date to 1 month ahead
                    notifyPatientRefill(NID_,prescriptionID); //call the below notify patient funciton
                    }    
            }
        }
    }

    //notify the patient with the refill medication due date.
    function notifyPatientRefill(uint NID_, uint prescriptionID) private returns (uint, bytes32, uint,uint,uint,bytes32,uint,bytes32,uint, uint,bytes32,uint) {
        address blockchainID_ = msg.sender; //Note this is a private function.  It means it does is not accessable outside the contract and does not change any states.
        return (
        persons[blockchainID_].NID, //uint
        persons[blockchainID_].name, //bytes32
        persons[blockchainID_].gender, //uint
        persons[blockchainID_].DOB, //uint
        persons[blockchainID_].age, //uint
        persons[blockchainID_].city, //bytes32
        ePrescriptions[blockchainID_].prescriptionID, //uint
        ePrescriptions[blockchainID_].prescriptionName, //bytes32
        ePrescriptions[blockchainID_].prescriptionDate, //uint
        ePrescriptions[blockchainID_].PrescriptionRefillDate, //uint
        ePrescriptions[blockchainID_].drugName, //bytes32
        ePrescriptions[blockchainID_].PrescriptionLastPickup); //uint
    }
    
    //allow the physician to request examinations.
    function physicianRequestExamination(uint NID_,uint operationsID_, uint operationsDate_, bytes32 operationsDescription_) public payable returns (address) {
        require (msg.sender == server);
        address blockchainID_ = msg.sender;
        medicalHistorys[blockchainID_].NID = NID_;
        medicalHistorys[blockchainID_].operationsID = operationsID_;
        medicalHistorys[blockchainID_].operationsName = 0;
        medicalHistorys[blockchainID_].operationsDate = operationsDate_;
        medicalHistorys[blockchainID_].operationsDescription = operationsDescription_;
    }

    //allow the physician to initiate a sick-leave form for the patient.
    function initiateSickleave(uint NID_) public payable returns (address, bool) {
        require (msg.sender == server);
        address blockchainID_ = msg.sender;
        actions[blockchainID_].sickLeave = true;

        return (blockchainID_, actions[blockchainID_].sickLeave);

    }

    //allow the patient to view his medical records and history.
    function patientMedicalHistory(uint NID_) public payable returns (uint, uint, bytes32, uint, bytes32) {
        require (msg.sender == server);
        address blockchainID_ = msg.sender;
        for (uint p = 0; p < medicalHistorysArray.length; p++) { //Look through memory array for patient with inputted NID and then return the record
            if (medicalHistorysArray[p].NID == NID_) {
            
            return (medicalHistorysArray[p].NID,
                medicalHistorysArray[p].operationsID,
                medicalHistorysArray[p].operationsName,
                medicalHistorysArray[p].operationsDate,
                medicalHistorysArray[p].operationsDescription);
            }

        }
    }

    //allow the patient to view his medical examinations results.
    function patientExamResults(uint NID_) public payable returns (uint,uint,bytes32,uint,bytes32,uint) {
        require (msg.sender == server);
        address blockchainID_ = msg.sender;
        for (uint p = 0; p < laboratorysArray.length; p++) { //Look through memory array for patient with inputted NID and then return the record
            if (laboratorysArray[p].NID == NID_) {

                return (laboratorysArray[p].NID,
                laboratorysArray[p].laboratoryID,
                laboratorysArray[p].laboratoryName,
                laboratorysArray[p].testDate,
                laboratorysArray[p].testDescription,
                laboratorysArray[p].requestID);
            }

        }

    }

    //allow the patient to view prescribed e-prescription history.
    function patienteEprescriptionHistory(uint NID_) public payable returns (uint,uint,uint,bytes32,uint,bytes32,uint,uint) {
        require (msg.sender == server);
        address blockchainID_ = msg.sender;
        for (uint p = 0; p < ePrescriptionsArray.length; p++) { //Look through memory array for patient with inputted NID and then return the record
            if (ePrescriptionsArray[p].NID == NID_) {

                return (ePrescriptionsArray[p].NID,
                ePrescriptionsArray[p].prescriptionID,
                ePrescriptionsArray[p].prescriptionDate,
                ePrescriptionsArray[p].prescriptionDescription,
                ePrescriptionsArray[p].PrescriptionRefillDate,
                ePrescriptionsArray[p].drugName,
                ePrescriptionsArray[p].pharmacistID,
                ePrescriptionsArray[p].PrescriptionLastPickup);
            }

        }

    }

    //allows the pharmacist to view prescribed prescriptions.
    function pharmacistEprescriptionHistory(uint NID_) public payable returns (uint,uint,uint,bytes32,uint,bytes32,uint,uint) {
        require (msg.sender == server); //same function but different security will be implimented for this function
        address blockchainID_ = msg.sender;
        for (uint p = 0; p < ePrescriptionsArray.length; p++) { //Look through memory array for patient with inputted NID and then return the record
            if (ePrescriptionsArray[p].NID == NID_) {

                return (ePrescriptionsArray[p].NID,
                ePrescriptionsArray[p].prescriptionID,
                ePrescriptionsArray[p].prescriptionDate,
                ePrescriptionsArray[p].prescriptionDescription,
                ePrescriptionsArray[p].PrescriptionRefillDate,
                ePrescriptionsArray[p].drugName,
                ePrescriptionsArray[p].pharmacistID,
                ePrescriptionsArray[p].PrescriptionLastPickup);
            }

        }

    }

    //allow the physician to view the patient medical record.
    function physicianMedicalHistory(uint NID_) public payable returns (uint, uint, bytes32, uint, bytes32) {
        require (msg.sender == server); //same function but different security to be implimented on this function
        address blockchainID_ = msg.sender;
        for (uint p = 0; p < medicalHistorysArray.length; p++) { //Look through memory array for patient with inputted NID and then return the record
            if (medicalHistorysArray[p].NID == NID_) {
            
            return (medicalHistorysArray[p].NID,
                medicalHistorysArray[p].operationsID,
                medicalHistorysArray[p].operationsName,
                medicalHistorysArray[p].operationsDate,
                medicalHistorysArray[p].operationsDescription);
            }

        }
    }

    //allow the physician to share patient cases with the other physicians.
    function physicianShareCase(uint NID_) public payable returns (uint, bool) {
        require (msg.sender == server); //same function but different security to be implimented on this function
        address blockchainID_ = msg.sender;
        for (uint p = 0; p < actionsArray.length; p++) { //Look through memory array for patient with inputted NID and then return the record
            if (actionsArray[p].NID == NID_) {
            
            return (actionsArray[p].NID,
                actionsArray[p].shareData);
            }

        }
    }

    //allow the patient to request medication refill.
    function patientPrescription(uint NID_, uint prescriptionID) public payable returns (address) {
        uint time = 604800 * 3; //three weeks in value of seconds.  This code assumes a person gets 4 weeks supply of medication.
        address blockchainID_ = msg.sender;

        if (ePrescriptions[blockchainID_].PrescriptionRefillDate < now + time) { //if the date last prescription is more than 3 weeks ago 
            if (ePrescriptions[blockchainID_].PrescriptionLastPickup < now) { //If the last prescription was actually picked up
                 if(ePrescriptions[blockchainID_].PrescriptionLastPickup < now + time) { //if pickup of prescription was more than 3 weeks ago
                    ePrescriptions[blockchainID_].prescriptionDate = now; // updates prescription date to today
                    ePrescriptions[blockchainID_].PrescriptionRefillDate = now + time; //updates refil date to 1 month ahead
                    notifyPatientRefill(NID_,prescriptionID); //call the below notify patient funciton
                    actions[blockchainID_].prescriptionRefill = true; //update action request
                    }    
            }
        }
    }


    function bloodDonator(uint NID_) public payable {
        require (msg.sender == server); //same function but different security to be implimented on this function
        address blockchainID_ = msg.sender;
        actions[blockchainID_].bloodDonator = true;
         }

    function organDonator(uint NID_) public payable{
        require (msg.sender == server); //same function but different security to be implimented on this function
        address blockchainID_ = msg.sender;
        actions[blockchainID_].organDonator = true;
         }

    function printPatientRecord(uint NID_) public returns (uint,bytes32,bytes32,bytes32,bytes32,bool,bool) {
        
        require (msg.sender == server); //security - only run function of you are the contract owner (meaning a staff member for us).

        address blockchainID_ = msg.sender;
        return (
        persons[blockchainID_].NID,
        persons[blockchainID_].notes,
        ePrescriptions[blockchainID_].prescriptionName,
        medicalHistorys[blockchainID_].operationsName,
        laboratorys[blockchainID_].testDescription,
        actions[blockchainID_].bloodDonator,
        actions[blockchainID_].organDonator);

        emit newPatient(blockchainID_, now); //causing the above defined event to emit
        
    }           

    
}

