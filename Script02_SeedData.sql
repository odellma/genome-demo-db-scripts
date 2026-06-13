IF NOT EXISTS (
    SELECT 1 FROM dbo.Species 
    WHERE ScientificName = 'Salmo salar'
)
BEGIN
    INSERT INTO dbo.Species (ScientificName, CommonName, NcbiTaxonId)
    VALUES ('Salmo salar', 'Atlantic salmon', 8030);
END;

DECLARE @SpeciesId INT =
(
    SELECT Id FROM dbo.Species 
    WHERE ScientificName = 'Salmo salar'
);

IF NOT EXISTS (
    SELECT 1 FROM dbo.GenomeAssembly 
    WHERE Name = 'Ssal_v3.1'
      AND SpeciesId = @SpeciesId
)
BEGIN
    INSERT INTO dbo.GenomeAssembly 
        (SpeciesId, Name, Accession, Source, IsDefault)
    VALUES 
        (@SpeciesId, 'Ssal_v3.1', 'GCF_905237065.1', 'NCBI RefSeq', 1);
END;

DECLARE @AssemblyId INT =
(
    SELECT Id FROM dbo.GenomeAssembly 
    WHERE Name = 'Ssal_v3.1'
      AND SpeciesId = @SpeciesId
);

IF NOT EXISTS (
    SELECT 1 FROM dbo.Chromosome 
    WHERE AssemblyId = @AssemblyId 
      AND Name = 'ssa01'
)
BEGIN
    INSERT INTO dbo.Chromosome (AssemblyId, Name, LengthBp, DisplayOrder)
    VALUES (@AssemblyId, 'ssa01', 158454518, 1);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.Chromosome 
    WHERE AssemblyId = @AssemblyId 
      AND Name = 'ssa02'
)
BEGIN
    INSERT INTO dbo.Chromosome (AssemblyId, Name, LengthBp, DisplayOrder)
    VALUES (@AssemblyId, 'ssa02', 140424950, 2);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.FunctionalTag 
    WHERE Name = 'Fasting response'
)
BEGIN
    INSERT INTO dbo.FunctionalTag (Name, Category, Description)
    VALUES 
    (
        'Fasting response',
        'Stressor',
        'Genes associated with fasting or nutrient limitation'
    );
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.FunctionalTag 
    WHERE Name = 'Lipid metabolism'
)
BEGIN
    INSERT INTO dbo.FunctionalTag (Name, Category, Description)
    VALUES 
    (
        'Lipid metabolism',
        'Metabolic pathway',
        'Genes involved in lipid transport, oxidation, or regulation'
    );
END;

DECLARE @Ssa01Id INT =
(
    SELECT Id FROM dbo.Chromosome
    WHERE AssemblyId = @AssemblyId
      AND Name = 'ssa01'
);

IF NOT EXISTS (
    SELECT 1 FROM dbo.Gene
    WHERE AssemblyId = @AssemblyId
      AND Symbol = 'igf1'
)
BEGIN
    INSERT INTO dbo.Gene
        (AssemblyId, ChromosomeId, StableId, Symbol, Name, StartBp, EndBp, Strand, Biotype, Description)
    VALUES
        (@AssemblyId, @Ssa01Id, 'gene-igf1-example', 'igf1', 'insulin-like growth factor 1',
         80400000, 80520000, '+', 'protein_coding', 'Growth and endocrine signaling gene');
END;

DECLARE @GeneId INT =
(
    SELECT Id FROM dbo.Gene
    WHERE AssemblyId = @AssemblyId
      AND Symbol = 'igf1'
);

DECLARE @TagId INT =
(
    SELECT Id FROM dbo.FunctionalTag
    WHERE Name = 'Fasting response'
);

IF @GeneId IS NOT NULL 
   AND @TagId IS NOT NULL
   AND NOT EXISTS (
        SELECT 1 FROM dbo.GeneFunctionalTag
        WHERE GeneId = @GeneId
          AND FunctionalTagId = @TagId
   )
BEGIN
    INSERT INTO dbo.GeneFunctionalTag
        (GeneId, FunctionalTagId, EvidenceType, Confidence, SourceReference, Notes)
    VALUES
        (@GeneId, @TagId, 'Manual', 'Medium', 'manual-curation', 'Example curated relationship');
END;