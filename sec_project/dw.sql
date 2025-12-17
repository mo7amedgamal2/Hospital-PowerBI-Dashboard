
USE Hospital_DW;
GO

CREATE SCHEMA stg;
GO

CREATE SCHEMA dw;
GO
CREATE TABLE stg.patients (
    patient_id NVARCHAR(50),
    birth_date DATE,
    death_date DATE,
    gender NVARCHAR(10),
    race NVARCHAR(50),
    ethnicity NVARCHAR(50),
    marital NVARCHAR(10),
    city NVARCHAR(100),
    state NVARCHAR(100),
    zip NVARCHAR(10)
);

CREATE TABLE stg.encounters (
    encounter_id NVARCHAR(50),
    start_datetime DATETIME,
    stop_datetime DATETIME,
    patient_id NVARCHAR(50),
    organization_id NVARCHAR(50),
    payer_id NVARCHAR(50),
    encounter_class NVARCHAR(50),
    base_encounter_cost DECIMAL(10,2),
    total_claim_cost DECIMAL(10,2),
    payer_coverage DECIMAL(10,2),
    reason_code NVARCHAR(50),
    reason_description NVARCHAR(255)
);

CREATE TABLE stg.procedures (
    procedure_start DATETIME,
    procedure_stop DATETIME,
    patient_id NVARCHAR(50),
    encounter_id NVARCHAR(50),
    procedure_code NVARCHAR(50),
    description NVARCHAR(255),
    base_cost DECIMAL(10,2),
    reason_code NVARCHAR(50),
    reason_description NVARCHAR(255)
);

CREATE TABLE stg.organizations (
    organization_id NVARCHAR(50),
    name NVARCHAR(200),
    city NVARCHAR(100),
    state NVARCHAR(10),
    zip NVARCHAR(10),
    lat FLOAT,
    lon FLOAT
);

CREATE TABLE stg.payers (
    payer_id NVARCHAR(50),
    name NVARCHAR(200),
    city NVARCHAR(100),
    state NVARCHAR(10),
    phone NVARCHAR(50)
);

SELECT * FROM stg.patients;
SELECT * FROM stg.encounters;
SELECT * FROM stg.organizations;
SELECT * FROM stg.payers;
SELECT * FROM stg.procedures;
