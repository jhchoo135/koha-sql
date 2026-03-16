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
     1. Results include only items borrowed by students (b.categorycode = 'ST').
        Remove or edit 'AND s.categorycode = 'ST'' as required.

     2. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT barcode, 
       onloan AS DueDate, 
       ROUND(ABS(DATEDIFF(CURDATE(), onloan)) 
             - ABS(DATEDIFF(ADDDATE(CURDATE(), INTERVAL 1 - DAYOFWEEK(CURDATE()) DAY), 
                            ADDDATE(onloan, INTERVAL 1 - DAYOFWEEK(onloan) DAY))) / 7 * 2
             - (DAYOFWEEK(IF(onloan < CURDATE(), onloan, CURDATE())) = 1)
             - (DAYOFWEEK(IF(onloan > CURDATE(), onloan, CURDATE())) = 7)) 
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
         FROM repeatable_holidays) AS DaysLate,
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
              ) AS Fine
     FROM items i 
JOIN 
    issues iss ON i.itemnumber = iss.itemnumber
JOIN 
    borrowers b ON iss.borrowernumber = b.borrowernumber
     WHERE onloan IS NOT NULL AND onloan < CURDATE()
     AND b.categorycode = 'ST'
