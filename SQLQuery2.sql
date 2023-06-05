CREATE DATABASE MoviesApp 

USE MoviesApp

CREATE TABLE Directors (
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(50),
	Surname NVARCHAR(50)
)

CREATE TABLE Movies (
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(50),
	Descripion NVARCHAR(255),
	CoverPhoto NVARCHAR(50),
	LanguageId INT FOREIGN KEY REFERENCES Languages(Id),
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id)
)

CREATE TABLE Languages (
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(50)
)

CREATE TABLE Genres (
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(50)
)


-- Many to many
CREATE TABLE MoviesGenres (
	Id INT IDENTITY PRIMARY KEY,
	MovieId INT FOREIGN KEY REFERENCES Movies(Id),
	GenreId INT FOREIGN KEY REFERENCES Genres(Id)
)

CREATE TABLE Actors (
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(50),
	Surname NVARCHAR(50)
)


-- Many to many
CREATE TABLE MoviesActors (
	Id INT IDENTITY PRIMARY KEY,
	MovieId INT FOREIGN KEY REFERENCES Movies(Id),
	ActorId INT FOREIGN KEY REFERENCES Actors(Id)
)


INSERT INTO Directors 
VALUES ('d.name1', 'd.surname1'),
		('d.name2', 'd.surname2'),
		('d.name3', 'd.surname3');

INSERT INTO Genres 
VALUES ('genre1'),
		('genre2'),
		('genre3');

INSERT INTO Actors 
VALUES ('a.name1', 'a.surname1'),
		('a.name2', 'a.surname2'),
		('a.name3', 'a.surname3');


INSERT INTO Languages 
VALUES ('l1'),
		('l2'),
		('l3');

INSERT INTO Movies 
VALUES ('m.name1', 'desc', 'img.jpg', 1, 1),
	   ('m.name2', 'desc2', 'img.jpg', 3, 1),
	   ('m.name3', 'desc3', 'img.jpg', 2, 2)

INSERT INTO MoviesActors
VALUES (1,2),
	   (2,1),
	   (3,3),
	   (2,1),
	   (3,3)

INSERT INTO MoviesGenres
VALUES (1,3),
	   (1,1),
	   (1,2),
	   (2,1),
	   (3,3)

CREATE PROCEDURE GetMoviesByDirector
  @directorId INT
AS
BEGIN
  SELECT m.Name AS MovieName, l.Name AS Language
  FROM Movies m
  INNER JOIN Directors d ON d.Id = m.DirectorId
  INNER JOIN Languages l ON l.Id = m.LanguageId
  WHERE d.Id = @directorId;
END



CREATE FUNCTION GetMovieCountByLanguage
(
  @languageId INT
)
RETURNS INT
AS
BEGIN
  DECLARE @count INT;

  SELECT @count = COUNT(*)
  FROM Movies
  WHERE LanguageId = @languageId;

  RETURN @count;
END


CREATE PROCEDURE GetMoviesAndDirectorByGenre
  @genreId INT
AS
BEGIN
  SELECT m.Name AS MovieName, d.Name AS DirectorName
  FROM Movies m
  INNER JOIN Directors d ON d.Id = m.DirectorId
  INNER JOIN MoviesGenres mg ON mg.MovieId = m.Id
  WHERE mg.GenreId = @genreId;
END



CREATE FUNCTION CheckActorMovieCount
(
  @actorId INT
)
RETURNS BIT
AS
BEGIN
  DECLARE @count INT;

  SELECT @count = COUNT(*)
  FROM MoviesActors
  WHERE ActorId = @actorId;

  IF @count > 3
    RETURN 1;
  
  RETURN 0;
END


CREATE TRIGGER DisplayMovieDetails
ON Movies
AFTER INSERT
AS
BEGIN
  SELECT m.Name AS MovieName, d.Name AS DirectorName, l.Name AS Language
  FROM Movies m
  INNER JOIN Directors d ON d.Id = m.DirectorId
  INNER JOIN Languages l ON l.Id = m.LanguageId
  WHERE m.Id IN (SELECT Id FROM inserted);
END





