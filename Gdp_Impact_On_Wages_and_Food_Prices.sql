-- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

--prvni dotaz bez korelaci
WITH food_wage AS (    
    SELECT
        year,
        AVG(avg_price) AS avg_price,
        AVG(avg_wage) AS avg_wage
    FROM t_jana_barotova_project_SQL_primary_final
    GROUP BY year
),
gdp_cr AS (
    SELECT
        country,
        year,
        gdp
    FROM t_jana_barotova_project_SQL_secondary_final
    WHERE country = 'Czech Republic'
),
with_growth AS (
    SELECT
        f.year,
        f.avg_price,
        f.avg_wage,
        g.gdp,
        ROUND(100 * (f.avg_price - LAG(f.avg_price) OVER (ORDER BY f.year)) 
              / LAG(f.avg_price) OVER (ORDER BY f.year)::NUMERIC, 2) AS food_growth_pct,
        ROUND(100 * (f.avg_wage - LAG(f.avg_wage) OVER (ORDER BY f.year)) 
              / LAG(f.avg_wage) OVER (ORDER BY f.year)::NUMERIC, 2) AS wage_growth_pct,
        ROUND(100 * ((g.gdp - LAG(g.gdp) OVER (ORDER BY g.year))::NUMERIC 
              / LAG(g.gdp) OVER (ORDER BY g.year)::NUMERIC), 2) AS gdp_growth_pct
    FROM food_wage f
    JOIN gdp_cr g ON f.year = g.year
)
    SELECT
        year,
        ROUND(avg_price::NUMERIC, 2) AS avg_price,
   		ROUND(avg_wage::NUMERIC, 2) AS avg_wage,
    	ROUND(gdp::NUMERIC, 0) AS gdp,
        food_growth_pct,
        wage_growth_pct,
        gdp_growth_pct,
        LAG(gdp_growth_pct) OVER (ORDER BY year) AS gdp_growth_prev_year
    FROM with_growth;

--druhy dotaz na korelace Pearson
WITH food_wage AS (    
    SELECT
        year,
        AVG(avg_price) AS avg_price,
        AVG(avg_wage) AS avg_wage
    FROM t_jana_barotova_project_SQL_primary_final
    GROUP BY year
),
gdp_cr AS (
    SELECT
        country,
        year,
        gdp
    FROM t_jana_barotova_project_SQL_secondary_final
    WHERE country = 'Czech Republic'
),
with_growth AS (
    SELECT
        f.year,
        ROUND(100 * (f.avg_price - LAG(f.avg_price) OVER (ORDER BY f.year)) 
              / LAG(f.avg_price) OVER (ORDER BY f.year)::NUMERIC, 2) AS food_growth_pct,
        ROUND(100 * (f.avg_wage - LAG(f.avg_wage) OVER (ORDER BY f.year)) 
              / LAG(f.avg_wage) OVER (ORDER BY f.year)::NUMERIC, 2) AS wage_growth_pct,
        ROUND(100 * ((g.gdp - LAG(g.gdp) OVER (ORDER BY g.year))::NUMERIC 
              / LAG(g.gdp) OVER (ORDER BY g.year)::NUMERIC), 2) AS gdp_growth_pct
    FROM food_wage f
    JOIN gdp_cr g ON f.year = g.year
),
with_lagged AS (
    SELECT
        year,
        food_growth_pct,
        wage_growth_pct,
        gdp_growth_pct,
        LAG(gdp_growth_pct) OVER (ORDER BY year) AS gdp_growth_prev_year
    FROM with_growth
)
SELECT
    ROUND(corr(gdp_growth_pct, wage_growth_pct)::NUMERIC,2) AS corr_gdp_wage_same_year,
    ROUND(corr(gdp_growth_pct, food_growth_pct)::NUMERIC,2) AS corr_gdp_food_same_year,
    ROUND(corr(gdp_growth_prev_year, wage_growth_pct)::NUMERIC,2) AS corr_gdp_wage_next_year,
    ROUND(corr(gdp_growth_prev_year, food_growth_pct)::NUMERIC,2) AS corr_gdp_food_next_year
FROM with_lagged;

--Mzdy a HDP – stejný rok (0.42)
--→ středně silná pozitivní korelace.
--Růst HDP obvykle doprovází i růst mezd, ale ne vždy.
--
--Ceny potravin a HDP – stejný rok (0.49)
--→ podobná střední pozitivní vazba.
--Když se ekonomice daří, potraviny mají tendenci zdražovat, ale ne vždy.
--
--Mzdy a HDP – následující rok (0.67)
--→ poměrně silná pozitivní vazba.
--Růst HDP se častěji projeví až v růstu mezd o rok později.
--
--Ceny potravin a HDP – následující rok (-0.03)
--→ prakticky žádná vazba.
--Ceny potravin jsou zřejmě ovlivněny hlavně jinými faktory.

--Závěr: Růst HDP se projevuje zejména v růstu mezd s ročním zpožděním, zatímco ceny potravin jsou asi spíše ovlivňovány jinými faktory.


