DROP TABLE IF EXISTS WorkOut, LockersReservations, GroupID, ClientAbonament, TrainerSD, Abonament, AbonamentType,
SportsDiscipline, Trainer, Client, Mail, Phone, Human, SportsRoom, Lockers

CREATE TABLE Human(
HumanID INT PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(20) NOT NULL,
SurName VARCHAR(20) NOT NULL,
DateOfBirth DATE NOT NULL,
Gender VARCHAR(1) NOT NULL,
Address VARCHAR(50) NOT NULL,
)
GO

CREATE TABLE Mail(
HumanID INT,
Mail VARCHAR(50) UNIQUE NOT NULL ,
FOREIGN KEY (HumanID) REFERENCES Human(HumanID)
ON DELETE CASCADE
)
GO

CREATE TABLE Phone(
HumanID INT,
Phone VARCHAR(50) UNIQUE NOT NULL,
FOREIGN KEY (HumanID) REFERENCES Human(HumanID)
ON DELETE CASCADE
)
GO

CREATE TABLE SportsDiscipline(
SportsID INT PRIMARY KEY,
Name VARCHAR(20)
)
GO

CREATE TABLE Trainer(
TrainerID INT PRIMARY KEY,
Specialization VARCHAR(20) NOT NULL,
WorkingSince DATE NOT NULL,
Salary MONEY NOT NULL
FOREIGN KEY (TrainerID) REFERENCES Human(HumanID)
ON DELETE CASCADE
)
GO

CREATE TABLE TrainerSD(
TrainerID INT NOT NULL,
SportsID INT NOT NULL,
FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID),
FOREIGN KEY (SportsID) REFERENCES SportsDiscipline(SportsID)
ON DELETE CASCADE
)
GO

CREATE TABLE Client(
ClientID INT PRIMARY KEY,
FOREIGN KEY(ClientID) REFERENCES Human(HumanID)
ON DELETE CASCADE
)  
GO

CREATE TABLE AbonamentType(
AbonamentTypeID INT IDENTITY(1,1) PRIMARY KEY,
SportsID INT NOT NULL,
Name VARCHAR(50) NOT NULL,
Price MONEY NOT NULL,
MaxVisitsNumber INT NULL,
FOREIGN KEY (SportsID) REFERENCES SportsDiscipline(SportsID)
)
GO

CREATE TABLE Abonament(
AbonamentID INT IDENTITY(1,1) PRIMARY KEY,
AbonamentTypeID INT NOT NULL,
StartDate DATE NOT NULL,
EndDate DATE NOT NULL,
PaymentMethod VARCHAR(20) NOT NULL,
CurrentVisitsNumber INT DEFAULT(0) NOT NULL,
FOREIGN KEY(AbonamentTypeID) REFERENCES AbonamentType(AbonamentTypeID),
CHECK (StartDate <= EndDate)
)
GO

CREATE TABLE ClientAbonament(
ClientID INT NOT NULL,
AbonamentID INT NOT NULL,
FOREIGN KEY(AbonamentID) REFERENCES Abonament(AbonamentID),
FOREIGN KEY(ClientID) REFERENCES Client(ClientID)
ON DELETE CASCADE
)
GO

CREATE TABLE SportsRoom(
RoomID INT PRIMARY KEY,
Square INT NOT NULL, 
Specification VARCHAR(50) NOT NULL
)
GO

CREATE TABLE GroupID(
GroupID INT IDENTITY(1,1) PRIMARY KEY,
SportsID INT NOT NULL,
FOREIGN KEY(SportsID) REFERENCES SportsDiscipline(SportsID)
)
GO

CREATE TABLE WorkOut(
WorkOutID INT IDENTITY(1,1) PRIMARY KEY,
AbonamentID INT NOT NULL, 
GroupID INT NOT NULL,
StartDate DATETIME NOT NULL,
EndDate DATETIME NOT NULL,
TrainerID INT NOT NULL,
RoomID INT NOT NULL,
CHECK (StartDate <= EndDate),
FOREIGN KEY(AbonamentID) REFERENCES Abonament(AbonamentID),
FOREIGN KEY(GroupID) REFERENCES GroupID(GroupID),
FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID),
FOREIGN KEY (RoomID) REFERENCES SportsRoom(RoomID)
ON DELETE CASCADE
)
GO

CREATE TABLE Lockers(
LockersID INT PRIMARY KEY
)
GO

CREATE TABLE LockersReservations(
ClientID INT NOT NULL,
LockersID INT NOT NULL,
StartDate DATETIME NOT NULL,
EndDate DATETIME NOT NULL,
FOREIGN KEY (LockersID) REFERENCES Lockers(LockersID),
FOREIGN KEY (ClientID) REFERENCES Client(ClientID),
CHECK (StartDate <= EndDate)
)

-- procedury

/*
1. procedura wstawia dane do tablicy Human, wartosci Phone oraz Mail moga byc NULL
*/
IF OBJECT_ID('InsertHuman', 'P') IS NOT NULL
    DROP PROCEDURE InsertHuman
GO
CREATE PROCEDURE InsertHuman(@Name VARCHAR(20), @SurName Varchar(20), @DateOfBirth DATE,
@Gender VARCHAR(1), @Address VARCHAR(50) ,  @Phone VARCHAR(50) = NULL, @Mail VARCHAR(50) = NULL ) AS
BEGIN
	--wstawic dane do tablicy Human
	INSERT INTO Human VALUES
		( @Name, @SurName, @DateOfBirth, @Gender, @Address );
		DECLARE @HumanID INT = SCOPE_IDENTITY()
	--wstawic dane do tablicy Phone
	IF @Phone IS NOT NULL 
		INSERT INTO Phone VALUES
			(@HumanID, @Phone)
	--wstawic dane do tablicy Mail
	IF @Mail IS NOT NULL 
		INSERT INTO Mail VALUES
			(@HumanID, @Mail)
	RETURN @HumanID
END
GO


/* 
2. procedura wstawia dane do tablicy Trainer oraz Human, zeby stworzyc nowego trenera
*/
IF OBJECT_ID('InsertTrainer', 'P') IS NOT NULL
    DROP PROCEDURE InsertTrainer
GO
CREATE PROCEDURE InsertTrainer( @Name VARCHAR(20), @SurName Varchar(20), @DateOfBirth DATE,
@Gender VARCHAR(1), @Address VARCHAR(50), @Specialization VARCHAR(20), @WorkingSince DATE,
@Salary Money, @Phone VARCHAR(50) = NULL, @Mail VARCHAR(50) = NULL) AS
BEGIN
	--wstawic dane do tablicy Human
	DECLARE @HumanID INT
	EXEC @HumanID = InsertHuman @Name, @SurName, @DateOfBirth, @Gender, @Address, @Phone, @Mail	
	--wstawic nowego trenera
	INSERT INTO Trainer Values
		(@HumanID, @Specialization, @WorkingSince, @Salary);
END
GO


/*
3. procedura wstawia dane do tablicy Client oraz Human, zeby stworzyc nowego klienta
*/
IF OBJECT_ID('InsertClient', 'P') IS NOT NULL
    DROP PROCEDURE InsertClient
GO
CREATE PROCEDURE InsertClient(@Name VARCHAR(20), @SurName Varchar(20), @DateOfBirth DATE,
@Gender VARCHAR(1), @Address VARCHAR(50) ,  @Phone VARCHAR(50) = NULL, @Mail VARCHAR(50) = NULL ) AS
BEGIN
	--wstawic dane do tablicy Human
	DECLARE @HumanID INT
	EXEC @HumanID = InsertHuman @Name, @SurName, @DateOfBirth, @Gender, @Address, @Phone, @Mail	
	-- wstawic nowego klienta
	INSERT INTO Client Values
		(@HumanID);
END
GO


/*
4. procedura rezerwuje szafke w podanym terminie, jezeli nie ma wolnej szafki w podanym
terminie to wypisuje blad rezerwacji
*/
IF OBJECT_ID('ReserveLocker', 'P') IS NOT NULL
    DROP PROCEDURE ReserveLocker
GO
CREATE PROCEDURE ReserveLocker(@ClientID INT, @Start DATETIME, @End DATETIME) AS
	BEGIN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRANSACTION
		DECLARE @LockersID INT = dbo.GetFreeLocker( @Start, @End )
		
		IF @LockersID IS NULL
			BEGIN
				PRINT 'Nie ma wolnych szafek, prosze wybrac inny termin'
				ROLLBACK
			END
		ELSE
			INSERT INTO LockersReservations VALUES
			(@ClientID, @LockersID, @Start, @End )
		COMMIT
	END
GO

/*
5. procedura wstawia nowe cwiczenie do historii odwiedzonych cwiczen
*/
IF OBJECT_ID('InsertWorkOut', 'P') IS NOT NULL
    DROP PROCEDURE InsertWorkOut
GO
CREATE PROCEDURE InsertWorkOut(@AbonamentID INT, @GroupID INT, @StartDate DATETIME, @EndDate DATETIME, 
								@TrainerID INT, @RoomID INT) AS
	BEGIN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRANSACTION
		DECLARE @CurrentVisitsNumber INT = (SELECT A.CurrentVisitsNumber FROM Abonament A
											WHERE A.AbonamentID = @AbonamentID)
		DECLARE @MaxVisitsNumber INT = (SELECT C.MaxVisitsNumber FROM
										(SELECT A.AbonamentTypeID FROM Abonament A
					 					WHERE A.AbonamentID = @AbonamentID) B JOIN AbonamentType C ON
									B.AbonamentTypeID = C.AbonamentTypeID)
		IF @MaxVisitsNumber IS NOT NULL
			BEGIN
				IF @MaxVisitsNumber <= @CurrentVisitsNumber
					BEGIN
						PRINT 'Blad:Maksymalna liczba odwiedzin'
						ROLLBACK
						RETURN
					END
			END
		INSERT INTO WorkOut VALUES
			(@AbonamentID, @GroupID, @StartDate, @EndDate, @TrainerID, @RoomID)
		UPDATE Abonament
			SET CurrentVisitsNumber = CurrentVisitsNumber + 1 
			WHERE Abonament.AbonamentID = @AbonamentID
	COMMIT
	END
GO
-- koniec procedur


--funkcji
/*
1. funkcja zwraca dane czlowieka z tablicy Human po jego indeksu
*/
IF OBJECT_ID('GetHumanData', 'IF') IS NOT NULL
    DROP FUNCTION GetHumanData
GO
CREATE FUNCTION GetHumanData(@HumanID INT) RETURNS TABLE AS RETURN(
	SELECT * FROM Human A 
	WHERE A.HumanID = @HumanID
)
GO

/*
2. funkcja zwraca numery oraz maile czlowieka z tablicy Human po jego HumanID
*/
IF OBJECT_ID('GetPhoneAndMail', 'IF') IS NOT NULL
    DROP FUNCTION GetPhoneAndMail
GO
CREATE FUNCTION GetPhoneAndMail(@HumanID INT) RETURNS TABLE AS RETURN(
	SELECT A.Phone FROM Phone A 
		WHERE A.HumanID = @HumanID
	UNION 
	SELECT B.Mail FROM Mail B
		WHERE B.HumanID = @HumanID
)
GO

/*
3. funkcja zwraca klientow do ktorych nalezy podany AbonamentID
*/
IF OBJECT_ID('GetAbonamentClient', 'IF') IS NOT NULL
    DROP FUNCTION GetAbonamentClient
GO
CREATE FUNCTION GetAbonamentClient(@AbonementID INT) RETURNS TABLE AS RETURN(
	SELECT B.Name, B.SurName, B.DateOfBirth, B.Gender, B.Address FROM
		(SELECT * FROM ClientAbonament A WHERE A.AbonamentID = @AbonementID) A LEFT JOIN
		Human B ON A.ClientID = B.HumanID
)
GO

/*
4. funkcja zwraca tablice cen od x(wlacznie) do y(wlacznie), gdzie AbonamentPriceBetween(x,y)
*/
IF OBJECT_ID('GetAbonamentPriceBetween', 'IF') IS NOT NULL
    DROP FUNCTION GetAbonamentPriceBetween
GO
CREATE FUNCTION GetAbonamentPriceBetween(@A SMALLMONEY, @B SMALLMONEY) RETURNS TABLE AS RETURN(
	SELECT C.Name, C.Price FROM AbonamentType C 
		WHERE C.Price >= @A AND C.Price <= @B
)
GO

/*
5. funkcja zwraca tablice sportow, ktore prowadza trener
*/
IF OBJECT_ID('GetTrainerSport', 'IF') IS NOT NULL
    DROP FUNCTION GetTrainerSport
GO
CREATE FUNCTION GetTrainerSport(@TrainerID INT) RETURNS TABLE AS RETURN(
	SELECT B.Name FROM (SELECT * FROM TrainerSD C WHERE C.TrainerID = @TrainerID) A JOIN 
	SportsDiscipline B
	ON A.SportsID = B.SportsID
)
GO

/*
6. funkcja zwraca tablice abonementow, ktore naleza do klienta
*/
IF OBJECT_ID('GetClientAbonament', 'IF') IS NOT NULL
    DROP FUNCTION GetClientAbonament
GO
CREATE FUNCTION GetClientAbonament(@ClientID INT) RETURNS TABLE AS RETURN(
	SELECT B.Name, B.Price, A.StartDate, A.EndDate,
	A.CurrentVisitsNumber[CurrentVisitsNumberOfAbonement], A.PaymentMethod FROM 
		(
		SELECT B.* FROM
			( SELECT A.AbonamentID FROM ClientAbonament A WHERE A.ClientID = @ClientID) A LEFT JOIN
			Abonament B ON A.AbonamentID = B.AbonamentID
		) A LEFT JOIN AbonamentType B ON A.AbonamentTypeID = B.AbonamentTypeID
)
GO

/*
7. funkcja zwraca sume dochodow w podanym przedziale czasowym 
*/
IF OBJECT_ID('GetIncome', 'FN') IS NOT NULL
    DROP FUNCTION GetIncome
GO
    CREATE FUNCTION GetIncome(@Start DATE, @End DATE) RETURNS MONEY
	BEGIN
		DECLARE @tmp MONEY = (SELECT SUM(B.Price) FROM Abonament A LEFT JOIN AbonamentType B
							ON A.AbonamentTypeID = B.AbonamentTypeID AND A.StartDate >= @Start
							AND A.StartDate <= @End
							)
		IF @tmp IS NULL
			BEGIN
				SET @tmp = 0
			END
        RETURN @tmp
			
    END
GO

/*
8. funkcja zwraca wolna szafke w podanym terminie lub NULL jezeli nie ma wolnej szafki,
*UWAGA jak nie ma wolnej szafki w podanym terminie to zwraca NULL
*/
IF OBJECT_ID('GetFreeLocker', 'FN') IS NOT NULL
    DROP FUNCTION GetFreeLocker
GO
    CREATE FUNCTION GetFreeLocker(@Start DATETIME, @End DATETIME) RETURNS INT
	BEGIN
		DECLARE @tmp INT = (SELECT TOP(1) A.LockersID FROM Lockers A
							WHERE A.LockersID NOT IN
									(SELECT A.LockersID FROM LockersReservations A 
									WHERE ( A.EndDate <= @End ) OR (A.StartDate <= @Start)
									)
							)
        RETURN @tmp
			
    END
GO

/*
9. funkcja zwraca tablice szafek zarezerwowanych przez klienta
*/
IF OBJECT_ID('GetClientLockersReserv', 'IF') IS NOT NULL
    DROP FUNCTION GetClientLockersReserv
GO
    CREATE FUNCTION GetClientLockersReserv(@ClientID INT) RETURNS TABLE AS RETURN(
		SELECT A.LockersID, A.StartDate, A.EndDate  FROM LockersReservations A
			WHERE A.ClientID = @ClientID
	)
GO
-- koniec funkcji

-- widoki
/*
1. widok zwraca typy sprzedanych abonamentow oraz dochod dla kazdego typu
*/
IF OBJECT_ID('NumberSoldAbonement', 'V') IS NOT NULL
DROP VIEW NumberSoldAbonement
GO
CREATE VIEW NumberSoldAbonement AS
SELECT B.Name, SUM(B.Price)[Income] FROM Abonament A JOIN AbonamentType B
	ON A.AbonamentTypeID = B.AbonamentTypeID
	GROUP BY B.AbonamentTypeID, B.Name
GO
-- koniec widokow


--wyzwalaczy
/*
1. wyzwalacz zwieksza cene abonamentu o wartosc podatkow( zakladam podatki 20% ) AbonamentType
UWAGA zakladam ze coraz wpisuje dokladnie jedena wartosc (SportsID, Name, Price, MAXVisitsNumber)
*/
IF OBJECT_ID('AbonamentTypePriceModyfi', 'TR') IS NOT NULL
    DROP TRIGGER AbonamentTypePriceModyfi
GO
CREATE TRIGGER AbonamentTypePriceModyfi
	ON AbonamentType
	AFTER INSERT, UPDATE
	AS
	BEGIN
		UPDATE AbonamentType 
		 SET Price = Price + 0.2*Price
		 WHERE AbonamentTypeID = (SELECT AbonamentTypeID FROM inserted)
	END
		
GO

/*
2. wyzwalacz sprawdza czy wszystkie dane zostaly wpisane do tablicy AbonamentType
UWAGA zakladam ze coraz wpisuje dokladnie jedena wartosc
*/
IF OBJECT_ID('AbonamentTypeIntegrity', 'TR') IS NOT NULL
    DROP TRIGGER AbonamentTypeIntegrity
GO
CREATE TRIGGER AbonamentTypeIntegrity
	ON AbonamentType
	AFTER INSERT
	AS
	BEGIN
		 IF (SELECT A.AbonamentTypeID
                FROM AbonamentType A JOIN inserted B
                ON A.AbonamentTypeID = B.AbonamentTypeID) IS NULL
        BEGIN
            ROLLBACK TRANSACTION
            PRINT 'dane nie zostaly wpisane do tablicy AbonamentType'
        END
        ELSE 
            PRINT 'dane zostaly wpisane do tablicy AbonamentType'
	END
		
GO

/*
3. wyzwalacz sprawdza czy wszystkie dane zostaly wpisane do tablicy WorkOut
UWAGA zakladam ze coraz wpisuje dokladnie jedena wartosc
*/
IF OBJECT_ID('WorkOutIntegrity', 'TR') IS NOT NULL
    DROP TRIGGER WorkOutIntegrity
GO
CREATE TRIGGER WorkOutIntegrity
	ON WorkOut
	AFTER INSERT
	AS
	BEGIN
		 IF (SELECT A.WorkOutID
                FROM WorkOut A JOIN inserted B
                ON A.WorkOutID = B.WorkOutID) IS NULL
        BEGIN
            ROLLBACK TRANSACTION
            PRINT 'dane nie zostaly wpisane do tablicy WorkOut'
        END
        ELSE 
            PRINT 'dane zostaly wpisane do tablicy WorkOut'
	END
	
GO

/*
4. wyzwalacz sprawdza czy wszystkie dane zostaly wpisane do tablicy Client
UWAGA zakladam ze coraz wpisuje dokladnie jedena wartosc
*/
IF OBJECT_ID('ClientIntegrity', 'TR') IS NOT NULL
    DROP TRIGGER ClientIntegrity
GO
CREATE TRIGGER ClientIntegrity
	ON Client
	AFTER INSERT
	AS
	BEGIN
		 IF (SELECT A.ClientID
                FROM Client A JOIN inserted B
                ON A.ClientID = B.ClientID) IS NULL
        BEGIN
            ROLLBACK TRANSACTION
            PRINT 'dane nie zostaly wpisane do tablicy Client'
        END
        ELSE 
            PRINT 'dane zostaly wpisane do tablicy Client'
	END
	
GO

/*
5. wyzwalacz sprawdza czy wszystkie dane zostaly wpisane do tablicy Trainer
UWAGA zakladam ze coraz wpisuje dokladnie jedena wartosc
*/
IF OBJECT_ID('TrainerIntegrity', 'TR') IS NOT NULL
    DROP TRIGGER TrainerIntegrity
GO
CREATE TRIGGER TrainerIntegrity
	ON Trainer
	AFTER INSERT
	AS
	BEGIN
		 IF (SELECT A.TrainerID
                FROM Trainer A JOIN inserted B
                ON A.TrainerID = B.TrainerID) IS NULL
        BEGIN
            ROLLBACK TRANSACTION
            PRINT 'dane nie zostaly wpisane do tablicy Trainer'
        END
        ELSE 
            PRINT 'dane zostaly wpisane do tablicy Trainer'
	END
	
GO

--koniec wyzwalaczy










