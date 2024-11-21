SET LINESIZE 120;
SET PAGESIZE 50;
SET COLSEP '|'; 
COLUMN employeeId FORMAT 999;
COLUMN fullName FORMAT A25;
COLUMN phone FORMAT A15;
COLUMN email FORMAT A30;
COLUMN department FORMAT A15;


BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE employees CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE managers CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE kitchen CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE food CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE receptionist CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE room CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE roomTypePrice CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE roomStatus CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE roomSanitation CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE roomAvailability CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE roomService CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE guest CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE guestStay CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE reservation CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE parking CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE guestParkingStatus CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN NULL;  
END;
/

CREATE TABLE employees (
    employeeId INT PRIMARY KEY NOT NULL,
    fullName VARCHAR2(100),
    phone VARCHAR2(100) DEFAULT 'n/a',
    email VARCHAR2(100),
    department VARCHAR2(100)
);

CREATE TABLE managers (
    managerId INT PRIMARY KEY NOT NULL,
    fullName VARCHAR2(100),
    phone VARCHAR2(10) DEFAULT 'n/a',
    email VARCHAR2(100)
);

CREATE TABLE kitchen (
    employeeId INT,
    FOREIGN KEY (employeeId) REFERENCES employees(employeeId),
    workHours FLOAT
);

CREATE TABLE food (
    itemId INT PRIMARY KEY NOT NULL,
    fullName VARCHAR2(100),
    quantity INT,
    status VARCHAR2(100)
);

CREATE TABLE receptionist (
    employeeId INT,
    FOREIGN KEY (employeeId) REFERENCES employees(employeeId),
    workHours FLOAT
);

CREATE TABLE room (
    roomNumber INT PRIMARY KEY NOT NULL,
    roomType VARCHAR2(100)
);

CREATE TABLE roomTypePrice (
    roomType VARCHAR2(100) PRIMARY KEY,
    price FLOAT
);

CREATE TABLE roomStatus (
    statusID INT PRIMARY KEY NOT NULL,
    status VARCHAR2(100)
);

CREATE TABLE roomSanitation (
    sanitationID INT PRIMARY KEY NOT NULL,
    sanitationStatus VARCHAR2(100)
);

CREATE TABLE roomAvailability (
    roomNumber INT,
    statusID INT,
    sanitationID INT,
    FOREIGN KEY (roomNumber) REFERENCES room(roomNumber),
    FOREIGN KEY (statusID) REFERENCES roomStatus(statusID),
    FOREIGN KEY (sanitationID) REFERENCES roomSanitation(sanitationID)
);

DROP SEQUENCE service_seq;
CREATE SEQUENCE service_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE roomService (
    serviceId INT PRIMARY KEY, 
    employeeId INT,
    roomNumber INT,
    status VARCHAR2(20),
    workHours FLOAT,
    FOREIGN KEY (employeeId) REFERENCES employees(employeeId),
    FOREIGN KEY (roomNumber) REFERENCES room(roomNumber)
);

CREATE OR REPLACE TRIGGER roomService_before_insert
BEFORE INSERT ON roomService
FOR EACH ROW
BEGIN
  SELECT service_seq.NEXTVAL INTO :NEW.serviceId FROM dual;
END;
/

CREATE TABLE guest (
    guestId INT PRIMARY KEY NOT NULL,
    fullName VARCHAR2(100),
    phone VARCHAR2(10) DEFAULT 'n/a',
    email VARCHAR2(100)
);

CREATE TABLE guestStay (
    guestId INT,
    roomNumber INT,
    checkInDate DATE,
    checkOutDate DATE,
    PRIMARY KEY (guestId, roomNumber, checkInDate, checkOutDate),
    FOREIGN KEY (guestId) REFERENCES guest(guestId), 
    FOREIGN KEY (roomNumber) REFERENCES room(roomNumber)
);

CREATE TABLE reservation (
    reservationId INT PRIMARY KEY NOT NULL,
    guestId INT,
    FOREIGN KEY (guestId) REFERENCES guest(guestId),
    roomNumber INT,
    status VARCHAR2(100),
    checkInDate DATE,
    checkOutDate DATE
);

CREATE TABLE parking (
    parkingId INT PRIMARY KEY NOT NULL,
    guestId INT,
    FOREIGN KEY (guestId) REFERENCES guest(guestId)
);

CREATE TABLE guestParkingStatus (
    guestId INT,
    parkingId INT,
    status VARCHAR2(100),
    PRIMARY KEY (guestId, parkingId),
    FOREIGN KEY (guestId) REFERENCES guest(guestId),
    FOREIGN KEY (parkingId) REFERENCES parking(parkingId)
);

INSERT ALL
    INTO employees (employeeId, fullName, phone, email, department) VALUES (101, 'Alice Johnson', '6471234567', 'alice.johnson@example.com', 'Reception')
    INTO employees (employeeId, fullName, phone, email, department) VALUES (102, 'Bob Smith', '6472345678', 'bob.smith@example.com', 'Kitchen')
    INTO employees (employeeId, fullName, phone, email, department) VALUES (103, 'Carol Brown', '6473456789', 'carol.brown@example.com', 'Room Service')
    INTO employees (employeeId, fullName, phone, email, department) VALUES (104, 'David Green', '6474567890', 'david.green@example.com', 'Reception')
    INTO employees (employeeId, fullName, phone, email, department) VALUES (105, 'Eve White', '6475678901', 'eve.white@example.com', 'Kitchen')
SELECT * FROM dual;

INSERT ALL
    INTO managers (managerId, fullName, phone, email) VALUES (201, 'Frank Black', '4161234567', 'frank.black@example.com')
    INTO managers (managerId, fullName, phone, email) VALUES (202, 'Grace Grey', '4162345678', 'grace.grey@example.com')
    INTO managers (managerId, fullName, phone, email) VALUES (203, 'Hannah Red', '4163456789', 'hannah.red@example.com')
    INTO managers (managerId, fullName, phone, email) VALUES (204, 'Ivan Orange', '4164567890', 'ivan.orange@example.com')
    INTO managers (managerId, fullName, phone, email) VALUES (205, 'Jack Purple', '4165678901', 'jack.purple@example.com')
SELECT * FROM dual;

INSERT ALL
    INTO kitchen (employeeId, workHours) VALUES (102, 8.0)
    INTO kitchen (employeeId, workHours) VALUES (105, 9.5)
    INTO kitchen (employeeId, workHours) VALUES (103, 7.5)
    INTO kitchen (employeeId, workHours) VALUES (104, 10.0)
    INTO kitchen (employeeId, workHours) VALUES (101, 6.0)
SELECT * FROM dual;

INSERT ALL
    INTO food (itemId, fullName, quantity, status) VALUES (1, 'Burger', 50, 'Available')
    INTO food (itemId, fullName, quantity, status) VALUES (2, 'Pizza', 0, 'Unavailable')
    INTO food (itemId, fullName, quantity, status) VALUES (3, 'Salad', 20, 'Available')
    INTO food (itemId, fullName, quantity, status) VALUES (4, 'Pasta', 15, 'Available')
    INTO food (itemId, fullName, quantity, status) VALUES (5, 'Soup', 0, 'Unavailable')
SELECT * FROM dual;

INSERT ALL
    INTO receptionist (employeeId, workHours) VALUES (101, 8.0)
    INTO receptionist (employeeId, workHours) VALUES (104, 10.0)
    INTO receptionist (employeeId, workHours) VALUES (103, 7.5)
    INTO receptionist (employeeId, workHours) VALUES (105, 9.0)
    INTO receptionist (employeeId, workHours) VALUES (102, 6.5)
SELECT * FROM dual;

INSERT ALL
    INTO room (roomNumber, roomType) VALUES (101, 'Single')
    INTO room (roomNumber, roomType) VALUES (102, 'Double')
    INTO room (roomNumber, roomType) VALUES (103, 'Suite')
    INTO room (roomNumber, roomType) VALUES (104, 'Deluxe')
    INTO room (roomNumber, roomType) VALUES (105, 'Penthouse')
SELECT * FROM dual;

INSERT ALL
    INTO roomTypePrice (roomType, price) VALUES ('Single', 100.0)
    INTO roomTypePrice (roomType, price) VALUES ('Double', 150.0)
    INTO roomTypePrice (roomType, price) VALUES ('Suite', 250.0)
    INTO roomTypePrice (roomType, price) VALUES ('Deluxe', 300.0)
    INTO roomTypePrice (roomType, price) VALUES ('Penthouse', 500.0)
SELECT * FROM dual;

INSERT ALL
    INTO roomStatus (statusID, status) VALUES (1, 'Ready')
    INTO roomStatus (statusID, status) VALUES (2, 'Occupied')
    INTO roomStatus (statusID, status) VALUES (3, 'Not Ready')
    INTO roomStatus (statusID, status) VALUES (4, 'Under Maintenance')
    INTO roomStatus (statusID, status) VALUES (5, 'Closed')
SELECT * FROM dual;

INSERT ALL
    INTO roomSanitation (sanitationID, sanitationStatus) VALUES (1, 'Clean')
    INTO roomSanitation (sanitationID, sanitationStatus) VALUES (2, 'Needs Cleaning')
    INTO roomSanitation (sanitationID, sanitationStatus) VALUES (3, 'Sanitized')
    INTO roomSanitation (sanitationID, sanitationStatus) VALUES (4, 'In Progress')
    INTO roomSanitation (sanitationID, sanitationStatus) VALUES (5, 'Not Clean')
SELECT * FROM dual;

INSERT ALL
    INTO roomAvailability (roomNumber, statusID, sanitationID) VALUES (101, 1, 1)
    INTO roomAvailability (roomNumber, statusID, sanitationID) VALUES (102, 2, 3)
    INTO roomAvailability (roomNumber, statusID, sanitationID) VALUES (103, 3, 5)
    INTO roomAvailability (roomNumber, statusID, sanitationID) VALUES (104, 4, 4)
    INTO roomAvailability (roomNumber, statusID, sanitationID) VALUES (105, 5, 2)
SELECT * FROM dual;

INSERT ALL
    INTO roomService (serviceId, employeeId, roomNumber, status, workHours) VALUES (1, 103, 101, 'Completed', 5.0)
    INTO roomService (serviceId, employeeId, roomNumber, status, workHours) VALUES (2, 103, 102, 'Pending', 4.0)
    INTO roomService (serviceId, employeeId, roomNumber, status, workHours) VALUES (3, 104, 103, 'In Progress', 3.0)
    INTO roomService (serviceId, employeeId, roomNumber, status, workHours) VALUES (4, 104, 104, 'Completed', 6.0)
    INTO roomService (serviceId, employeeId, roomNumber, status, workHours) VALUES (5, 105, 105, 'Pending', 2.5)
SELECT * FROM dual;

INSERT ALL
    INTO guest (guestId, fullName, phone, email) VALUES (301, 'Micheal Scott', '4161230001', 'micheal.scott@example.com')
    INTO guest (guestId, fullName, phone, email) VALUES (302, 'Pam Beesly', '4162340002', 'pam.beesly@example.com')
    INTO guest (guestId, fullName, phone, email) VALUES (303, 'Jim Halpert', '4163450003', 'jim.halpert@example.com')
    INTO guest (guestId, fullName, phone, email) VALUES (304, 'Dwight Schrute', '4164560004', 'dwight.schrute@example.com')
    INTO guest (guestId, fullName, phone, email) VALUES (305, 'Angela Martin', '4165670005', 'angela.martin@example.com')
SELECT * FROM dual;

INSERT ALL
    INTO guestStay (guestId, roomNumber, checkInDate, checkOutDate) VALUES (301, 101, TO_DATE('2024-11-01', 'YYYY-MM-DD'), TO_DATE('2024-11-05', 'YYYY-MM-DD'))
    INTO guestStay (guestId, roomNumber, checkInDate, checkOutDate) VALUES (302, 102, TO_DATE('2024-11-03', 'YYYY-MM-DD'), TO_DATE('2024-11-07', 'YYYY-MM-DD'))
    INTO guestStay (guestId, roomNumber, checkInDate, checkOutDate) VALUES (303, 103, TO_DATE('2024-11-04', 'YYYY-MM-DD'), TO_DATE('2024-11-10', 'YYYY-MM-DD'))
    INTO guestStay (guestId, roomNumber, checkInDate, checkOutDate) VALUES (304, 104, TO_DATE('2024-11-06', 'YYYY-MM-DD'), TO_DATE('2024-11-09', 'YYYY-MM-DD'))
    INTO guestStay (guestId, roomNumber, checkInDate, checkOutDate) VALUES (305, 105, TO_DATE('2024-11-07', 'YYYY-MM-DD'), TO_DATE('2024-11-12', 'YYYY-MM-DD'))
SELECT * FROM dual;

INSERT ALL
    INTO reservation (reservationId, guestId, roomNumber, status, checkInDate, checkOutDate) 
    VALUES (1, 301, 101, 'Confirmed', TO_DATE('2024-11-01', 'YYYY-MM-DD'), TO_DATE('2024-11-05', 'YYYY-MM-DD'))
    INTO reservation (reservationId, guestId, roomNumber, status, checkInDate, checkOutDate) 
    VALUES (2, 302, 102, 'Checked In', TO_DATE('2024-11-03', 'YYYY-MM-DD'), TO_DATE('2024-11-07', 'YYYY-MM-DD'))
    INTO reservation (reservationId, guestId, roomNumber, status, checkInDate, checkOutDate) 
    VALUES (3, 303, 103, 'Confirmed', TO_DATE('2024-11-04', 'YYYY-MM-DD'), TO_DATE('2024-11-10', 'YYYY-MM-DD'))
    INTO reservation (reservationId, guestId, roomNumber, status, checkInDate, checkOutDate) 
    VALUES (4, 304, 104, 'Checked Out', TO_DATE('2024-11-06', 'YYYY-MM-DD'), TO_DATE('2024-11-09', 'YYYY-MM-DD'))
    INTO reservation (reservationId, guestId, roomNumber, status, checkInDate, checkOutDate) 
    VALUES (5, 305, 105, 'Cancelled', TO_DATE('2024-11-07', 'YYYY-MM-DD'), TO_DATE('2024-11-12', 'YYYY-MM-DD'))
SELECT * FROM dual;

INSERT ALL
    INTO parking (parkingId, guestId) VALUES (1, 301)
    INTO parking (parkingId, guestId) VALUES (2, 302)
    INTO parking (parkingId, guestId) VALUES (3, 303)
    INTO parking (parkingId, guestId) VALUES (4, 304)
    INTO parking (parkingId, guestId) VALUES (5, 305)
SELECT * FROM dual;

INSERT ALL
    INTO guestParkingStatus (guestId, parkingId, status) VALUES (301, 1, 'Occupied')
    INTO guestParkingStatus (guestId, parkingId, status) VALUES (302, 2, 'Reserved')
    INTO guestParkingStatus (guestId, parkingId, status) VALUES (303, 3, 'Vacant')
    INTO guestParkingStatus (guestId, parkingId, status) VALUES (304, 4, 'Occupied')
    INTO guestParkingStatus (guestId, parkingId, status) VALUES (305, 5, 'Reserved')
SELECT * FROM dual;



SELECT * FROM employees;
SELECT * FROM managers;
SELECT * FROM kitchen;
SELECT * FROM food;
SELECT * FROM receptionist;
SELECT * FROM room;
SELECT * FROM roomTypePrice;
SELECT * FROM roomStatus;
SELECT * FROM roomSanitation;
SELECT * FROM roomAvailability;
SELECT * FROM roomService;
SELECT * FROM guest;
SELECT * FROM guestStay;
SELECT * FROM reservation;
SELECT * FROM parking;
SELECT * FROM guestParkingStatus;




