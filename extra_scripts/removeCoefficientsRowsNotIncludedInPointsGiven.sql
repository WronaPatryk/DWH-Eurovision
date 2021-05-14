DECLARE @TmpWhatToDelete TABLE([From] VARCHAR(22), [TO] VARCHAR(22))

INSERT INTO @TmpWhatToDelete
SELECT DISTINCT [From], [To]
FROM Coefficients C2
EXCEPT
SELECT DISTINCT [From], [To]
FROM PointsGiven

SELECT * FROM @TmpWhatToDelete

DELETE FROM Coefficients
WHERE EXISTS
(SELECT 1
FROM @TmpWhatToDelete Tm
WHERE Coefficients.[From] = Tm.[From] AND Coefficients.[To] = Tm.[To])

SELECT COUNT(*) FROM Coefficients