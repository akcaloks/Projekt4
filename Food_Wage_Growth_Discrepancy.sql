--Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH yearly_avg AS (
   	SELECT
        year,
        AVG(avg_price) AS avg_price,
        AVG(avg_wage)  AS avg_wage
    FROM t_jana_barotova_project_SQL_primary_final
    GROUP BY YEAR
),
growth AS (
    SELECT
        year,
        ROUND(
            100 * (avg_price - LAG(avg_price) OVER (ORDER BY year)) 
                / LAG(avg_price) OVER (ORDER BY year), 2
        ) AS food_growth_pct,
        ROUND(
            100 * (avg_wage - LAG(avg_wage) OVER (ORDER BY year)) 
                / LAG(avg_wage) OVER (ORDER BY year), 2
        ) AS wage_growth_pct
    FROM yearly_avg
)
SELECT
    year,
    food_growth_pct,
    wage_growth_pct,
    (food_growth_pct - wage_growth_pct) AS growth_gap
--    WHERE (food_growth_pct - wage_growth_pct) > 10 -- vyfiltroval by dany rok, kdyby existoval
FROM growth
ORDER BY year;

--Odpoveď: Neexistuje