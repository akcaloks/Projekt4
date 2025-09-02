-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

WITH wages AS (
    SELECT industry_name, YEAR, avg(avg_wage) AS avg_wage
    FROM t_jana_barotova_project_SQL_primary_final
    GROUP BY industry_name, YEAR
)
, trends AS (
    SELECT 
        industry_name,
        year,
        avg_wage,
        LAG(avg_wage) OVER (PARTITION BY industry_name ORDER BY year) AS prev_wage,
        (avg_wage - LAG(avg_wage) OVER (PARTITION BY industry_name ORDER BY year)) AS diff,
        CASE 
	        WHEN avg_wage > LAG(avg_wage) OVER (PARTITION BY industry_name ORDER BY year) THEN 'rostla'
	        WHEN avg_wage < LAG(avg_wage) OVER (PARTITION BY industry_name ORDER BY year) THEN 'klesla'
	        WHEN LAG(avg_wage) OVER (PARTITION BY industry_name ORDER BY year) IS NULL THEN 'bez trendu (prvni rok sledovani)'
	        ELSE 'beze změny'
        END AS trend
    FROM wages
)
SELECT *
FROM trends
WHERE trend = 'klesla'
ORDER BY industry_name, year;

-- Odpoveď: Existuje několik odvětví, vekterých alespoň v jednom nebo více letech došlo k poklesu průměrné mzdy oproti předchozímu roku.