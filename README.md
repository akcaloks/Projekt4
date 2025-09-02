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
  - Pro analýzu byla použita data **pouze za ČR** v období **2006–2018**.
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
- script: `Wage Rise of Industries.sql`
- Použili jsme `LAG()` k porovnání mezd oproti předchozímu roku.
- **Výsledek**:  
  - Většina odvětví dlouhodobě rostla.  
  - Existuje několik případů odvětví, kdy mzdy meziročně **klesly**.  

---

### 2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? 
- script: `Purchasing Power Through Time.sql`
- Porovnávali jsme na základě průměrné mzdy v letech **2006 vs. 2018**. 
- Výpočet: průměrná mzda / průměrná cena.  

**Výsledek**:
- 2006:  
  - Chléb: **1 262 kg**  
  - Mléko: **1 409 l**  
- 2018:  
  - Chléb: **1 619 kg**  
  - Mléko: **1 614 l**  

→ Kupní síla průměrné mzdy vzrostla.

---

### 3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
- script: `Slowest_Food_Price_Growth.sql`
- Výpočet průměrného meziročního růstu cen po kategoriích.  

**Výsledek**:
- **Cukr krystalový** – dokonce **zlevnil** v průměru.  

---

### 4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
- script: `Food_Wage_Growth_Discrepancy.sql`
- Porovnání meziročního růstu průměrné mzdy a průměrné ceny potravin.  

**Výsledek**:
- **Neexistuje** takový rok (rozdíl nikdy nepřesáhl 10 %).  

---

### 5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
- script: `Gdp_Impact_On_Wages_and_Food_Prices.sql`
- Byly spočítány Pearsonovy korelace (založené na růstových procentech).  

**Výsledky korelací**:
- **HDP × mzdy (stejný rok)**: `0.42` → středně silná pozitivní vazba.  
- **HDP × potraviny (stejný rok)**: `0.49` → středně silná pozitivní vazba.  
- **HDP × mzdy (HDP o rok dříve)**: `0.67` → silnější pozitivní vazba.  
- **HDP × potraviny (HDP o rok dříve)**: `-0.03` → žádná významná vazba.  

→ Růst HDP se projevuje zejména **v růstu mezd s ročním zpožděním**, zatímco ceny potravin jsou asi spíše ovlivňovány jinými faktory.

---

## Shrnutí hlavních poznatků
- Mzdy v ČR mezi lety 2006–2018 převážně rostly, ale občas došlo k meziročnímu poklesu v některých odvětvích.  
- Kupní síla výrazně vzrostla: za průměrnou mzdu lze koupit více chleba i mléka.  
- Nejvíce „zlevňující“ potravinou byl **cukr krystalový**.  
- Ceny potravin nikdy nerostly o více než 10 % rychleji než mzdy.  
- HDP je úzce propojeno s růstem mezd, hlavně v následujícím roce, ale **ceny potravin se od HDP neodvíjí**.  
