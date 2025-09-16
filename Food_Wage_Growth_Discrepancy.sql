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
                / LAG(avg_price) OVER (ORDER BY year)::NUMERIC, 2
        ) AS food_growth_pct,
        ROUND(
            100 * (avg_wage - LAG(avg_wage) OVER (ORDER BY year)) 
                / LAG(avg_wage) OVER (ORDER BY year)::NUMERIC, 2
        ) AS wage_growth_pct
)
SELECT
    year,
    food_growth_pct,
    wage_growth_pct,
    (food_growth_pct - wage_growth_pct) AS growth_gap
--    WHERE (food_growth_pct - wage_growth_pct) > 10 -- vyfiltroval by dany rok, kdyby existoval
FROM growth
ORDER BY year;


--Odpoveď:
-- Analýza meziročního nárůstu cen potravin a mezd v ČR ukazuje, že během sledovaného období 2006–2018 neexistoval rok, kdy by ceny potravin rostly více než 10 % nad růstem mezd.
-- Největší rozdíl mezi růstem cen potravin a mezd byl v roce 2013 (+6,66 % ve prospěch cen), což je ale stále pod hranicí 10 %. Jednalo se o jediný rok, kdy mzdy dokonce meziročně klesly.

-- To znamená, že během tohoto období 2006–2018 mzdy rostly přibližně stejným tempem jako ceny potravin, nebo mírně rychleji, což je pozitivní pro reálnou kupní sílu obyvatel.
