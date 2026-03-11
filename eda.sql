#EXPLORATORY DATA ANALYSIS EDA
select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 2 desc;


select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;


select substring(`date`,1,7) as month, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by  substring(`date`,1,7)
order by 1 desc;

-- rolling total
with cumulative_total as(
select year(`date`) as date_year, sum(total_laid_off) as total_laid
from layoffs_staging2
group by date_year)
select date_year, total_laid ,sum(total_laid) over(order by date_year) as rolling_total
from cumulative_total;


-- ranking 
with ranking_company as(
select company , year(`date`) as years ,sum(total_laid_off) as total_laid
from layoffs_staging2
group by company , years),filtering_ranking as(
select * , dense_rank() over(partition by years order by  total_laid desc)  as ranking     -- partition by gives rankings inside each year
from ranking_company
where years and total_laid is not null   )
select *
from filtering_ranking
where ranking <=5