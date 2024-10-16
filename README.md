# Exploratory Data Analysis on Layoffs Dataset

## Table of Contents
  - [Objective](#objective)
  - [Dataset](#dataset)
  - [Methodology](#methodology)
  - [Tools](#tools)
  - [Deliverables](#deliverables)

### Objective

The primary goal of this project is to perform an exploratory data analysis (EDA) on the Layoffs dataset to uncover patterns, trends, and insights.

### Dataset

The dataset of layoff from March 2020 to March 2023 (https://rb.gy/6we5n5), containing the following key features

- Company: Name of the company
- Location: Location of the company
- Industry: Industry of the company
- Total Laid off: Total of employees laid off
- Percentage Laid off: Percentage of laid off respects to the total of employees
- Date: date of the laid off
- Stage: Business phase or funding stage the company is in
- Country: Country of the company
- Funds Raised Millions: Amount of capital the company has raised from investors in millions of dollars

### Methodology

#### 1. Data Collection and Preparation

The data cleaning was done in the [Layoffs Data Cleaning Project](https://github.com/galaes/layoffs-data-cleaning/blob/3c1c60ecad47e0939bf8d2c2489d68079a5c21eb/README.md), which includes:
- Data loading and inspection
- Handling missing and duplicate values
- Standardizing the structure   

#### 2. Descriptive Analysis

The analysis include answers to questions such as:
- What was the total laid off for each year and month?

```sql
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH` ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;
```

![images](images/total_by_year_month.png)

- What was the top 5 ranking of laid-off for each year?

```sql
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;
```

![images](images/Ranking.png)

#### 3. Data Visualization

#### 4. Insights and Findings

### Tools

### Deliverables
