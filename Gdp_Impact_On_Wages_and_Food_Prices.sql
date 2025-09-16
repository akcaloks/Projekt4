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

--Odpověď:

-- Korelace mezi růstem HDP a změnami mezd a cen potravin byla spočítána jak pro stejný rok,
-- tak pro následující rok, aby bylo možné posoudit okamžitý i zpožděný efekt ekonomického růstu.

-- 1) Stejný rok
-- Mzdy a HDP: korelace 0.42 → středně silná pozitivní vazba. 
-- To znamená, že v letech, kdy HDP rostlo, mzdy měly tendenci také růst, i když tento efekt nebyl zcela konzistentní.
-- Ekonomika tedy obvykle „tahá“ mzdy směrem nahoru, ale nejsou to automatické či úplně lineární změny.

-- Ceny potravin a HDP: korelace 0.49 → střední pozitivní vazba.
-- Ceny potravin mají tendenci růst, když roste ekonomika, což může být způsobeno vyšší poptávkou nebo rostoucími výrobními náklady.
-- Efekt je však opět nestabilní; někdy ceny potravin rostou rychleji, jindy pomaleji, i při stejném růstu HDP.

-- 2) Následující rok
-- Mzdy a HDP: korelace 0.67 → poměrně silná pozitivní vazba.
-- To naznačuje, že růst HDP se častěji projeví ve zvýšení mezd s ročním zpožděním.
-- Zpoždění může být způsobeno procesy v kolektivním vyjednávání, legislativou, nebo časem potřebným k tomu, aby firmy upravily mzdy podle ekonomických výsledků.

-- Ceny potravin a HDP: korelace -0.03 → prakticky žádná vazba.
-- To znamená, že růst HDP v předchozím roce nijak významně neovlivňuje tempo růstu cen potravin.
-- Ceny potravin jsou patrně ovlivněny spíše jinými faktory, např. klimatickými podmínkami, mezinárodními cenami surovin, logistickými náklady nebo sezónními výkyvy.

-- ZÁVĚR:
-- Ekonomický růst v ČR se projevuje zejména v růstu mezd, zejména s ročním zpožděním. 
-- Přímý efekt na ceny potravin není výrazný, což ukazuje, že spotřební ceny jsou determinovány spíše kombinací nabídky a poptávky v jednotlivých kategoriích a dalšími externími vlivy než samotným růstem HDP.
-- Pro zaměstnance to znamená, že vyšší HDP se často pozitivně promítá do jejich kupní síly prostřednictvím rostoucích mezd, zatímco ceny potravin se vyvíjejí relativně nezávisle.




