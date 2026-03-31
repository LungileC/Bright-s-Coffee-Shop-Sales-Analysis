--This is just to check if the table is loaded correctly and i am able to read it properly
select * 
from `workspace`.`default`.`bright_coffee_shop_sales` 
limit 10;




-----------------------------------------------------------
---1. Checking the date range
-----------------------------------------------------------

-- They started collecting the data on 2023-01-01
SELECT MIN(Transaction_Date) AS start_date
from `workspace`.`default`.`bright_coffee_shop_sales`;





--When Last did they collect the data on 2023-06-30
SELECT MAX(Transaction_Date) AS latest_date
from `workspace`.`default`.`bright_coffee_shop_sales`;



----------------------------------------------------------
---2. Checking the names of the store location
-----------------------------------------------------------
-- we have 3 store locations Lower Manhattan, Hells's Kitchen and Astoria
SELECT DISTINCT store_location
FROM `workspace`.`default`.`bright_coffee_shop_sales`;



-----------------------------------------------------------
---3. Checking products sold across all stores
-----------------------------------------------------------

select distinct product_category
from `workspace`.`default`.`bright_coffee_shop_sales`;



select distinct product_detail
from `workspace`.`default`.`bright_coffee_shop_sales`;



select distinct product_type
from `workspace`.`default`.`bright_coffee_shop_sales`;



select distinct product_detail As Product_name,
                product_type AS type,
                product_category AS category
from `workspace`.`default`.`bright_coffee_shop_sales`;



-----------------------------------------------------------
---3. Checking products Prices
-----------------------------------------------------------
select Min(unit_price) as cheapest_price
From workspace.default.bright_coffee_shop_sales;



Select Max(Unit_price) As Expensive_price
from workspace.default.bright_coffee_shop_sales;


-----------------------------------------------------
SELECT count(*) As number_of_rows,
       Count(distinct transaction_id) As number_of_sales,
       count(distinct store_id) AS number_of_stores,
       count(distinct product_id) AS number_of_products
FROM workspace.default.bright_coffee_shop_sales;


-----------------------------------------------------
Select*
from `workspace`.`default`.`bright_coffee_shop_sales`
limit 10;



Select  transaction_id,
        transaction_date,
        dayname(transaction_date) as day_name,
        Monthname(transaction_date) as month_name,
        transaction_qty*unit_price as revenue_per_Tnx
from `workspace`.`default`.`bright_coffee_shop_sales`;


----------------------------------------------------------
select Count(*)
from `workspace`.`default`.`bright_coffee_shop_sales`;



Select  
        transaction_date,
        dayname(transaction_date) as day_name,
        Monthname(transaction_date) as month_name,
        Count(distinct transaction_id) As number_of_sales,
        SUM(transaction_qty*unit_price) as revenue_per_Tnx
from `workspace`.`default`.`bright_coffee_shop_sales`
Group by transaction_date, dayname(transaction_date), Monthname(transaction_date);



Select  
-- Dates 
        transaction_date,
        dayname(transaction_date) as day_name,
        Monthname(transaction_date) as month_name,
        DayofMonth(transaction_date) as day_of_month,

        Case 
            When day_name IN ('Sun' ,'Sat') then 'Weekend'
            Else 'Weekday'
            End As day_classification,

--date_format(transaction_time,'HH:mm:ss') as purchase_time,
         case 
                When date_format(transaction_time, 'HH:mm:ss') between '00:00:00' and '11:59:59' then '01.Morning'
                When date_format(transaction_time, 'HH:mm:ss') between '12:00:00' and '16:59:59' then '02.Afternoon'
                When date_format(transaction_time, 'HH:mm:ss') >= '17:00:00' then '03.Evening'
                End As time_buckets,

--Count of IDS
Count(distinct transaction_id) AS number_of_sales,
Count(distinct store_id) as number_of_stores,
Count(distinct product_id) as number_of_products,
--Revenue
Sum(transaction_qty*unit_price) as revenue_per_day,

        Case 
                When Revenue_per_day <=50 Then '01.Low_spend'
                When Revenue_per_day between 51 and 100 Then '02.Medium_spend'
                Else '03.High_spend'
                end as spend_buckets,

--Categorical Colomn 
        store_location,
        product_category,
        product_detail 
from `workspace`.`default`.`bright_coffee_shop_sales`
Group by 
        transaction_date,
        dayname(transaction_date),
        Monthname(transaction_date),
        DayofMonth(transaction_date),
        Case 
            When dayname(transaction_date) IN ('Sun' ,'Sat') then 'Weekend'
            Else 'Weekday'
            End,

        store_location,
        product_category,
        product_detail,
       
        case 
                When date_format(transaction_time, 'HH:mm:ss') between '00:00:00' and '11:59:59' then '01.Morning'
                When date_format(transaction_time, 'HH:mm:ss') between '12:00:00' and '16:59:59' then '02.Afternoon'
                When date_format(transaction_time, 'HH:mm:ss') >= '17:00:00' then '03.Evening'
                End;
