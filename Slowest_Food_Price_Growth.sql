--Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

WITH price_changes AS (
	SELECT
		category_name,
		YEAR,
		avg(avg_price) AS avg_price,
		LAG(avg(avg_price)) OVER (PARTITION BY category_name ORDER BY year) AS prev_avg_price,
		ROUND((100*(avg(avg_price) - LAG(avg(avg_price)) OVER (PARTITION BY category_name ORDER BY year))/LAG(avg(avg_price)) OVER (PARTITION BY category_name ORDER BY year))::NUMERIC,2) AS percentage_change,
		CASE
			WHEN (100*(avg(avg_price) - LAG(avg(avg_price)) OVER (PARTITION BY category_name ORDER BY year))/LAG(avg(avg_price)) OVER (PARTITION BY category_name ORDER BY year)) > 0 THEN 'Růst ceny'
			WHEN (100*(avg(avg_price) - LAG(avg(avg_price)) OVER (PARTITION BY category_name ORDER BY year))/LAG(avg(avg_price)) OVER (PARTITION BY category_name ORDER BY year)) < 0 THEN 'Pokles ceny'
			WHEN  (100*(avg(avg_price) - LAG(avg(avg_price)) OVER (PARTITION BY category_name ORDER BY year))/LAG(avg(avg_price)) OVER (PARTITION BY category_name ORDER BY year)) = 0 THEN 'Bez pohybu ceny'
			ELSE 'bez trendu (prvni rok sledovani)'
		END AS Change_type
	FROM
		t_jana_barotova_project_SQL_primary_final
	GROUP BY 
		category_name,
		YEAR
	ORDER BY
		category_name,
		YEAR
)
SELECT 
	category_name,
	round(avg(percentage_change)::NUMERIC,2) AS avg_percentage_change
FROM price_changes
GROUP BY category_name
ORDER BY avg_percentage_change
-- LIMIT 1 - limitovalo by na jeden zaznam

-- Odpověď: 
-- Výsledky ukazují, že ne všechny ceny potravin dlouhodobě rostly, jak je v ekonomice běžné.
-- Největší výjimkou je „Cukr krystalový“, který v průměru meziročně zlevňoval o 1,9 %. 
-- Podobně i „Rajská jablka“ (-0,7 %) vykazovala mírný pokles cen. 
-- Některé položky jako „Banány“ (+0,8 %) prakticky stagnovaly, jejich ceny rostly jen velmi nepatrně. 
-- Mezi další stabilní komodity (do 1,5 % růstu ročně) patří např. vepřová pečeně, minerální voda nebo šunkový salám. 
--
-- Naopak nejrychleji zdražovalo máslo (+6,7 %), vejce (+5,6 %) a některé druhy zeleniny, zejména papriky (+7,3 %) a mrkev (+5,2 %).
--
-- Shrnutí: Nejpomaleji zdražovaly cukr (dokonce zlevnil) i rajčata. Dále málo rostly cen banánů (prakticky stagnace), zatímco nejrychleji rostly ceny másla, vejce a zeleniny.

