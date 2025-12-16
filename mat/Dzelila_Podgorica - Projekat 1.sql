CREATE DATABASE DARIVANJEKRVI;
USE DARIVANJEKRVI;

CREATE TABLE DARIVAOC(
JMBG char(13) PRIMARY KEY NOT NULL,
Krvna_grupa char(3) NOT NULL CHECK (Krvna_grupa IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')), 
Ime varchar(50) NOT NULL,
Ime_oca varchar(20) NOT NULL,
Email varchar(50) NOT NULL UNIQUE,
Adresa varchar(50) NOT NULL,
Spol char(1) CHECK (Spol IN('Z','M')),
Tezina decimal(4,1) CHECK (Tezina>=50),
--Datum_posljednje_donacije date DEFAULT NULL
Datum_rodjenja date CHECK (DATEDIFF(day, Datum_rodjenja, GETDATE()) >= 6570));

CREATE TABLE ODGOVORNI(
Id int IDENTITY(1,1) PRIMARY KEY,
Ime varchar(50) NOT NULL,
Strucnost varchar(50) CHECK(Strucnost IN ('Doktor', 'Tehnicar', 'Medicinska sestra')));

CREATE TABLE BANKA(
Id int IDENTITY(1,1) PRIMARY KEY,
Naziv varchar(50) NOT NULL,
Grad varchar(30),
Adresa varchar(40)
);

CREATE TABLE TESTIRANJE_DARIVAOCA(
Id_testa_darivaoca int IDENTITY(1,1) PRIMARY KEY,
JMBG char(13) NOT NULL,
Gornji_krvni_pritisak int CHECK (Gornji_krvni_pritisak BETWEEN 90 AND 180) NOT NULL,
Donji_krvni_pritisak int CHECK (Donji_krvni_pritisak BETWEEN 50 AND 100) NOT NULL,
Otkucaji_srca int CHECK (Otkucaji_srca BETWEEN 50 AND 100) NOT NULL,
Hemoglobin int NOT NULL CHECK(Hemoglobin>=130),
CONSTRAINT fkjmbg FOREIGN KEY(JMBG) REFERENCES DARIVAOC(JMBG) ON DELETE NO ACTION ON UPDATE NO ACTION 
);

CREATE TABLE DARIVANJE( 
Broj_darivanja varchar(20) PRIMARY KEY NOT NULL, 
Id_testa_darivaoca int NOT NULL UNIQUE,
Kolicina int DEFAULT 450,  
Odgovorni int NOT NULL, 
Datum date DEFAULT GETDATE(), 
Banka int NOT NULL, 
CONSTRAINT fkodgovorni FOREIGN KEY (Odgovorni) REFERENCES ODGOVORNI(Id) ON DELETE NO ACTION ON UPDATE NO ACTION, 
CONSTRAINT fkbanka FOREIGN KEY (Banka) REFERENCES BANKA(Id) ON DELETE NO ACTION ON UPDATE NO ACTION,
CONSTRAINT fktest FOREIGN KEY (Id_testa_darivaoca) REFERENCES TESTIRANJE_DARIVAOCA(Id_testa_darivaoca) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE TESTIRANJE_KRVI(
Broj_darivanja varchar(20) PRIMARY KEY NOT NULL, --UNIQUE da nije bio primarni kljuc
Parvovirus bit DEFAULT 0,
HepatitisA bit DEFAULT 0,
HepatitisB bit DEFAULT 0,
HepatitisC bit DEFAULT 0,
HepatitisE bit DEFAULT 0,
HIV bit DEFAULT 0,
Sifilis bit DEFAULT 0,
ZIKA_virus bit DEFAULT 0,
CONSTRAINT testiranjedarivanja FOREIGN KEY(Broj_darivanja) REFERENCES DARIVANJE(Broj_darivanja) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE ZABRANA (
    Id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    JMBG char(13) NOT NULL,
    Datum_pocetka_zabrane date NOT NULL DEFAULT GETDATE(),
    Datum_kraja_zabrane date NOT NULL,
	CONSTRAINT chk_datum CHECK (Datum_kraja_zabrane > Datum_pocetka_zabrane),
    CONSTRAINT zabranajmbg FOREIGN KEY (JMBG) REFERENCES DARIVAOC(JMBG) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE NONCLUSTERED INDEX darivaoc_krvna_grupa ON DARIVAOC(Krvna_grupa);
CREATE NONCLUSTERED INDEX banka_grad ON BANKA(Grad);

INSERT INTO DARIVAOC (JMBG, Krvna_grupa, Ime, Ime_oca, Email, Adresa, Spol, Tezina, Datum_rodjenja) VALUES
('0101199912345', 'A+', 'Amna Hasanovic', 'Harun', 'amnah@gmail.com', 'Vrbovksa 115', 'Z', 62, '1999-01-01'),
('1505199823456', 'B-', 'Ana Simonovic', 'Petar', 'anas@gmail.com', 'Otes 12', 'Z', 60, '1998-05-15'),
('2011199656789', 'B+', 'Danin Alagic', 'Elvedin', 'danina@gmail.com', 'Sime Milutinovica 236', 'Z', 90, '1996-11-20'),
('2206199734567', 'O+', 'Amin Bajramovic', 'Ferid', 'aminb@gmail.com', 'Vrbovska 281', 'M', 80, '1997-06-22'),
('3007199656789', 'AB+', 'Sara Fazlic', 'Mehdija', 'saras@gmail.com', 'Novopazarska 4', 'Z', 65, '1996-07-30'),
('1208199845678', 'A+', 'Hamza Poturak', 'Nurudin', 'hamzap@gmail.com', 'Put mladih muslimana 10', 'M', 85, '1998-08-12');

INSERT INTO ODGOVORNI(Ime, Strucnost) VALUES
('Alem Zec', 'Doktor'),
('Edo Gugic', 'Tehnicar'),
('Adisa Pandzo', 'Doktor'),
('Merima Gugic', 'Medicinska sestra'),
('Saima Poturak', 'Tehnicar');

INSERT INTO BANKA (Naziv, Grad, Adresa) VALUES
('Banka Krvi Sarajevo', 'Sarajevo', 'Zmaja od Bosne 5'),
('Banja Luka Centar Krvi', 'Banja Luka', 'Kralja Petra I 12'),
('Mostar Regionalna Banka Krvi', 'Mostar', 'Rudarska 25'),
('Tuzla Zavod za Transfuziju', 'Tuzla', 'Mije Keroševića 7'),
('Zenica Banka Krvi', 'Zenica', 'Fabricka 14');

INSERT INTO TESTIRANJE_DARIVAOCA (JMBG, Gornji_krvni_pritisak, Donji_krvni_pritisak, Otkucaji_srca, Hemoglobin) VALUES
('0101199912345', 120, 80, 72, 140),
('1505199823456', 115, 75, 68, 135),
('2206199734567', 130, 85, 75, 150),
('3007199656789', 110, 70, 65, 145),
('1208199845678', 125, 82, 70, 138),
('2206199734567', 135, 85, 70, 145),
('1505199823456', 115, 75, 68, 135),
('2206199734567', 130, 85, 75, 150),
('3007199656789', 110, 70, 65, 145),
('1208199845678', 125, 82, 70, 138);

INSERT INTO ZABRANA(JMBG, Datum_pocetka_zabrane, Datum_kraja_zabrane) VALUES
('0101199912345', '2025-02-02', '2025-03-02'),
('1505199823456', '2024-08-02', '2024-08-17'),
('2206199734567', '2023-06-02', '2023-06-22'),
('3007199656789', '2024-08-18', '2024-09-05'),
('2206199734567', '2024-09-22', '2024-10-10');

INSERT INTO DARIVANJE(Broj_darivanja, Id_testa_darivaoca, Kolicina, Odgovorni, Datum, Banka) VALUES
('12547-21', 1, 450, 1, '2025-03-07', 1),
('12547-22', 2, 450, 2, '2025-03-07', 2),
('12547-23', 3, 450, 3, '2024-05-07', 3),
('12547-24', 4, 440, 2, '2025-03-07', 4),
('12547-25', 5, 450, 4, '2025-03-07', 5),
('12547-26', 6, 450, 4, '2025-04-07', 5),
('12547-27', 7, 450, 2, '2025-11-09', 2),
('12547-28', 8, 450, 3, '2025-05-09', 3),
('12547-29', 9, 440, 2, '2025-11-09', 4),
('12547-30', 10, 450, 4, '2025-11-09', 5);

INSERT INTO TESTIRANJE_KRVI (Broj_darivanja, Parvovirus, HepatitisA, HepatitisB, HepatitisC, HepatitisE, HIV, Sifilis, ZIKA_virus) VALUES
('12547-21', 0, 0, 0, 0, 0, 0, 0, 0),
('12547-22', 0, 1, 0, 0, 0, 0, 0, 0),
('12547-23', 0, 0, 0, 0, 0, 0, 0, 0),
('12547-24', 0, 0, 0, 0, 0, 1, 0, 0),
('12547-25', 0, 0, 0, 0, 0, 0, 0, 0),
('12547-26', 0, 1, 0, 0, 0, 0, 0, 0),
('12547-27', 0, 0, 0, 0, 0, 0, 0, 0),
('12547-28', 0, 0, 0, 0, 0, 0, 0, 0),
('12547-29', 0, 0, 0, 0, 0, 0, 0, 0),
('12547-30', 0, 0, 0, 0, 0, 0, 0, 0);

--Ispisuje darivaoce pozitivne na HIV INNER JOIN
SELECT D.Ime+' ('+D.Ime_oca+')' AS Ime_darivaoca, TK.HIV FROM DARIVAOC AS D 
INNER JOIN TESTIRANJE_DARIVAOCA AS TD ON D.JMBG=TD.JMBG
INNER JOIN DARIVANJE ON DARIVANJE.Id_testa_darivaoca=TD.Id_testa_darivaoca
INNER JOIN TESTIRANJE_KRVI AS TK ON DARIVANJE.Broj_darivanja=TK.Broj_darivanja
WHERE TK.HIV=1;

--Za koliko donacija je odgovoran svaki od odgovornih RIGHT JOIN
SELECT O.Id, O.Ime, O.Strucnost, COUNT(D.Broj_darivanja) AS Broj_darivanja
FROM DARIVANJE AS D
RIGHT JOIN ODGOVORNI AS O ON D.Odgovorni = O.Id
GROUP BY O.Id, O.Ime, O.Strucnost;

--Kolicina krvi po Banci LEFT JOIN
SELECT B.Id, B.Naziv, SUM(D.Kolicina) FROM BANKA AS B LEFT JOIN DARIVANJE AS D ON D.Banka=B.Id GROUP BY B.Id, B.Naziv;

--Svi darivaoci koji nikada nisu imali zdravstvenih prepreka za darivanje krvi LEFT JOIN
SELECT D.Ime, D.Ime_oca
FROM DARIVAOC AS D
LEFT JOIN ZABRANA AS Z ON D.JMBG = Z.JMBG
WHERE Z.JMBG IS NULL;

--Prosjecna kolicina hemoglobina AVG
SELECT AVG(Hemoglobin) FROM TESTIRANJE_DARIVAOCA;

--Minimalna kolicina krvi darovana, zbog odredjenih okolnosti MIN
SELECT MIN(Kolicina) FROM  DARIVANJE;

--Najveci hemoglobin izmjeren MAX
SELECT DISTINCT D.Ime, TD.Hemoglobin
FROM DARIVAOC AS D
INNER JOIN TESTIRANJE_DARIVAOCA AS TD ON D.JMBG = TD.JMBG
WHERE TD.Hemoglobin = (SELECT MAX(Hemoglobin) FROM TESTIRANJE_DARIVAOCA);

--Ukupna kolicina krvi u po krvnoj grupi SUM
SELECT DA.Krvna_grupa, SUM(D.Kolicina) AS Ukupna_kolicina
FROM DARIVANJE D 
INNER JOIN TESTIRANJE_DARIVAOCA TD ON TD.Id_testa_darivaoca=D.Id_testa_darivaoca
INNER JOIN DARIVAOC DA ON DA.JMBG=TD.JMBG
GROUP BY DA.Krvna_grupa;

--Banke krvi koje su primile više od bilo koje jedne donacije ANY
SELECT B.Id, COUNT(*) AS Broj_darivanja from BANKA AS B INNER JOIN DARIVANJE AS D ON B.Id=D.Banka
GROUP BY B.Id HAVING COUNT(*)>ANY(SELECT COUNT(*) FROM DARIVANJE GROUP BY(Banka));

--Darivaoci koji su imali najvise darivanja COUNT, ALL
SELECT D.JMBG, COUNT(*) AS Broj_testiranja
FROM DARIVAOC AS D
INNER JOIN TESTIRANJE_DARIVAOCA AS TD ON D.JMBG = TD.JMBG
GROUP BY D.JMBG HAVING COUNT(*) >= ALL (
    SELECT COUNT(*) FROM TESTIRANJE_DARIVAOCA GROUP BY JMBG
);

--Ispisuje darivaoce koji su imali barem dva darivanja i mogu dobiti voznju zicarom na Trebevic i one koji su imali manje od dva CASE
SELECT D.JMBG, MAX(D.Ime+' ('+D.Ime_oca+')') AS Ime_darivaoca,
CASE
	WHEN COUNT(*)>=2 THEN 'Zadovoljava uslove za besplatnu voznju zicarom na Trebevic'
	ELSE 'Ne zadovoljava uslove za besplatnu voznju zicarom na Trebevic'
END AS Voznja_zicarom
FROM DARIVAOC AS D 
INNER JOIN TESTIRANJE_DARIVAOCA AS TD ON D.JMBG=TD.JMBG
INNER JOIN DARIVANJE ON DARIVANJE.Id_testa_darivaoca=TD.Id_testa_darivaoca
GROUP BY D.JMBG;

--Javit ce nam gresku
UPDATE DARIVAOC SET JMBG='1505199823457' WHERE JMBG='1505199823456';
--Validno samo ako ima JMBG u roditejskoj tabeli koji odgovara zamijenjenom
UPDATE TESTIRANJE_DARIVAOCA SET JMBG='1505199823457' WHERE JMBG='1505199823456';
--Ali ako postoji JMBG u roditeljskoj tabeli onda ce moci
UPDATE TESTIRANJE_DARIVAOCA SET JMBG='3007199656789' WHERE JMBG='1505199823456'; --Paziti da li su prosla 4 mjeseca

--Pokusaj brisanja testiranja darivaoca je besmislen jer se prije svakog darivanja mora izvrsiti ova provjera, na osnovu toga i on delete no action dobit cemo gresku kod ove komande
DELETE FROM TESTIRANJE_DARIVAOCA WHERE JMBG='3007199656789';

--Brisanje zavisnih/child tabela je validno
DELETE FROM TESTIRANJE_KRVI WHERE Broj_darivanja='12547-30';