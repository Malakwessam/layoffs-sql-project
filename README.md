# layoffs-sql-project
SQL Data Cleaning &amp; EDA on Global Layoffs Dataset
 Global Layoffs – SQL Data Cleaning & EDA
A SQL‑only project analyzing global layoffs through a complete data‑cleaning pipeline and exploratory analysis. This project demonstrates practical SQL skills including deduplication, standardization, date handling, null imputation, window functions, and aggregated insights.

Project Overview
This project transforms a messy layoffs dataset into a clean, analysis‑ready table and uses SQL to explore trends across years, countries, and companies. The work includes:

Creating staging tables for safe data manipulation
Removing duplicates using window functions
Standardizing inconsistent text fields
Converting dates to proper formats
Handling missing values intelligently
Performing EDA (yearly, monthly, country trends, rolling totals, rankings)


Data Cleaning Summary

Identified and removed duplicate records using ROW_NUMBER().
Trimmed and standardized company, country, and industry fields.
Converted dates from text to SQL DATE.
Replaced empty strings with NULLs and filled missing industries using company + location.
Deleted rows with no meaningful layoff information.


EDA Summary

Layoffs aggregated by year, country, and month.
Rolling totals show a strong upward trend, peaking by 2023.
Company rankings (using DENSE_RANK()) highlight top layoff contributors each year.
Clear patterns show the U.S. leading layoffs by a large margin.


Tools & SQL Features

MySQL
CTEs (WITH)
Window functions: ROW_NUMBER(), DENSE_RANK(), SUM OVER
Aggregations: SUM, COUNT
Text cleaning: TRIM, pattern matching
Date parsing and type conversion
Self‑joins for imputing missing values



Key Insights

Layoffs peaked in 2022, contributing the largest single‑year total.
The United States experienced far more layoffs than any other country.
Cumulative layoffs exceeded 380,000 by 2023.
Top companies varied by year (Uber in 2020, Bytedance in 2021).

for more details,open the document
