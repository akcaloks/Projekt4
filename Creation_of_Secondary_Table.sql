-- Vytvoření druhé tabulky:
CREATE TABLE t_jana_barotova_project_SQL_secondary_final AS (
SELECT 
	c.country,
	YEAR,
	gdp,
	e.population,
	gini,
	round(e.taxes::NUMERIC,2) AS taxes
FROM economies e
JOIN countries c ON e.country = c.country
WHERE continent = 'Europe' AND YEAR BETWEEN 2006 AND 2018 AND gini IS NOT NULL AND taxes IS NOT NULL
ORDER BY e.country, YEAR
);
