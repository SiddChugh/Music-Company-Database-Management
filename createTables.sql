CREATE TABLE Artist (
aname CHAR(20),
startdate DATETIME,
genre CHAR(20),
PRIMARY KEY (aname) )

CREATE TABLE Musician (
msin CHAR(9),
fname CHAR(20),
lname CHAR(20) NOT NULL,
instrument CHAR(20),
email CHAR(20),
CONSTRAINT unique_email UNIQUE (email)
PRIMARY KEY (msin) )

CREATE TABLE Plays (
aname CHAR(20),
msin CHAR(9),
share FLOAT,
FOREIGN KEY (aname) REFERENCES Artists,
FOREIGN KEY (msin) REFERENCES Musician,
PRIMARY KEY ( (aname,msin) )

CREATE TABLE Song (
isrc CHAR(12),
title CHAR(20),
year INTEGER,
Duration FLOAT,
album CHAR(20),
aname CHAR(20) NOT NULL,
FOREIGN KEY (aname) REFERENCES Artists,
PRIMARY KEY ( isrc) )

CREATE TABLE Writer (
wsin CHAR(9),
fname CHAR(20),
lname CHAR(20) NOT NULL,
PRIMARY KEY ( wsin) )

CREATE TABLE Writes (
isrc CHAR(12),
wsin CHAR(9),
royalty FLOAT,
FOREIGN KEY (isrc) REFERENCES Song,
FOREIGN KEY (wsin) REFERENCES Writer,
PRIMARY KEY ( (isrc, wsin) )

CREATE TABLE SALES (
month CHAR(9),
year INTEGER,
vendor CHAR(20),
country CHAR(20),
amount FLOAT,
quantity INTEGER,
isrc CHAR(12),
PRIMARY KEY (month,vendor,country,isrc),
FOREIGN KEY (isrc) REFERENCES Song ON DELETE CASCADE)

CREATE TABLE Rep (
rsin CHAR(12),
fname CHAR(20),
lname CHAR(20) NOT NULL,
studio CHAR(20),
phone CHAR(10),
aname CHAR(20) NOT NULL,
msin CHAR(9) NOT NULL,
FOREIGN KEY (aname) REFERENCES Artists,
FOREIGN KEY (msin) REFERENCES Musicians,
PRIMARY KEY (rsin,msin,aname) )
