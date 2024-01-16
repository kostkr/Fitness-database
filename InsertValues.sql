SET NOCOUNT ON

EXEC InsertTrainer 'John','Doe', '1980-01-01', 'M', '369 Maple St', 'Medical Fitness', '2010-01-01', 2500, '555-555-5555', 'johndoe@email.com'
EXEC InsertTrainer 'Jane', 'Smith', '1982-01-01', 'F', '159 Willow St', 'Lifestyle Wellness Coach', '2011-01-01', 7000, '555-555-5556', 'janesmith@email.com'
EXEC InsertTrainer 'Bob', 'Johnson', '1985-01-01', 'M', '753 Oak St', 'Senior Fitness Specialist', '2012-01-01', 5544, '555-555-5557', 'bobjohnson@email.com'
EXEC InsertTrainer 'Samantha', 'Williams', '1987-01-01', 'F', '789 Dfk St','Youth Fitness Specialists', '2013-01-01', 7895, '555-555-5558', 'samanthawilliams@email.com'
EXEC InsertTrainer 'Michael', 'Jones', '1989-01-01', 'M','153 Monna St', 'Group Fitness Instructor', '2014-01-01', 4168, '555-555-5559', 'michaeljones@email.com'
EXEC InsertTrainer 'Emily', 'Brown', '1991-01-01', 'F', '258 Sag St', 'Nutrition Coach', '2015-01-01', 1987, '555-555-5560', 'emilybrown@email.com'
EXEC InsertTrainer  'Jacob', 'Miller', '1993-01-01', 'M','989 Anama St','Fitness Management Specialization', '2016-01-01', 4597, '555-555-5561', 'jacobmiller@email.com'


EXEC InsertClient 'Bob', 'Johnson', '1988-03-22', 'M', '123 Main St'
EXEC InsertClient 'Emily', 'Davis', '1992-09-12', 'F', '456 Park Ave'
EXEC InsertClient 'Michael', 'Brown', '1987-01-01', 'M', '789 Elm St'
EXEC InsertClient 'Emily', 'Jones', '1990-12-02', 'F', '321 Oak St'
EXEC InsertClient 'Jacob', 'Miller', '1994-06-07', 'M', '654 Pine St'
EXEC InsertClient 'Sophia', 'Wilson', '1988-11-11', 'F', '987 Cedar St'
EXEC InsertClient 'Ethan', 'Moore', '1991-09-23', 'M', '246 Birch St'
EXEC InsertClient 'Isabella', 'Taylor', '1995-03-05', 'F', '369 Maple St'
EXEC InsertClient 'Michael', 'Anderson', '1989-08-15', 'M', '159 Willow St'
EXEC InsertClient 'Emily', 'Thomas', '1993-02-22', 'F', '753 Oak St'
EXEC InsertClient 'Jacob', 'Hernandez', '1987-10-30', 'M', '369 Maple St'
EXEC InsertClient 'Sophia', 'Moore', '1991-07-13', 'F', '159 Willow St'
EXEC InsertClient 'Ethan', 'Martin', '2004-04-01', 'M', '753 Oak St'
EXEC InsertClient 'Isabella', 'Lee', '1988-12-25', 'F', '359 Maple St'
EXEC InsertClient 'Michael', 'Perez', '1992-08-15', 'M', '259 Willow St'
EXEC InsertClient 'Emily', 'Turner', '1996-05-07', 'F','773 Oak St'
EXEC InsertClient 'Jacob', 'Phillips', '1989-03-11', 'M', '549 Maple St'
EXEC InsertClient 'Sophia', 'Campbell', '1993-09-21', 'F','649 Willow St'
EXEC InsertClient 'Sophia', 'Sanchez', '1996-11-11', 'F','713 Oak St'
EXEC InsertClient 'Isabella', 'Rogers', '1993-04-15', 'F','398 Maple St'

INSERT INTO SportsDiscipline(SportsID, Name) VALUES
(1, 'Football'),
(2, 'Basketball'),
(3, 'Tennis'),
(4, 'Swimming'),
(5, 'Gymnastics'),
(6, 'Boxing'),
(7, 'Yoga'),
(8, 'CrossFit'),
(9, 'Running'),
(10, 'Cycling'),
(11, 'Volleyball'),
(12, 'Badminton'),
(13, 'Rowing'),
(14, 'Cricket'),
(15, 'Hockey');
GO

INSERT INTO TrainerSD VALUES
(1, 4),
(1, 5),
(2, 12),
(2, 13),
(2, 14),
(3, 1),
(3, 2),
(3, 3),
(4, 4),
(4, 6),
(4, 8),
(5, 7),
(5, 9),
(6, 10),
(6, 11),
(6, 15),
(7, 2);
GO

INSERT INTO SportsRoom VALUES
(0001, 250, 'Squash Court'),
(0002, 100, 'Badminton Court'),
(0003, 140, 'Tennis Court'),
(0004, 45, 'Table Tennis Room'),
(0005, 178, 'Basketball Court'),
(1006, 64, 'Gym'),
(1007, 78, 'Boxing Room'),
(1008, 89, 'Cricket Room'),
(1009, 200,'Swimming Pool'),
(2010, 77, 'Yoga Studio'),
(2011, 65, 'Rock Climbing Room'),
(2012, 72, 'Runnig Room'),
(2013, 78, 'Volleyball Court');
GO

INSERT INTO Lockers VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15);
GO


INSERT INTO LockersReservations VALUES
(8, 1, '20200624 10:36:20', '20200624 13:36:20' ),
(9, 2, '20200626 10:46:20', '20200626 13:46:20' ),
(11, 8, '20200627 18:47:20', '20200627 22:47:20' ),
(13, 12, '20200624 10:36:20', '20200624 13:36:20' );
GO


INSERT INTO AbonamentType VALUES (1, 'Standard Football', 19.99, 1);
INSERT INTO AbonamentType VALUES (1, 'Premium Football', 39.99, NULL);
INSERT INTO AbonamentType VALUES (1, 'Group Football', 249.99, NULL);
INSERT INTO AbonamentType VALUES (2, 'Standard Basketball', 15.99, 1 );
INSERT INTO AbonamentType VALUES (2, 'Premium Basketball', 49.99, NULL);
INSERT INTO AbonamentType VALUES (2, 'Group Basketball', 179.99, NULL);
INSERT INTO AbonamentType VALUES (3, 'Standard Tennis', 55.99, 1);
INSERT INTO AbonamentType VALUES (3, 'Premium Tennis', 100.99, NULL);
INSERT INTO AbonamentType VALUES (3, 'Group Tennis', 227.99, NULL);
INSERT INTO AbonamentType VALUES (4, 'Standard Swimming', 57.99, 1);
INSERT INTO AbonamentType VALUES (4, 'Premium Swimming', 150.99, NULL);
INSERT INTO AbonamentType VALUES (4, 'Group Swimming', 333.99, NULL);
INSERT INTO AbonamentType VALUES (5, 'Standard Gymnastics', 227.99, 1);
INSERT INTO AbonamentType VALUES (5, 'Premium Gymnastics', 550.99, NULL);
INSERT INTO AbonamentType VALUES (5, 'Group Gymnastics', 783.99, NULL);
INSERT INTO AbonamentType VALUES (6, 'Standard Boxing', 127.99, 1);
INSERT INTO AbonamentType VALUES (6, 'Premium Boxing', 250.99, NULL);
INSERT INTO AbonamentType VALUES (6, 'Group Boxing', 683.99, NULL);
INSERT INTO AbonamentType VALUES (7, 'Standard Yoga', 127.99, 1);
INSERT INTO AbonamentType VALUES (7, 'Premium Yoga', 200.99, NULL);
INSERT INTO AbonamentType VALUES (7, 'Group Yoga', 879.44, NULL);
INSERT INTO AbonamentType VALUES (8, 'Standard CrossFit', 427.99, 1);
INSERT INTO AbonamentType VALUES (8, 'Premium CrossFit', 600.99, NULL);
INSERT INTO AbonamentType VALUES (8, 'Group CrossFit', 1003.99, NULL);
INSERT INTO AbonamentType VALUES (9, 'Standard Running', 327.99, 1);
INSERT INTO AbonamentType VALUES (9, 'Premium Running', 600.99, NULL);
INSERT INTO AbonamentType VALUES (9, 'Group Running', 903.99, NULL);
INSERT INTO AbonamentType VALUES (10, 'Standard Cycling', 727.99, 1);
INSERT INTO AbonamentType VALUES (10, 'Premium Cycling', 900.99, NULL);
INSERT INTO AbonamentType VALUES (10, 'Group Cycling', 1203.99, NULL);
INSERT INTO AbonamentType VALUES (11, 'Standard Volleyball', 127.99, 1);
INSERT INTO AbonamentType VALUES (11, 'Premium Volleyball', 400.99, NULL);
INSERT INTO AbonamentType VALUES (11, 'Group Volleyball', 803.99, NULL);
INSERT INTO AbonamentType VALUES (12, 'Standard Badminton', 227.99, 1);
INSERT INTO AbonamentType VALUES (12, 'Premium Badminton', 450.99, NULL);
INSERT INTO AbonamentType VALUES (12, 'Group Badminton', 523.99, NULL);
INSERT INTO AbonamentType VALUES (13, 'Standard Rowing', 227.99, 1);
INSERT INTO AbonamentType VALUES (13, 'Premium Rowing', 440.99, NULL);
INSERT INTO AbonamentType VALUES (13, 'Group Rowing', 553.99, NULL);
INSERT INTO AbonamentType VALUES (14, 'Standard Cricket', 127.99, 1);
INSERT INTO AbonamentType VALUES (14, 'Premium Cricket', 480.99, NULL);
INSERT INTO AbonamentType VALUES (14,'Group Cricket', 1523.99, NULL);
INSERT INTO AbonamentType VALUES (15, 'Standard Hockey', 127.99, 1);
INSERT INTO AbonamentType VALUES (15, 'Premium Hockey', 480.99, NULL);
INSERT INTO AbonamentType VALUES (15, 'Group Hockey', 1523.99, NULL);
GO

INSERT INTO Abonament ( AbonamentTypeID, StartDate, EndDate, PaymentMethod) VALUES 
(1,	 '2022-01-01', '2022-12-31', 'CreditCard'),
(5,	 '2022-02-01', '2022-11-30', 'Cash'),
(8,  '2022-03-01', '2022-10-31', 'Cash'),
(16, '2022-04-01', '2022-09-30', 'Cash'),
(41, '2022-05-01', '2022-08-31', 'Cash'),
(37, '2022-06-01', '2022-07-31', 'Cash'),
(44, '2022-07-01', '2022-08-01', 'CreditCard'),
(23, '2022-08-01', '2022-09-01', 'CreditCard'),
(20, '2022-09-01', '2022-10-01', 'CreditCard'),
(42, '2022-10-29', '2022-11-29', 'CreditCard');
GO


INSERT INTO ClientAbonament VALUES
(8, 1),
(9, 2),
(10, 3),
(11, 4),
(12, 5),
(13, 6),
(14, 7),
(15, 8),
(16 , 9),
(17, 10),
(18, 10),
(19, 10),
(20, 10),
(21, 10),
(22, 10),
(23, 10),
(24, 10),
(25, 10),
(26, 10),
(27, 10);
GO

INSERT INTO GroupID VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15);
GO


EXEC InsertWorkOut 1, 1, '20200624 10:36:20', '20200624 13:36:20', 1, 1009
EXEC InsertWorkOut 2, 1, '20200626 10:46:20', '20200626 13:46:20', 1, 1009
EXEC InsertWorkOut 3, 1, '20200629 10:20:20', '20200629 13:20:20', 3, 1009
EXEC InsertWorkOut 4, 2, '20200624 10:36:20', '20200624 13:36:20', 2, 1009
EXEC InsertWorkOut 5, 4, '20200626 10:46:20', '20200626 13:46:20', 4, 1009
EXEC InsertWorkOut 10, 3, '20200617 11:47:20', '20200617 14:47:20', 3, 3
EXEC InsertWorkOut 10, 3, '20200627 18:47:20', '20200627 22:47:20', 3, 3