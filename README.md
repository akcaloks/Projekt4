# Projekt: Analýza mezd, cen potravin a HDP v ČR (2006–2018)

### Použitá data
- **Primární tabulka**: `t_jana_barotova_project_SQL_primary_final`
  - script: `Creation_of_Primary_Table.sql` 
  - Obsahuje průměrné ceny potravin a průměrné mzdy v jednotlivých odvětvích.  
  - Data vznikla propojením tabulek:
    - `czechia_price` (ceny potravin podle kategorií)
    - `czechia_price_category` (číselník kategorií potravin)
    - `czechia_payroll` (mzdy podle odvětví)
    - `czechia_payroll_industry_branch` (číselník odvětví)

- **Sekundární tabulka**: `t_jana_barotova_project_SQL_secondary_final`
  - script: `Creation_of_Secondary_Table.sql`  
  - Obsahuje makroekonomické ukazatele (HDP, populace, GINI, daně) pro evropské země.  
  - Pro analýzu byla použita data **pouze za Evropu** v období **2006–2018**.
  - Data vznikla propojením tabulek:
    - `economies` (makroekonomické ukazatele – HDP, populace, GINI, daně)
    - `countries` (číselník států, použit pro názvy a určení kontinentu)


### Kvalita a úplnost dat
- **Časové pokrytí**: 2006–2018 (u obou datasetů).  
- **Chybějící hodnoty**:
  - V `t_jana_barotova_project_SQL_secondary_final` byly odstraněny řádky s chybějícími údaji pro `gini` a `taxes`.
  - V `t_jana_barotova_project_SQL_primary_final` byla provedena agregace na úroveň roků a průměrů → výsledný dataset neobsahuje NULL hodnoty.  
---

## Otázky a výsledky

### 1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
- script: `Wage_Rise_of_Industries.sql`
- Použili jsme `LAG()` k porovnání mezd oproti předchozímu roku.
- **Výsledek**:  
- Ano, v průběhu sledovaného období (2006–2018) se objevilo hned několik případů v ČR, kdy došlo k poklesu průměrné mzdy oproti předchozímu roku. Nejčastěji se tyto poklesy soustředily kolem let **2009–2013**, tedy v období doznívající hospodářské krize.

- Nejvýraznější propad byl zaznamenán v odvětví **Peněžnictví a pojišťovnictví** v roce 2013, kdy mzdy klesly o více než **4 400 Kč** (z 49 707 Kč na 45 234 Kč).  
  To je největší meziroční pokles v celém datovém souboru a ukazuje na výrazné zpomalení finančního sektoru po krizi.

- Další významné poklesy se objevily v odvětvích:  
  - **Výroba a rozvod elektřiny, plynu a tepla** – např. v roce 2013 mzdy klesly o více než **1 800 Kč**, což je poměrně velký zásah do příjmů zaměstnanců v tomto stabilnějším odvětví.  
  - **Těžba a dobývání** – opakované mírné poklesy (2009, 2013, 2014, 2016), kdy mzdy meziročně klesaly o několik stovek až více než tisíc korun.  
  - **Stavebnictví a Ubytování, stravování a pohostinství** – tato odvětví patřila rovněž mezi zasažené, i když šlo o menší částky (okolo 200–500 Kč).

- Naopak některá odvětví měla pokles jen ojedinělý a mírný – např. **Veřejná správa a obrana**, **Vzdělávání** nebo **Kulturní a rekreační činnosti**, kde mzdy klesly maximálně o několik stovek korun.

Celkově lze říci, že poklesy mezd nebyly plošné, ale koncentrovaly se do určitých sektorů – zejména do **finančnictví, těžby a energetiky**. V ostatních odvětvích mzdy většinou rostly, i když tempo růstu bylo někdy velmi malé.

Z pohledu ekonomické interpretace je zajímavé, že největší propady nastaly v letech **2013–2014**, tedy několik let po samotné finanční krizi. To naznačuje, že dopady na mzdy se projevily se zpožděním a některé sektory se dostávaly pod tlak až později.


---

### 2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? 
- script: `Purchasing_Power_Through_Time.sql`
- Porovnávali jsme na základě průměrné mzdy v letech **2006 vs. 2018**. 
- Výpočet: průměrná mzda / průměrná cena.  

**Výsledek**:
- 2006:  
  - Chléb: **1 262 kg**  
  - Mléko: **1 409 l**  
- 2018:  
  - Chléb: **1 619 kg**  
  - Mléko: **1 614 l**  

V roce 2006 bylo možné si koupit za průměrnou roční mzdu **1 262 kg chleba** a **1 409 l mléka**.  

Do roku 2018 mzdy vzrostly z **20 343 Kč** na **31 981 Kč**, zatímco ceny potravin rostly pomaleji.  

Kupní síla se tedy zlepšila:  
- u chleba jen mírně – na **1 319 ks**, což představuje nárůst o cca **4,5 %**  
- u mléka znatelněji – na **1 614 l**, což je nárůst o cca **14,5 %**  

Celkově platí, že růst mezd převýšil růst cen, zejména u mléka. To byl pro pracující obyvatele ČR pozitivní vývoj.  

Celkově lze říct, že období **2006–2018** přineslo zlepšení životní úrovně v oblasti základních potravin díky vyšším mzdám a kontrolovanému růstu cen, což se projevilo zejména u mléka.



---

### 3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
- script: `Slowest_Food_Price_Growth.sql`
- Výpočet průměrného meziročního růstu cen po kategoriích.  

**Výsledek**:

Výsledky ukazují, že ne všechny ceny potravin dlouhodobě rostly, jak je v ekonomice běžné.  

- Největší výjimkou je **„Cukr krystalový“**, který v průměru meziročně zlevňoval o **1,9 %**  
- Podobně i **„Rajská jablka“** (-0,7 %) vykazovala mírný pokles cen  
- Některé položky jako **„Banány“** (+0,8 %) prakticky stagnovaly, jejich ceny rostly jen velmi nepatrně  
- Mezi další stabilní komodity (do 1,5 % růstu ročně) patří např. **vepřová pečeně**, **minerální voda** nebo **šunkový salám**  

Naopak nejrychleji zdražovalo:  
- **Máslo** (+6,7 %)  
- **Vejce** (+5,6 %)  
- Některé druhy zeleniny, zejména **papriky** (+7,3 %) a **mrkev** (+5,2 %)  

**Shrnutí:**  
Nejpomaleji zdražovaly **cukr** (dokonce zlevnil) i **rajčata**. Dále málo rostly ceny **banánů** (prakticky stagnace), zatímco nejrychleji rostly ceny **másla, vajec a zeleniny**.


---

### 4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
- script: `Food_Wage_Growth_Discrepancy.sql`
- Porovnání meziročního růstu průměrné mzdy a průměrné ceny potravin.  

**Výsledek**:
Analýza meziročního nárůstu cen potravin a mezd v ČR ukazuje, že během sledovaného období **2006–2018** neexistoval rok, kdy by ceny potravin rostly více než **10 % nad růstem mezd**.  

- Největší rozdíl mezi růstem cen potravin a mezd byl v roce **2013** (+6,66 % ve prospěch cen), což je ale stále pod hranicí 10 %.  
  - Jednalo se o jediný rok, kdy mzdy dokonce meziročně klesly.  

To znamená, že během období **2006–2018** mzdy rostly přibližně stejným tempem jako ceny potravin, nebo mírně rychleji, což je pozitivní pro **reálnou kupní sílu obyvatel**.


---

### 5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
- script: `Gdp_Impact_On_Wages_and_Food_Prices.sql`
- Byly spočítány Pearsonovy korelace (založené na růstových procentech).  

**Výsledky**:
- **Korelace mezi růstem HDP a změnami mezd a cen potravin** byla spočítána jak pro **stejný rok**,  
tak pro **následující rok**, aby bylo možné posoudit okamžitý i zpožděný efekt ekonomického růstu.

### 1) Stejný rok
- **Mzdy a HDP**: korelace 0.42 → středně silná pozitivní vazba.  
  - V letech, kdy HDP rostlo, mzdy měly tendenci také růst, i když tento efekt nebyl zcela konzistentní.  
  - Ekonomika tedy obvykle „tahá“ mzdy směrem nahoru, ale nejsou to automatické či úplně lineární změny.

- **Ceny potravin a HDP**: korelace 0.49 → střední pozitivní vazba.  
  - Ceny potravin mají tendenci růst, když roste ekonomika, což může být způsobeno vyšší poptávkou nebo rostoucími výrobními náklady.  
  - Efekt je však opět nestabilní; někdy ceny potravin rostou rychleji, jindy pomaleji, i při stejném růstu HDP.

### 2) Následující rok
- **Mzdy a HDP**: korelace 0.67 → poměrně silná pozitivní vazba.  
  - Růst HDP se častěji projeví ve zvýšení mezd s ročním zpožděním.  
  - Zpoždění může být způsobeno procesy v kolektivním vyjednávání, legislativou, nebo časem potřebným k tomu, aby firmy upravily mzdy podle ekonomických výsledků.

- **Ceny potravin a HDP**: korelace -0.03 → prakticky žádná vazba.  
  - Růst HDP v předchozím roce nijak významně neovlivňuje tempo růstu cen potravin.  
  - Ceny potravin jsou patrně ovlivněny spíše jinými faktory, např. klimatickými podmínkami, mezinárodními cenami surovin, logistickými náklady nebo sezónními výkyvy.

### Závěr
- Ekonomický růst v ČR se projevuje zejména v růstu mezd, zejména s ročním zpožděním.  
- Přímý efekt na ceny potravin není výrazný, což ukazuje, že spotřební ceny jsou determinovány spíše kombinací nabídky a poptávky v jednotlivých kategoriích a dalšími externími vlivy než samotným růstem HDP.  
- Pro zaměstnance to znamená, že vyšší HDP se často pozitivně promítá do jejich **kupní síly** prostřednictvím rostoucích mezd, zatímco ceny potravin se vyvíjejí relativně nezávisle.

---

- ## Shrnutí hlavních poznatků
- Mzdy v ČR mezi lety 2006–2018 převážně rostly, ale občas došlo k meziročnímu poklesu v některých odvětvích.  
- Kupní síla výrazně vzrostla: za průměrnou mzdu lze koupit více chleba i mléka.  
- Nejvíce „zlevňující“ potravinou byl **cukr krystalový**.  
- Ceny potravin nikdy nerostly o více než 10 % rychleji než mzdy.  
- HDP je úzce propojeno s růstem mezd, hlavně v následujícím roce, ale **ceny potravin se od HDP neodvíjí**.

