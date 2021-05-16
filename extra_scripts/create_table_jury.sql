DROP TABLE [Jury]
CREATE TABLE [Jury] (
    [year] [int] NOT NULL,
    [country_of_jury] [nvarchar] (32) NOT NULL,
    [member_id] [nvarchar] (32) NOT NULL,
    [gender] [nvarchar] (32),
    [birthdate] [nvarchar] (32),
    [birthyear] [nvarchar] (32),
    [birthmonth] [int],
    [birthday] [int]
)


SELECT * FROM [Jury]