/* =========================================================
   Repeatable schema setup
   Genomic Knowledge System - Azure SQL
   ========================================================= */

IF OBJECT_ID('dbo.GeneFunctionalTag', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.GeneFunctionalTag (
        GeneId INT NOT NULL,
        FunctionalTagId INT NOT NULL,
        EvidenceType NVARCHAR(100) NULL,
        Confidence NVARCHAR(50) NULL,
        SourceReference NVARCHAR(500) NULL,
        Notes NVARCHAR(1000) NULL,
        CONSTRAINT PK_GeneFunctionalTag PRIMARY KEY (GeneId, FunctionalTagId)
    );
END;

IF OBJECT_ID('dbo.FunctionalTag', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.FunctionalTag (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(200) NOT NULL,
        Category NVARCHAR(100) NOT NULL,
        Description NVARCHAR(1000) NULL
    );
END;

IF OBJECT_ID('dbo.Gene', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Gene (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        AssemblyId INT NOT NULL,
        ChromosomeId INT NOT NULL,
        StableId NVARCHAR(200) NULL,
        Symbol NVARCHAR(100) NULL,
        Name NVARCHAR(500) NULL,
        StartBp BIGINT NOT NULL,
        EndBp BIGINT NOT NULL,
        Strand CHAR(1) NULL,
        Biotype NVARCHAR(100) NULL,
        Description NVARCHAR(1000) NULL
    );
END;

IF OBJECT_ID('dbo.Chromosome', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Chromosome (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        AssemblyId INT NOT NULL,
        Name NVARCHAR(100) NOT NULL,
        LengthBp BIGINT NOT NULL,
        DisplayOrder INT NOT NULL
    );
END;

IF OBJECT_ID('dbo.GenomeAssembly', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.GenomeAssembly (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        SpeciesId INT NOT NULL,
        Name NVARCHAR(100) NOT NULL,
        Accession NVARCHAR(100) NULL,
        Source NVARCHAR(100) NULL,
        IsDefault BIT NOT NULL DEFAULT 0
    );
END;

IF OBJECT_ID('dbo.Species', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Species (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        ScientificName NVARCHAR(200) NOT NULL,
        CommonName NVARCHAR(200) NULL,
        NcbiTaxonId INT NULL
    );
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE name = 'IX_Chromosome_AssemblyId'
      AND object_id = OBJECT_ID('dbo.Chromosome')
)
CREATE INDEX IX_Chromosome_AssemblyId
ON dbo.Chromosome (AssemblyId);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE name = 'IX_Gene_Chromosome_Position'
      AND object_id = OBJECT_ID('dbo.Gene')
)
CREATE INDEX IX_Gene_Chromosome_Position
ON dbo.Gene (ChromosomeId, StartBp, EndBp);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE name = 'IX_Gene_Symbol'
      AND object_id = OBJECT_ID('dbo.Gene')
)
CREATE INDEX IX_Gene_Symbol
ON dbo.Gene (Symbol);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE name = 'IX_FunctionalTag_Name'
      AND object_id = OBJECT_ID('dbo.FunctionalTag')
)
CREATE INDEX IX_FunctionalTag_Name
ON dbo.FunctionalTag (Name);