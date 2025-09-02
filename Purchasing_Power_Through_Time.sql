-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT distinct(category_name)
FROM t_jana_barotova_project_SQL_primary_final

SELECT
    category_name,
    year,
    AVG(avg_price) AS avg_price,
    ROUND(AVG(avg_wage), 0) AS cz_avg_wage,
    ROUND(AVG(avg_wage) / AVG(avg_price), 0) AS quantity_affordable
FROM 
	t_jana_barotova_project_SQL_primary_final
WHERE 
	(category_name ILIKE '%mléko%' OR category_name ILIKE '%chléb%')
  	AND year IN (2006, 2018)
GROUP BY
	category_name,
	year
ORDER BY
	year,
	category_name;

-- V roce 2006 bylo možné si koupit za průměrnou roční mzdu 1,262 kg chleba a 1,409 litru mléka. 
-- V roce 2018 byla kupní síla průměrné mzdy vyšší a bylo možné si koupit 1,619 kg chleba a 1,614 litru mléka.
