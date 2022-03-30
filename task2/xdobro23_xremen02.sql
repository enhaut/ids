DROP TABLE zivocich CASCADE CONSTRAINTS;

DROP TABLE umiestnenie CASCADE CONSTRAINTS;
DROP TABLE bol_umiestneny CASCADE CONSTRAINTS;

DROP TABLE vlastnost CASCADE CONSTRAINTS;
DROP TABLE typ_vlastnosti;

DROP TABLE typ_zivocicha;
DROP TABLE trieda_zivocicha;
DROP TABLE druh_zivocicha;
DROP TABLE rad_zivocicha;
DROP TABLE celad_zivocicha;
DROP TABLE rod_zivocicha;

DROP TABLE zamestnanec CASCADE CONSTRAINTS;
DROP TABLE pozicia;

DROP TABLE osetruje CASCADE CONSTRAINTS;
DROP TABLE klietka CASCADE CONSTRAINTS;


CREATE TABLE zivocich
(
    ID_zivocicha    INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    meno            VARCHAR2(64)    NOT NULL,
    datum_narodenia DATE            NOT NULL,
    datum_umrtia    DATE,

    ID_typu         INT             NOT NULL,

    CHECK ( datum_umrtia >= datum_narodenia ),
    PRIMARY KEY (ID_zivocicha)
);

-- Generalizovane entity `Pavilon` a `Vybeh` sme zlucili do entity `Umiestnenie`
-- pretoze su totalne a disjunktne.
-- Taktiez sme pridali integritne obmedzenie (`CHECK`), ktore kontroluje,
-- ze je zadana bud `interakcia` ak ide o vybeh alebo su vyplnene OBA atributy
-- `teplota` a `vlhost` ak ide o pavilon, nebolo teda treba pridavat dodatocny
-- atribut `typ`, ktory by rozlisoval, ci sa jedna o `Pavilon` alebo `Vybeh`.
CREATE TABLE umiestnenie
(
    ID_umiestnenia  INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nazov          VARCHAR2(64)             NOT NULL,
    vyuzitelna_plocha         INT           NOT NULL,

    --vybeh
    interakcia              NUMBER(1,0),

    -- pavilon
    teplota                 FLOAT,
    vlhkost                 INT,

    CHECK (interakcia IS NULL OR (teplota IS NULL AND vlhkost IS NULL)), -- kontrola specializacie
    PRIMARY KEY (ID_umiestnenia)
);

CREATE TABLE klietka
(
    ID_klietky      INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nazov           VARCHAR2(64) NOT NULL,
    kod_zamku       NUMBER(6) NOT NULL,

    ID_pavilonu     INT NOT NULL,

    CONSTRAINT FK_pavilonu FOREIGN KEY (ID_pavilonu) REFERENCES umiestnenie ON DELETE CASCADE,
    PRIMARY KEY (ID_pavilonu, ID_klietky) -- diskriminator
);


CREATE TABLE bol_umiestneny
(
    ID_zivocicha    INT             NOT NULL,
    ID_umiestnenia  INT             NOT NULL,
    ID_zamestnanca  INT, --moze byt null, ak by sa zamestnanec prepustil

    od              DATE            NOT NULL,
    do              DATE,

    CHECK ( od <= do ),
    PRIMARY KEY (ID_zivocicha, ID_umiestnenia)
);

CREATE TABLE vlastnost
(
    ID_merania      INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    hodnota         VARCHAR2(256)   NOT NULL,
    datum           DATE            NOT NULL,

    ID_zivocicha    INT             NOT NULL,
    ID_zamestnanca  INT,  -- moze byt null, ked niekoho prepustime, zaznam sa vymaze spolu so zivocichom
    ID_vlastnosti   INT            NOT NULL,

    PRIMARY KEY (ID_merania)
);

CREATE TABLE typ_vlastnosti
(
    ID_vlastnosti   INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nazov           VARCHAR2(64)    NOT NULL,
    popis           VARCHAR2(256),

    PRIMARY KEY (ID_vlastnosti)
);

CREATE TABLE typ_zivocicha
(
    ID_typu         INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,

    ID_triedy       INT             NOT NULL,
    ID_druhu        INT             NOT NULL,
    ID_radu         INT             NOT NULL,
    ID_celade       INT             NOT NULL,
    ID_rodu         INT             NOT NULL,

    PRIMARY KEY (ID_typu),
    UNIQUE (ID_triedy, ID_druhu, ID_radu, ID_celade, ID_rodu)
);

CREATE TABLE trieda_zivocicha
(
    ID_triedy       INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nazov           VARCHAR2(64)    NOT NULL,
    popis           VARCHAR2(256),

    PRIMARY KEY (ID_triedy)
);


CREATE TABLE druh_zivocicha
(
    ID_druhu       INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nazov          VARCHAR2(64)    NOT NULL,
    popis          VARCHAR2(256),

    PRIMARY KEY (ID_druhu)
);


CREATE TABLE rad_zivocicha
(
    ID_radu       INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nazov         VARCHAR2(64)    NOT NULL,
    popis         VARCHAR2(256),

    PRIMARY KEY (ID_radu)
);


CREATE TABLE celad_zivocicha
(
    ID_celade       INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nazov           VARCHAR2(64)    NOT NULL,
    popis           VARCHAR2(256),

    PRIMARY KEY (ID_celade)
);


CREATE TABLE rod_zivocicha
(
    ID_rodu         INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nazov           VARCHAR2(64)    NOT NULL,
    popis           VARCHAR2(256),

    PRIMARY KEY (ID_rodu)
);


CREATE TABLE zamestnanec
(
    ID_zamestnanca  INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    meno            VARCHAR2(64)    NOT NULL,
    priezvisko      VARCHAR2(64)    NOT NULL,
    heslo           VARCHAR2(256)   NOT NULL,
    rodne_cislo     VARCHAR2(11),  -- moze byt cudzinec, ten RC nema
    pozicia         INT,


    CHECK ( REGEXP_LIKE(rodne_cislo, '^\d{2}(0[1-9]|1[0-2]|5[1-9]|6[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])/\d{3,4}$') ),
    CHECK ( MOD(TO_NUMBER(REPLACE(rodne_cislo, '/', '')), 11) = 0 ),
    PRIMARY KEY (ID_zamestnanca)
);

CREATE TABLE pozicia
(
    ID_pozicie      INT             GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nazov           VARCHAR2(64)    NOT NULL,
    napln_prace     VARCHAR2(256)   NOT NULL,

    PRIMARY KEY (ID_pozicie)
);
ALTER TABLE zamestnanec ADD CONSTRAINT pracuje_ako          FOREIGN KEY (pozicia)    REFERENCES pozicia  ON DELETE SET NULL;


CREATE TABLE osetruje
(
    ID_zivocicha    INT     NOT NULL,
    ID_zamestnanca  INT     NOT NULL
);
ALTER TABLE osetruje ADD CONSTRAINT stara_sa          FOREIGN KEY (ID_zamestnanca)    REFERENCES zamestnanec  ON DELETE CASCADE;
ALTER TABLE osetruje ADD CONSTRAINT je_postarane      FOREIGN KEY (ID_zivocicha)    REFERENCES zivocich  ON DELETE CASCADE;


ALTER TABLE vlastnost ADD CONSTRAINT ma_vlastnost   FOREIGN KEY (ID_zivocicha)      REFERENCES zivocich     ON DELETE CASCADE;
ALTER TABLE vlastnost ADD CONSTRAINT zadal          FOREIGN KEY (ID_zamestnanca)    REFERENCES zamestnanec  ON DELETE SET NULL;
ALTER TABLE vlastnost ADD CONSTRAINT je_typu          FOREIGN KEY (ID_vlastnosti)    REFERENCES typ_vlastnosti;

ALTER TABLE zivocich ADD CONSTRAINT kategoria       FOREIGN KEY (ID_typu)    REFERENCES typ_zivocicha;
ALTER TABLE typ_zivocicha ADD CONSTRAINT patri_triede   FOREIGN KEY (ID_triedy)  REFERENCES trieda_zivocicha;
ALTER TABLE typ_zivocicha ADD CONSTRAINT patri_druhu    FOREIGN KEY (ID_druhu)   REFERENCES druh_zivocicha;
ALTER TABLE typ_zivocicha ADD CONSTRAINT patri_radu     FOREIGN KEY (ID_radu)    REFERENCES rad_zivocicha;
ALTER TABLE typ_zivocicha ADD CONSTRAINT patri_celadi   FOREIGN KEY (ID_celade)  REFERENCES celad_zivocicha;
ALTER TABLE typ_zivocicha ADD CONSTRAINT patri_rodu     FOREIGN KEY (ID_rodu)    REFERENCES rod_zivocicha;


ALTER TABLE bol_umiestneny ADD CONSTRAINT je_v     FOREIGN KEY (ID_zivocicha)    REFERENCES zivocich ON DELETE CASCADE;
ALTER TABLE bol_umiestneny ADD CONSTRAINT umiestnil     FOREIGN KEY (ID_zamestnanca)    REFERENCES zamestnanec ON DELETE SET NULL;
ALTER TABLE bol_umiestneny ADD CONSTRAINT poloha     FOREIGN KEY (ID_umiestnenia)    REFERENCES umiestnenie;



INSERT INTO typ_vlastnosti(nazov, popis) VALUES ('Hmostnost', 'Vazene na lacno');

INSERT INTO pozicia(nazov, napln_prace) VALUES ('Riaditel', 'Nic nerobienie');
INSERT INTO zamestnanec(meno, priezvisko, heslo, rodne_cislo, pozicia) VALUES ('Jozko', 'Osetrovatel', 'p4$$w0rd', '770821/4338', 1);


INSERT INTO trieda_zivocicha(nazov, popis) VALUES ('tsts', 'ssss'); -- TODO
INSERT INTO druh_zivocicha(nazov , popis) VALUES ('tsts', 'ssss');
INSERT INTO rad_zivocicha(nazov, popis) VALUES ('tsts', 'ssss');
INSERT INTO celad_zivocicha(nazov, popis) VALUES ('tsts', 'ssss');
INSERT INTO rod_zivocicha(nazov, popis) VALUES ('tsts', 'ssss');
INSERT INTO typ_zivocicha(ID_triedy, ID_druhu, ID_radu, ID_celade, ID_rodu) VALUES(1, 1, 1, 1, 1);

INSERT INTO zivocich(meno, datum_narodenia, ID_typu) VALUES ('kokot', TO_DATE('01.01.2022', 'dd.mm.yyyy'), 1);
INSERT INTO vlastnost(hodnota, datum, ID_zivocicha, ID_zamestnanca, ID_vlastnosti) VALUES (420, TO_DATE('05052022', 'ddmmyyyy'), 1, 1, 1);

INSERT INTO osetruje(ID_zivocicha, ID_zamestnanca) VALUES (1, 1);


INSERT INTO umiestnenie(nazov, vyuzitelna_plocha, interakcia) VALUES ('Vybeh slonov', 2000, 0);  -- vybeh

INSERT INTO umiestnenie(nazov, vyuzitelna_plocha, teplota, vlhkost) VALUES ('Pavilon opic', 500, 28.9, 90);
INSERT INTO klietka(nazov, kod_zamku, ID_pavilonu) VALUES ('Simpanzi hood', 694269, 2);

INSERT INTO bol_umiestneny(ID_zivocicha, ID_umiestnenia, ID_zamestnanca, od) VALUES (1, 1, 1, TO_DATE('01.01.2022', 'dd.mm.yyyy'));

-- TODO: pridat normalne hodnoty