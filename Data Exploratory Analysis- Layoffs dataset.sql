-- Exploratory Data Analysis

-- Total layoffs by company
SELECT company, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY Total_laid_off DESC;

-- Total layoffs by industry
SELECT industry, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY Total_laid_off DESC;

-- Total layoffs by company
SELECT country, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY Total_laid_off DESC;

-- Total layoffs by year
SELECT YEAR(`date`), SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY Total_laid_off DESC;

-- total layoffs by stage
SELECT stage, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY Total_laid_off DESC;

-- total layoffs by year and month
SELECT SUBSTRING(`date`, 1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH` ASC;

-- CTE for showing month, total layoffs, and rolling total of layoffs
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

-- Total layoffs by company and year
SELECT company, YEAR(`date`), SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY Total_laid_off DESC;

-- CTE for showing the top five ranking of total layoffs by year and company
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