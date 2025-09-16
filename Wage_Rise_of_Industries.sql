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

-- Odpoveď:
-- Ano, v průběhu sledovaného období (2006–2018) se objevilo hned několik případů v ČR, kdy došlo k poklesu průměrné mzdy oproti předchozímu roku. Nejčastěji se tyto poklesy soustředily kolem let 2009–2013, tedy v období doznívající hospodářské krize.

-- - Nejvýraznější propad byl zaznamenán v odvětví Peněžnictví a pojišťovnictví v roce 2013, kdy mzdy klesly o více než 4 400 Kč (z 49 707 Kč na 45 234 Kč). To je největší meziroční pokles v celém datovém souboru a ukazuje na výrazné zpomalení finančního sektoru po krizi.
-- - Další významné poklesy se objevily v odvětvích:
--	o Výroba a rozvod elektřiny, plynu a tepla – např. v roce 2013 mzdy klesly o více než 1 800 Kč, což je poměrně velký zásah do příjmů zaměstnanců v tomto stabilnějším odvětví.
--	o Těžba a dobývání – opakované mírné poklesy (2009, 2013, 2014, 2016), kdy mzdy meziročně klesaly o několik stovek až více než tisíc korun.
--	o Stavebnictví a Ubytování, stravování a pohostinství – tato odvětví patřila rovněž mezi zasažené, i když šlo o menší částky (okolo 200–500 Kč).
-- - Naopak některá odvětví měla pokles jen ojedinělý a mírný – např. Veřejná správa a obrana, Vzdělávání nebo Kulturní a rekreační činnosti, kde mzdy klesly maximálně o několik stovek korun.
	
-- Celkově lze říci, že poklesy mezd nebyly plošné, ale koncentrovaly se do určitých sektorů – zejména do finančnictví, těžby a energetiky. V ostatních odvětvích mzdy většinou rostly, i když tempo růstu bylo někdy velmi malé.
-- Z pohledu ekonomické interpretace je zajímavé, že největší propady nastaly v letech 2013–2014, tedy několik let po samotné finanční krizi. To naznačuje, že dopady na mzdy se projevily se zpožděním a některé sektory se dostávaly pod tlak až později.


