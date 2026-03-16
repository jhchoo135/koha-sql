/*
   File: fines_calculation.sql

   Purpose:
    Calculates the number of days overdue and the fines incurred for each overdue item.

    Retrieves the following fields:
               1) barcode: barcode of the overdue item
               2) due_date: due date of the item
               3) days_late: number of days the item is overdue
               4) fine: total fine accumulated for the item (RM 0.50 per day)

   Author: Online Source, edited by JH Choo
   Created: 2025-11-23

   Notes:
     1. Query only works for items that have not yet been returned.

         The library generally runs this query first thing in the morning and 
         does not refresh it throughout the day.

     2. Results include only items borrowed by students (b.categorycode = 'ST').
        Remove or edit 'AND s.categorycode = 'ST'' as required.

     3. Fines are not calculated when the library is closed,
        eg. on Saturdays, Sundays, holidays, including term breaks.

        This query will only work if the library holidays and closing days have been set in KOHA.

        Overdue fine is RM0.50 per day.

     4. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT barcode, 
       onloan AS due_date,

       -- Calculates the number of days the item is overdue
       ROUND(ABS(DATEDIFF(CURDATE(), onloan)) 

               -- Gets the date of Sundays of the week for the current date and the due date,
               -- then calculates the number of days between the two Sundays.
               -- The result is divided by 7 to calculate how many weeks there are.
               -- ABS rounds off the result of the division to a round number.
               -- Results is later multiplied by 2 because a week has 2 weekends.
             - ABS(DATEDIFF(ADDDATE(CURDATE(), INTERVAL 1 - DAYOFWEEK(CURDATE()) DAY), 
                            ADDDATE(onloan, INTERVAL 1 - DAYOFWEEK(onloan) DAY))) / 7 * 2

                -- If due date is earlier than current date, get due date and check if it's a Sunday.
                -- If due date is later than current date, get current date and check if it's a Sunday.
                -- If it's a Sunday, result is 1. Otherwise, 0.
             - (DAYOFWEEK(IF(onloan < CURDATE(), onloan, CURDATE())) = 1)

                -- If due date is later later than the current date, get due date and check if it's a Saturday.
                -- If due date is earlier than current date, get current date and check if it's a Saturday.
                -- If it's a Satruday, result is 1. Otherwise, 0.
             - (DAYOFWEEK(IF(onloan > CURDATE(), onloan, CURDATE())) = 7))

        -- Retrieves special holidays that do not fall on Saturday or Sundays from the special_holidays table 
        -- and counts them if they fall between the due date and the current date.
        -- The special_holidays table stores year, month, and day of the holidays separately,
        -- so the values need to be concatenated and converted into DATE format (YYYY-MM-DD) for comparisons.
     - (SELECT COUNT(CASE WHEN DATE(CONCAT(year, "-", LPAD(month,2,'0'), "-", LPAD(day,2,'0'))) 
                     
                     -- Checks if the special holiday falls between the due date and the current date
                     BETWEEN onloan AND CURDATE()

                     -- Excludes special holidays that fall on Saturdays (5) and Sundays (6)
                     AND WEEKDAY(DATE(CONCAT(year, "-", LPAD(month,2,'0'), "-", LPAD(day,2,'0')))) != 6 
                     AND WEEKDAY(DATE(CONCAT(year, "-", LPAD(month,2,'0'), "-", LPAD(day,2,'0')))) != 5 THEN 1 END) 
         FROM special_holidays)

        -- Retrieves repeating holidays that are not based on a specific weekday
        -- eg. fixed-date holidays like 1st of January.
        -- The repeatable_holidays table stores year, month, and day of the holidays separately,
        -- so the values need to be concatenated and converted into DATE format (YYYY-MM-DD) for comparisons.
     - (SELECT COUNT(CASE WHEN weekday IS NULL 
                     AND DATE(CONCAT(CONVERT(YEAR(CURDATE()), CHAR), "-", LPAD(month,2,'0'), "-", LPAD(day,2,'0'))) 
                     
                     -- Checks if the repeating holiday falls between the due date and the current date
                     BETWEEN onloan AND CURDATE() 

                     -- Excludes repeating holidays that fall on Saturdays (5) and Sundays (6)
                     AND WEEKDAY(DATE(CONCAT(CONVERT(YEAR(CURDATE()), CHAR), "-", LPAD(month,2,'0'), "-", LPAD(day,2,'0')))) != 6 
                     AND WEEKDAY(DATE(CONCAT(CONVERT(YEAR(CURDATE()), CHAR), "-", LPAD(month,2,'0'), "-", LPAD(day,2,'0')))) != 5 THEN 1 END) 
         FROM repeatable_holidays) AS days_late,

     -- Similar to the calculation for days_late, 
     -- except that the currency ("RM") is concatenated at the front
     -- and multiplied by 0.50 at the end to calculate the fine amount.
     CONCAT("RM", (ROUND(ABS(DATEDIFF(CURDATE(), onloan))
                         - ABS(DATEDIFF(ADDDATE(CURDATE(), INTERVAL 1 - DAYOFWEEK(CURDATE()) DAY),
                                        ADDDATE(onloan, INTERVAL 1 - DAYOFWEEK(onloan) DAY))) / 7 * 2
                         - (DAYOFWEEK(IF(onloan < CURDATE(), onloan, CURDATE())) = 1)
                         - (DAYOFWEEK(IF(onloan > CURDATE(), onloan, CURDATE())) = 7) 
                         - (SELECT COUNT(CASE WHEN DATE(CONCAT(year, "-", LPAD(month,2,'0'), "-", LPAD(day,2,'0'))) 
                                         BETWEEN onloan 
                                         AND CURDATE() 
                                         AND WEEKDAY(DATE(CONCAT(year, "-", LPAD(month,2,'0'), "-", LPAD(day,2,'0')))) != 6 
                                         AND WEEKDAY(DATE(CONCAT(year, "-", LPAD(month,2,'0'), "-", LPAD(day,2,'0')))) != 5 THEN 1 END) 
                            FROM special_holidays) 
                         - (SELECT COUNT(CASE WHEN weekday IS NULL 
                                         AND DATE(CONCAT(CONVERT(YEAR(CURDATE()), CHAR), "-", LPAD(month,2,'0'), "-", LPAD(day,2,'0'))) 
                                         BETWEEN onloan 
                                         AND CURDATE() 
                                         AND WEEKDAY(DATE(CONCAT(CONVERT(YEAR(CURDATE()), CHAR), "-", LPAD(month,2,'0'), "-", LPAD(day,2,'0')))) != 6 
                                         AND WEEKDAY(DATE(CONCAT(CONVERT(YEAR(CURDATE()), CHAR), "-", LPAD(month,2,'0'), "-", LPAD(day,2,'0')))) != 5 THEN 1 END) 
                            FROM repeatable_holidays)
                        ) * 0.50
                    )
              ) AS fines
     FROM items i 

-- Since only student overdues are retrieved, 
-- the items table and issues table are connected 
-- with having itemnumber as a reference point, 
-- so that the borrowers table can be later joined with issues table 
-- with having borrowernumber as a reference point.
JOIN 
    issues iss ON i.itemnumber = iss.itemnumber
JOIN 
    borrowers b ON iss.borrowernumber = b.borrowernumber

     -- Only items that are currently borrowed
     WHERE onloan IS NOT NULL

     -- Only items that are overdue
     AND onloan < CURDATE()

     -- Only items borrowed by students
     AND b.categorycode = 'ST'
