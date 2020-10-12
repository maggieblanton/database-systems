/* A1 List all patients currently admitted to the hospital. */

SELECT patients.patientID, concat(patients.firstName, ' ', patients.lastName) AS name
FROM patients, admissions
WHERE admissions.dischargeDate IS NULL
AND patients.patientID = admissions.patientID;


/* A2 List all patients who have received outpatient services 
between January 1, 2020 and July, 29, 2020. */

SELECT patients.patientID, concat(patients.firstName, ' ', patients.lastName) as name
FROM treatments, patients, services
WHERE (treatmentDate BETWEEN '2020-01-01' AND '2020-07-29') AND (services.serviceNum = treatments.serviceNum) 
AND (patients.patientID = services.patientID) AND (services.serviceType = 'Outpatient');

/* A3 List all treatments that were administered for a given patient.*/

SELECT table1.admitNum, table1.treatment1, table2.treatment2
FROM
(SELECT admissions.admitNum, admissions.admitDate, treatments.treatmentName as treatment1
FROM patients, services, admissions, treatments
WHERE patients.patientID = 'jba012' AND 
admissions.patientID = patients.patientID AND 
services.patientID = patients.patientID AND 
treatments.serviceNum = services.serviceNum AND 
admissions.admitNum = services.admitNum
ORDER BY treatments.treatmentDate) as table1
LEFT JOIN
(SELECT admissions.admitNum, treatments.treatmentName as treatment2
FROM patients, services, admissions, treatments
WHERE patients.patientID = 'jba012' AND 
admissions.patientID = patients.patientID AND 
services.patientID = patients.patientID AND 
treatments.serviceNum = services.serviceNum AND 
admissions.admitNum = services.admitNum
ORDER BY treatments.treatmentDate) as table2
ON table1.treatment1 != table2.treatment2 AND table1.admitNum = table2.admitNum
GROUP BY table1.admitNum
ORDER BY table1.admitDate DESC;


/* B1 List treatments in descending number of occurences. */

SELECT treatmentName, treatmentID, COUNT(treatmentID) as occurences
FROM treatments
GROUP BY treatmentID
ORDER BY occurences DESC;

/* B2 List all patients and employees involved with the ordering and adminstration for a given treatment. */

SELECT table2.patientName, table2.treatmentName, table2.docOrdered, table2.techName, 
table2.nurseName, CONCAT(docs.firstName, " ", docs.lastName) as docName

FROM

(SELECT table1.patientName, table1.treatmentName, table1.treatmentID, table1.docOrdered, table1.techName,
CONCAT(nurses.firstName, " ", nurses.lastName) as nurseName, table1.docID

FROM 
(SELECT medicine.patientName, medicine.treatmentName, medicine.treatmentID, medicine.docOrdered,
CONCAT(techs.firstName, " ", techs.lastName) as techName, medicine.nurseID, medicine.docId

FROM (SELECT CONCAT(patients.firstName, " ", patients.lastName) as patientName, treatments.treatmentName, treatments.treatmentID, CONCAT(employees.firstName, " ",
employees.lastName) as docOrdered, treatments.technicianID, treatments.nurseID, treatments.docID
FROM patients, services, treatments, employees
WHERE treatments.serviceNum = services.serviceNum AND services.employeeID = employees.employeeID
AND treatments.treatmentDate = '2020-04-17 06:43:23'
AND services.patientID = patients.patientID) as medicine 

LEFT JOIN (SELECT employeeID, firstName, lastName
FROM employees) as techs 
	ON medicine.technicianID = techs.employeeID) as table1
    
LEFT JOIN (SELECT employeeID, firstName, lastName
FROM employees) as nurses
	ON table1.nurseID = nurses.employeeID) as table2
    
LEFT JOIN (SELECT employeeID, firstName, lastName
FROM employees) as docs
	ON table2.docID = docs.employeeID;
    

/* C1 For a given doctor, list all treatments ordered in descending order of occurence.
Note: Treatments are in descending order by date.*/

SELECT table1.docName, table1.treatmentID, table1.treatmentName, table2.occurences
FROM 
(SELECT CONCAT(employees.firstName, " ", employees.lastName) as docName, treatments.treatmentID, 
treatments.treatmentName, treatments.treatmentDate
FROM services, employees, treatments
WHERE employees.employeeID = services.employeeID AND services.serviceNum = treatments.serviceNum 
AND employees.firstName = 'Timothy' AND employees.lastName = 'Parker'
ORDER BY treatmentDate DESC) as table1

JOIN

(SELECT treatments.treatmentName, COUNT(treatments.treatmentID) as occurences
FROM treatments, employees, services
WHERE employees.employeeID = services.employeeID AND services.serviceNum = treatments.serviceNum 
AND employees.firstName = 'Timothy' AND employees.lastName = 'Parker'
GROUP BY treatments.treatmentID) as table2

ON table1.treatmentName = table2.treatmentName
ORDER BY table1.treatmentDate DESC;


/* C2 List employees who have been involved in the treatment of every admitted patient.*/  

SELECT table2.docName as employeeName
FROM
(SELECT CONCAT (employees.firstName, " ", employees.lastName) as docName, COUNT(employees.employeeID) as numPatients
FROM employees

JOIN

(SELECT services.serviceType, employees.employeeID,
treatments.nurseID, treatments.technicianID, treatments.docID, patients.patientID, treatments.treatmentID
FROM services, employees, treatments, patients
WHERE services.serviceType = 'Inpatient' AND 
employees.employeeID = services.employeeID AND 
treatments.serviceNum = services.serviceNum AND 
services.patientID = patients.patientID
GROUP BY patients.patientID) as table1

ON (employees.employeeID = table1.employeeID OR employees.employeeID = table1.technicianID
OR employees.employeeID = table1.nurseID OR employees.employeeID = table1.docID)
WHERE (employees.employeeID IN (SELECT employeeID FROM employees))
GROUP BY employees.employeeID) as table2
WHERE table2.numPatients = 5;

/* C3 List the primary doctors of patients with high admission rates.*/

SELECT CONCAT(firstName, " ", lastName) as docName
FROM

(SELECT table1.patientName, table1.admitDate, employeeID
FROM
(SELECT CONCAT(firstName, " ", lastName) as patientName, admitDate, patientID
FROM patients
JOIN admissions USING (patientID)) as table1 
JOIN services USING (patientID)
GROUP BY admitDate) as table2 
JOIN employees USING (employeeID) 
WHERE admitDate > NOW() - INTERVAL 1 YEAR
GROUP BY docName
HAVING COUNT(*) >=4;




