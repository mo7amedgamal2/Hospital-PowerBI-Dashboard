CREATE TABLE dw.DimPatient (
    PatientKey INT IDENTITY(1,1) PRIMARY KEY,
    PatientID NVARCHAR(50),
    Gender NVARCHAR(10),
    Race NVARCHAR(50),
    Ethnicity NVARCHAR(50),
    MaritalStatus NVARCHAR(10),
    City NVARCHAR(100),
    State NVARCHAR(100)
);
INSERT INTO dw.DimPatient (
    PatientID,
    Gender,
    Race,
    Ethnicity,
    MaritalStatus,
    City,
    State
)
SELECT DISTINCT
    patient_id,
    gender,
    race,
    ethnicity,
    marital,
    city,
    state
FROM stg.patients
WHERE patient_id IS NOT NULL;

SELECT COUNT(*) FROM dw.DimPatient;
SELECT TOP 10 * FROM dw.DimPatient;
----------------------------------------------------------------

CREATE TABLE dw.DimOrganization (
    OrganizationKey INT IDENTITY(1,1) PRIMARY KEY,
    OrganizationID NVARCHAR(50),
    OrganizationName NVARCHAR(200),
    City NVARCHAR(100),
    State NVARCHAR(10)
);

INSERT INTO dw.DimOrganization (
    OrganizationID,
    OrganizationName,
    City,
    State
)
SELECT DISTINCT
    organization_id,
    name,
    city,
    state
FROM stg.organizations
WHERE organization_id IS NOT NULL;

SELECT COUNT(*) FROM dw.DimOrganization;
SELECT TOP 10 * FROM dw.DimOrganization;

----------------------------------------------------------

CREATE TABLE dw.DimPayer (
    PayerKey INT IDENTITY(1,1) PRIMARY KEY,
    PayerID NVARCHAR(50),
    PayerName NVARCHAR(200),
    City NVARCHAR(100),
    State NVARCHAR(10)
);

INSERT INTO dw.DimPayer (
    PayerID,
    PayerName,
    City,
    State
)
SELECT DISTINCT
    payer_id,
    name,
    city,
    state
FROM stg.payers
WHERE payer_id IS NOT NULL;

SELECT COUNT(*) FROM dw.DimPayer;
SELECT TOP 10 * FROM dw.DimPayer;

-----------------------------------------------

CREATE TABLE dw.DimDate (
    DateKey INT PRIMARY KEY, -- YYYYMMDD
    FullDate DATE,
    Day INT,
    Month INT,
    MonthName NVARCHAR(20),
    Year INT
);

INSERT INTO dw.DimDate
SELECT DISTINCT
    CONVERT(INT, FORMAT(start_datetime, 'yyyyMMdd')),
    CAST(start_datetime AS DATE),
    DAY(start_datetime),
    MONTH(start_datetime),
    DATENAME(MONTH, start_datetime),
    YEAR(start_datetime)
FROM stg.encounters
WHERE start_datetime IS NOT NULL;

SELECT COUNT(*) FROM dw.DimDate;
SELECT TOP 10 * FROM dw.DimDate;

-------------------------------------------------------------

CREATE TABLE dw.FactEncounters (
    EncounterKey INT IDENTITY(1,1) PRIMARY KEY,
    DateKey INT,
    PatientKey INT,
    OrganizationKey INT,
    PayerKey INT,
    EncounterClass NVARCHAR(50),
    BaseEncounterCost DECIMAL(10,2),
    TotalClaimCost DECIMAL(10,2),
    PayerCoverage DECIMAL(10,2)
);

INSERT INTO dw.FactEncounters (
    DateKey,
    PatientKey,
    OrganizationKey,
    PayerKey,
    EncounterClass,
    BaseEncounterCost,
    TotalClaimCost,
    PayerCoverage
)
SELECT
    d.DateKey,
    p.PatientKey,
    o.OrganizationKey,
    py.PayerKey,
    e.encounter_class,
    e.base_encounter_cost,
    e.total_claim_cost,
    e.payer_coverage
FROM stg.encounters e
JOIN dw.DimPatient p 
    ON e.patient_id = p.PatientID
JOIN dw.DimOrganization o 
    ON e.organization_id = o.OrganizationID
JOIN dw.DimPayer py 
    ON e.payer_id = py.PayerID
JOIN dw.DimDate d 
    ON d.FullDate = CAST(e.start_datetime AS DATE);


SELECT COUNT(*) FROM dw.FactEncounters;
SELECT TOP 10 * FROM dw.FactEncounters;