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
-- Do roku 2018 mzdy vzrostly z 20 343 Kč na 31 981 Kč, zatímco ceny potravin rostly pomaleji. 
-- Kupní síla se tedy zlepšila:
--   • u chleba jen mírně – na 1 319 ks, což představuje nárůst o cca 4,5 %,
--   • u mléka znatelněji – na 1 614 l, což je nárůst o cca 14,5 %.
-- Celkově platí, že růst mezd převýšil růst cen, zejména u mléka. To je byl pro pracující obyvatele ČR pozitivní vývoj.
-- Celkově lze říct, že období 2006–2018 přineslo zlepšení životní úrovně v oblasti základních potravin 
-- díky vyšším mzdám a kontrolovanému růstu cen, což se projevilo zejména u mléka.

