-- Vytvoření první tabulky:
CREATE TABLE t_jana_barotova_project_SQL_primary_final AS
WITH price_per_year AS(
	SELECT
	    cpc.name AS category_name,
	    EXTRACT(YEAR FROM cprice.date_from) AS year,
	    ROUND(AVG(cprice.value)::numeric, 2) AS avg_price
	FROM czechia_price cprice
	JOIN czechia_price_category cpc ON cprice.category_code = cpc.code 
	GROUP BY cpc.name, EXTRACT(YEAR FROM cprice.date_from)
),
wage_per_year AS ( 
	SELECT 
		c.payroll_year AS year,
		cpib.name AS industry_name,
		ROUND(AVG(value)::numeric, 0) AS avg_wage
	FROM czechia_payroll c 
	JOIN czechia_payroll_industry_branch cpib ON c.industry_branch_code = cpib.code
	WHERE c.value_type_code = 5958 AND c.calculation_code = 100
	GROUP BY c.payroll_year, cpib.name
)
SELECT
	p.YEAR,
	p.category_name,
	p.avg_price,
	w.industry_name,
	w.avg_wage
FROM price_per_year p
JOIN wage_per_year w 
	ON p.YEAR = w.YEAR
ORDER BY p.YEAR, p.category_name, w.industry_name;

