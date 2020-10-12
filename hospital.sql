DROP DATABASE IF EXISTS `hospital`;
CREATE DATABASE `hospital`; 
USE `hospital`;

drop table if exists patients;
drop table if exists employees;
drop table if exists services;
drop table if exists treatments;

create table patients (
  patientID varchar(6),
  firstName varchar(10),
  lastName varchar(10),
  emergencyContactFirstName varchar(10),
  emergencyContactLastName varchar(10),
  emergencyContactPhone varchar(10),
  insuranceCompany varchar(30),
  insurancePolicyNum integer,
  primary key (patientID)
);

create table admissions ( 
	admitNum varchar(6),
    patientID varchar(6),
    admitDate date, 
    dischargeDate date,
    primary key (admitNum),
    foreign key (patientID) references patients (patientID)
    on delete cascade
);

create table employees (
	employeeID varchar(6), 
    firstName varchar(10), 
    lastName varchar(10), 
    privilegeType varchar(10),
    employeeType varchar(10),
    primary key (employeeID)
);

create table services ( 
	serviceNum varchar(6), 
    patientID varchar(6), 
    employeeID varchar(6), 
    serviceType varchar(10),
    admitNum varchar(6),
    primary key (serviceNum), 
    foreign key (patientID) references patients (patientID)
    on delete cascade,
    foreign key (employeeID) references employees (employeeID) 
    on delete cascade,
    foreign key (admitNum) references admissions (admitNum)
    on delete cascade
); 

create table treatments (
	treatmentID varchar(6), 
    treatmentName varchar(25), 
    treatmentDate timestamp, 
    serviceNum varchar(6), 
    technicianID varchar(6),
    nurseID varchar(6),
    docID varchar(6),
    primary key (treatmentID, serviceNum, treatmentDate), 
	foreign key (serviceNum) references services (serviceNum)
    on delete cascade,
    foreign key (technicianID) references employees (employeeID)
    on delete cascade,
    foreign key (nurseID) references employees (employeeID)
    on delete cascade
); 

insert into patients values 
  ('jba012', 'James', 'Adams', 'Mary', 'Baker', '4043331965', 'BlueCross BlueShield', 7555), 
  ('jfc534', 'John', 'Clark', 'Jennifer', 'Clark', '2053223330', 'UnitedHealth', 5434),
  ('rbs333', 'Robert', 'Smith', 'Jill', 'Smith', '3341238654', 'Anthem, Inc.', 3342),
  ('eaj453', 'Elizabeth', 'Jones', 'Sarah', 'White', '5434114325', 'Humana', '4526'),
  ('r2f532', 'Rebecca', 'Franklin', 'Jack', 'Franklin', '205470854', 'UnitedHealth', 8954), 
  ('tag932', 'Teresa', 'Garcia', 'David', 'Garcia', '8708724421', 'WellCare', 7539),
  ('mmb412', 'Madison', 'Busby', 'Riley', 'Davis', '6746357667', 'WellCare', 7573),
  ('bjj453', 'Brooks', 'Johnson', 'Brett', 'Freeman', '234345654', 'BlueCross BlueShield', 8635),
  ('sam123', 'Sam', 'Morris', 'Jeff', 'Morris', '3342567676', 'Humana', 2421),
  ('rbg164', 'Ron', 'Green', 'Susan', 'James', '2134342322', 'Wellcare', 1453);

insert into admissions values 
	('A1', 'jba012', '2020-04-16', '2020-04-19'),
    ('A2', 'jba012', '2020-04-21', '2020-04-23'),
    ('A3', 'jba012', '2020-05-12', '2020-05-14'),
    ('A4', 'jba012', '2020-05-23', '2020-05-26'),
    ('A5', 'eaj453', '2019-12-25', '2019-12-26'),
    ('A6', 'r2f532', '2020-07-28', NULL),
    ('A7', 'bjj453', '2015-09-23', '2015-09-24'),
    ('A8', 'mmb412', '2020-07-24', NULL),
    ('A9', 'sam123', '2020-06-29', NULL);
    
insert into employees values 
	('CDOC1', 'Jacob', 'Norris', 'Consult', 'Doctor'),
    ('TECH1', 'Kate', 'Shephard', NULL, 'Technician'), 
    ('ADOC1', 'Timothy', 'Parker', 'Admit', 'Doctor'),
    ('ADOC2', 'Kristy', 'Jones', 'Admit', 'Doctor'), 
    ('NURS1', 'Anita', 'Johnson', NULL, 'Nurse'),
    ('CDOC2', 'Amanda', 'Lewis', 'Consult', 'Doctor'),
    ('NURS2', 'Sally', 'Carson', NULL, 'Nurse'), 
    ('ADOC3', 'Sarah', 'Anderson', 'Admit', 'Doctor'),
    ('ADMIN1', 'April', 'Grey', NULL, 'Admin');
    
insert into services values 
	('S1', 'jba012', 'ADOC1', 'Inpatient', 'A1'),
    ('S2', 'bjj453', 'ADOC3', 'Outpatient', NULL),
    ('S3', 'mmb412', 'ADOC2', 'Inpatient', 'A8'),
    ('S4', 'bjj453', 'ADOC1', 'Inpatient', 'A7'),
    ('S5', 'eaj453', 'ADOC1', 'Inpatient', 'A5'), 
    ('S6', 'eaj453', 'ADOC1', 'Outpatient', NULL),
    ('S7', 'r2f532', 'ADOC1', 'Inpatient', 'A6'), 
    ('S8', 'tag932', 'CDOC2', 'Outpatient', NULL),
    ('S9', 'rbg164', 'ADOC3', 'Outpatient', NULL), 
    ('S10', 'sam123', 'ADOC1', 'Inpatient', NULL),
    ('S11', 'jba012', 'ADOC1', 'Inpatient', 'A2'),
    ('S12', 'jba012', 'ADOC1', 'Inpatient', 'A3');
    
insert into treatments values 
	('T1', 'Open Heart Surgery', '2020-04-17 06:43:23', 'S1', 'TECH1', 'NURS1', 'CDOC1'),
    ('T2', 'Tonsillectomy', '2019-12-29 11:56:12', 'S8', NULL, 'NURS2', 'CDOC1'),
    ('T10', 'Ibuprofen', '2019-12-29 11:56:12', 'S8', NULL, 'NURS2', 'CDOC1'),
    ('T3', 'Caesarean Section', '2020-07-28 12:43:34', 'S3', 'TECH1', 'NURS1', 'ADOC1'),
    ('T4', 'Crainiotomy', '2015-09-23 5:06:35', 'S4', NULL, 'NURS1', 'ADOC2'),
    ('T5', 'Oxycodone', '2019-12-29 7:03:49', 'S8', NULL, 'NURS2', 'CDOC1'),
    ('T6', 'Chemotherapy', '2020-01-12 09:08:09', 'S6', 'TECH1', NULL, NULL),
    ('T7', 'Zoloft', '2014-09-15 13:43:56', 'S2', NULL, 'NURS2', 'ADOC1'),
    ('T4', 'Crainiotomy', '2019-12-25 15:42:45', 'S5', NULL, 'NURS1', 'CDOC2'),
    ('T9', 'Intravenous Fluid Therapy', '2020-07-29 14:54:23', 'S7', NULL, 'NURS1', 'CDOC1'),
    ('T9', 'Intravenous Fluid Therapy', '2020-07-29 14:56:25', 'S7', NULL, 'NURS1', 'CDOC1'),
    ('T10', 'Ibuprofen', '2020-03-21 09:12:43', 'S9', NULL, NULL, 'CDOC3'), 
    ('T10', 'Ibuprofen', '2020-04-22 05:12:34', 'S11', 'TECH1', 'NURS1', 'CDOC1'),
    ('T10', 'Ibuprofen', '2020-05-13 12:34:12', 'S12', 'TECH1', 'NURS1', 'CDOC1'),
    ('T13', 'Morphine', '2020-04-17 06:43:42', 'S1', 'TECH1', 'NURS1', 'CDOC1');




