DECLARE @TmpWhatToDelete2 TABLE([From] VARCHAR(22), [TO] VARCHAR(22))

INSERT INTO @TmpWhatToDelete2
SELECT DISTINCT [From], [To]
FROM PointsGiven
EXCEPT
SELECT DISTINCT [From], [To]
FROM Coefficients

SELECT * FROM @TmpWhatToDelete2

DELETE FROM PointsGiven
WHERE EXISTS
(SELECT 1
FROM @TmpWhatToDelete2 Tm2
WHERE PointsGiven.[From] = Tm2.[From] AND PointsGiven.[To] = Tm2.[To])

SELECT COUNT(*) FROM PointsGiven