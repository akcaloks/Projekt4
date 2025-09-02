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
LIMIT 1
-- Odpověď: Cukr krystalový – dokonce zlevnil.
