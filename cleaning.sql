#--data cleaning 
-- 1.remove duplicates
-- 2.standardize the data
-- 3.null values or blank values
-- 4.remove any columns

select *
from layoffs;

-- CREATING TABLE AND INSERTING DATA
create table layoffs_staging
like layoffs;
select*
from layoffs_staging;  -- columns only

insert layoffs_staging
select*
from layoffs;

select*
from layoffs_staging; -- columns and data

-- 1)REMOVING DUPLICATES

-- IDENTIFYING DUPLICATES
select *,
row_number() 
over(partition by company ,location ,industry,total_laid_off ,percentage_laid_off ,`date` ,stage,country,funds_raised_millions)  -- Groups identical rows together Numbers them inside each group
as row_num
from layoffs_staging;   --  WHERE row_num > 1 will not work,because window function results (row_num) cannot be referenced directly in the WHERE clause in the same query.
-- This is due to SQL execution order, where WHERE is processed 
-- before window functions are evaluated.



-- Step 2:CTE to first compute the ROW_NUMBER() values in a separate result set to filter duplicates .
with duplicate_CTE as (
	select *,
	row_number() 
	over(partition by company ,location ,industry,total_laid_off ,percentage_laid_off ,`date` ,stage,country,funds_raised_millions)
	as row_num
	from layoffs_staging)
select *
 from duplicate_CTE
 where row_num >1;  -- cant delete fromm a cte
 
 -- Step 3: Create a new staging table to store cleaned data
-- Added an extra column (row_num) to help filter duplicates
 CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

 
-- Step 4: Insert data into the new table
-- Recalculate ROW_NUMBER() to mark duplicates
insert layoffs_staging2
select *,
row_number() 
over(partition by company ,location ,industry,total_laid_off ,percentage_laid_off ,`date` ,stage,country,funds_raised_millions)
as row_num
from layoffs_staging;

-- Step 5: Delete duplicate rows
-- Keep only the first occurrence (row_num = 1)
delete
from layoffs_staging2
where row_num >1;   

select *
from layoffs_staging2
where row_num >1;


-- 2)STANDRIZATION

update layoffs_staging2
set company = trim(company);

select distinct industry
from layoffs_staging2
order by 1;  

select *
from layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry ='crypto'
where industry like 'crypto%';

select distinct country
from layoffs_staging2
order by 1;


update layoffs_staging2
set country ='United States'   -- i can use trim(trailing '.' from country)
where country like 'United States%';

select `date`, str_to_date(`date`, '%m/%d/%Y') -- m must be small Y must be big
from layoffs_staging2;

update layoffs_staging2
set `date`= str_to_date(`date`, '%m/%d/%Y') ;

alter table layoffs_staging2   -- to convert datatype from text to date after changing its format
modify column `date` date;


-- nulls

select distinct location
from layoffs_staging2
order by 1;


select *
from layoffs_staging2
where industry is null or industry='';

update layoffs_staging2
set industry = null
where industry ='';


select *
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company=t2.company  and t1.location=t2.location
where t1.industry is null and t2.industry is not null;


update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company=t2.company  and t1.location=t2.location
set t1.industry = t2.industry 
where t1.industry is null and t2.industry is not null;


-- deleting 

select *
from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

delete
from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;


#EXPLORATORY DATA ANALYSIS EDA


