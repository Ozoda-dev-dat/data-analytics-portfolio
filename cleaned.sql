-- -- SQL loyihasi - ma'lumotlarni tozalash
-- SELECT * FROM layoffs

-- -- Yangi table yaratib layoffs malumotlarini yangi tablega kochirib olamiz
-- DROP TABLE IF EXISTS world_layoffs;

-- CREATE TABLE world_layoffs
-- AS TABLE layoffs WITH NO DATA;

-- INSERT INTO world_layoffs 
-- SELECT * FROM layoffs;


-- -- cleaning data ...
-- -- 1. dublikatlarni tekshiring va ularni olib tashlash
-- -- 2. ma'lumotlarni standartlashtirish va xatolarni tuzatish
-- -- 3. Null qiymatlarga aniqlash va 0 soniga almashtirish
-- -- 4. kerak bo'lmagan ustun va qatorlarni olib tashlash - kerak bo'lsa


-- -- 1. Dublikatlarni olib tashlash
-- -- Avval dublikatlarni tekshiramiz
-- SELECT *
-- FROM (
-- 	SELECT company, industry, "total_laid_off	", "date",
-- 		ROW_NUMBER() OVER (
-- 			PARTITION BY company, industry, "total_laid_off	", "date"
-- 			) AS row_num
-- 	FROM 
-- 		world_layoffs
-- ) duplicates
-- WHERE 
-- 	row_num > 1;

	
-- -- endi dublikatlarni o'chirib tashlaymiz

-- DELETE FROM world_layoffs
-- WHERE ctid IN (
--     SELECT ctid FROM (
--         SELECT ctid, 
--                ROW_NUMBER() OVER (
--                    PARTITION BY company, industry, "total_laid_off	", "date"
--                ) AS row_num
--         FROM world_layoffs
--     ) t
--     WHERE row_num > 1
-- );


-- SELECT *
-- FROM world_layoffs
-- WHERE company = 'Oda'
-- ;


-- SELECT *
-- FROM (
-- 	SELECT company, location, industry, "total_laid_off	",percentage_laid_off,"date", stage, country, funds_raised_millions,
-- 		ROW_NUMBER() OVER (
-- 			PARTITION BY company, location, industry, "total_laid_off	",percentage_laid_off,"date", stage, country, funds_raised_millions
-- 			) AS row_num
-- 	FROM 
-- 		world_layoffs
-- ) duplicates
-- WHERE 
-- 	row_num > 1;



-- 1. Yangi jadval yaratish
CREATE TABLE layoffs_cleaned (
    id SERIAL PRIMARY KEY,
    company TEXT NOT NULL,
    location TEXT,
    industry TEXT,
    total_laid_off INTEGER CHECK (total_laid_off >= 0),
    percentage_laid_off DECIMAL CHECK (percentage_laid_off BETWEEN 0 AND 1),
    date DATE,
    stage TEXT,
    country TEXT,
    funds_raised_millions DECIMAL CHECK (funds_raised_millions >= 0)
);

-- 2. Ma'lumotlarni toza shaklda yuklash
INSERT INTO layoffs_cleaned (company, location, industry, total_laid_off, 
                             percentage_laid_off, date, stage, country, 
                             funds_raised_millions)
SELECT 
    company, 
    location, 
    industry, 
    NULLIF("total_laid_off	", 'NULL')::INTEGER, 
    NULLIF(percentage_laid_off, 'NULL')::DECIMAL, 
    TO_DATE(NULLIF(date, 'NULL'), 'MM/DD/YYYY'), 
    stage, 
    country, 
    NULLIF(funds_raised_millions, 'NULL')::DECIMAL
FROM layoffs;

-- 3. Qaytarilayotgan (dublikatsiya) yozuvlarni olib tashlash
DELETE FROM layoffs_cleaned
WHERE id NOT IN (
    SELECT MIN(id) FROM layoffs_cleaned 
    GROUP BY company, location, date
);

-- 4. Bo‘sh qiymatlarni to‘g‘rilash
UPDATE layoffs_cleaned
SET total_laid_off = COALESCE(total_laid_off, 0),
    percentage_laid_off = COALESCE(percentage_laid_off, 0),
    funds_raised_millions = COALESCE(funds_raised_millions, 0);

UPDATE layoffs_cleaned
SET stage = 'Malumot yo‘q'
WHERE stage = 'Unknown';


SELECT * FROM layoffs_cleaned;