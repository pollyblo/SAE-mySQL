/* 2023-01-08 13:12:00 [14 ms] */

CREATE DATABASE IF NOT EXISTS SAE_DB;

/* 2023-01-08 13:21:36 [17 ms] */

DROP TABLE IF EXISTS Salle CASCADE;

/* 2023-01-08 13:21:38 [31 ms] */

DROP TABLE IF EXISTS ELP CASCADE;

/* 2023-01-08 13:21:38 [18 ms] */

DROP TABLE IF EXISTS Groupes CASCADE;

/* 2023-01-08 13:21:39 [23 ms] */

DROP TABLE IF EXISTS Reservation CASCADE;

/* 2023-01-08 13:21:58 [68 ms] */

CREATE TABLE
    Salle (
        NoSalle VARCHAR(8) PRIMARY KEY,
        Categorie VARCHAR(16) NOT NULL,
        NbPlaces SMALLINT NOT NULL
    );

CREATE TABLE
    Groupes (
        Groupe VARCHAR(16) NOT NULL,
        Formation VARCHAR(16) NOT NULL,
        Effectif SMALLINT CHECK (Effectif >= 0),
        PRIMARY KEY (Groupe, Formation)
    );

CREATE TABLE
    ELP (
        CodeELP SMALLINT PRIMARY KEY,
        NomELP VARCHAR(32) NOT NULL,
        Formation VARCHAR(16) REFERENCES Groupes(Formation),
        HC SMALLINT NOT NULL CHECK (HC >= 0),
        HTD SMALLINT NOT NULL CHECK (HTD >= 0),
        HTP SMALLINT NOT NULL CHECK (HTP >= 0),
        HCRes SMALLINT DEFAULT 0 NOT NULL CHECK (HCRes >= 0),
        HTDRes SMALLINT DEFAULT 0 NOT NULL CHECK (HTDRes >= 0),
        HTPRes SMALLINT DEFAULT 0 NOT NULL CHECK (HTPRes >= 0)
    );

CREATE TABLE
    Reservation (
        NoReservation INT AUTO_INCREMENT PRIMARY KEY,
        NoSalle SMALLINT REFERENCES Salle(NoSalle),
        CodeELP SMALLINT REFERENCES ELP(CodeELP),
        Groupe VARCHAR(16) NOT NULL REFERENCES Groupes(Groupe),
        Formation VARCHAR(16) NOT NULL REFERENCES Groupes(Formation),
        Nature VARCHAR(16) NOT NULL,
        Debut DATETIME NOT NULL,
        Duree SMALLINT NOT NULL CHECK (Duree >= 0)
    );/* 2023-01-15 15:44:24 [16 ms] */ 
CREATE PROCEDURE MAJGROUPE(GPE VARCHAR(16), FORMA VARCHAR
(16), EFF SMALLINT) 
BEGIN 
    IF (
          SELECT COUNT(*)
          FROM `Groupes`
          WHERE
              Groupe = GPE
              AND Formation = FORMA
      ) > 0 THEN 
            IF (EFF >= 0) THEN
              UPDATE Groupes
              SET Effectif = EFF
              WHERE
                  Groupe = GPE
                  AND Formation = FORMA;
            ELSE
              DELETE
                  Groupes,
                  Reservation
              FROM Groupes
                  INNER JOIN Reservation ON Groupes.Groupe = Reservation.Groupe AND Groupes.Formation = Reservation.Formation
              WHERE
                  Groupe = GPE
                  AND Formation = FORMA;
            END IF;
    ELSE 
        IF (EFF >= 0) THEN
            INSERT INTO
                Groupes(Groupe, Formation, Effectif)
            VALUES (GPE, FORMA, EFF);
        END IF;
    END IF;
END;
