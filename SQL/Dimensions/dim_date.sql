
-- Define the date range
DECLARE @start_date DATE = '2020-01-01';
DECLARE @end_date DATE = '2049-12-31';

-- Create the date dimension table
CREATE TABLE DimDate (
    date_key INT PRIMARY KEY,
    date_value DATE,
    year_start DATE,
    year_end DATE,
    quarter_start DATE,
    quarter_end DATE,
    month_start DATE,
    month_end DATE,
    week_start DATE,
    week_end DATE,
    is_weekend BIT,
    month_name NVARCHAR(20),
    month_abbr NVARCHAR(10),
    day_name NVARCHAR(20),
    day_abbr NVARCHAR(10),
    quarter_of_year INT,
    month_of_year INT,
    week_of_year INT,
    day_of_year INT,
    month_of_quarter INT,
    week_of_quarter INT,
    day_of_quarter INT,
    week_of_month INT,
    day_of_month INT,
    day_of_week INT
);

-- Populate the table
DECLARE @current_date DATE = @start_date;

WHILE @current_date <= @end_date
BEGIN
    DECLARE @year_start DATE = DATEFROMPARTS(YEAR(@current_date), 1, 1);
    DECLARE @quarter_start DATE = DATEFROMPARTS(YEAR(@current_date), ((MONTH(@current_date) - 1) / 3 + 1) * 3 - 2, 1);
    DECLARE @month_start DATE = DATEFROMPARTS(YEAR(@current_date), MONTH(@current_date), 1);
    DECLARE @week_start DATE = DATEADD(DAY, -DATEPART(WEEKDAY, @current_date) + 1, @current_date);

    INSERT INTO DimDate
    SELECT
        CAST(FORMAT(@current_date, 'yyyyMMdd') AS INT) AS date_key,
        @current_date AS date_value,
        @year_start AS year_start,
        DATEFROMPARTS(YEAR(@current_date), 12, 31) AS year_end,
        @quarter_start AS quarter_start,
        DATEADD(DAY, -1, DATEFROMPARTS(YEAR(@current_date), ((MONTH(@current_date) - 1) / 3 + 1) * 3 + 1, 1)) AS quarter_end,
        @month_start AS month_start,
        DATEADD(DAY, -1, DATEADD(MONTH, 1, @month_start)) AS month_end,
        @week_start AS week_start,
        DATEADD(DAY, 6, @week_start) AS week_end,
        CASE WHEN DATEPART(WEEKDAY, @current_date) IN (6, 7) THEN 1 ELSE 0 END AS is_weekend,
        DATENAME(MONTH, @current_date) AS month_name,
        LEFT(DATENAME(MONTH, @current_date), 3) AS month_abbr,
        DATENAME(WEEKDAY, @current_date) AS day_name,
        LEFT(DATENAME(WEEKDAY, @current_date), 3) AS day_abbr,
        (MONTH(@current_date) - 1) / 3 + 1 AS quarter_of_year,
        MONTH(@current_date) AS month_of_year,
        DATEPART(WEEK, @current_date) AS week_of_year,
        DATEPART(DAYOFYEAR, @current_date) AS day_of_year,
        (MONTH(@current_date) - 1) % 3 + 1 AS month_of_quarter,
        DATEDIFF(DAY, @quarter_start, @current_date) / 7 + 1 AS week_of_quarter,
        DATEDIFF(DAY, @quarter_start, @current_date) + 1 AS day_of_quarter,
        (DAY(@current_date) - 1) / 7 + 1 AS week_of_month,
        DAY(@current_date) AS day_of_month,
        DATEPART(WEEKDAY, @current_date) AS day_of_week;

    SET @current_date = DATEADD(DAY, 1, @current_date);
END;

-- Query the results
SELECT * FROM DimDate;
