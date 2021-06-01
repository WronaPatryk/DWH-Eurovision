--Check which are in GDP, but aren't in PointsGiven
SELECT DISTINCT [Year], [Country]
FROM GDP
EXCEPT
SELECT DISTINCT [Year], [Voted]
FROM PointsGiven

SELECT COUNT(*) FROM GDP -- should be leess

--OK we remove them
DECLARE @TmpWhatToDelete TABLE([Year] SMALLINT, [Country] VARCHAR(22))
INSERT INTO @TmpWhatToDelete
SELECT DISTINCT [Year], [Country]
FROM gdp
EXCEPT
SELECT DISTINCT [Year], [Voted]
FROM PointsGiven

DELETE FROM GDP
WHERE EXISTS
(SELECT 1
FROM @TmpWhatToDelete Tm
WHERE GDP.[Year] = Tm.[Year] AND GDP.[Country] = Tm.[Country])

SELECT COUNT(*) FROM GDP
--Well done

--Check which are in PointsGiven, but aren't in GDP - should be 2021
SELECT DISTINCT [Year], [Voted]
FROM PointsGiven
EXCEPT
SELECT DISTINCT [Year], [Country]
FROM GDP

--Remove them? Todo