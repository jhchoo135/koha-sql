/*
   File: list_items_by_callnumber1.sql

   Purpose:
     Retrieves the following by category / prefix / item call number:
       1. Barcode 
       2. Item Call Number

   Author: JH Choo
   Created: 2025-11-23

   Notes:
     1. 'F-S823' is used as an example in this query.
        Change it based on your library's call number system.
        Do NOT modify the rest of the query... unless you know what you're doing.
     2. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT 
    barcode,
    itemcallnumber
FROM items
WHERE itemcallnumber LIKE 'F-S823%'
ORDER BY
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, '.', 3), '.', -1) AS UNSIGNED),
    CASE 
        WHEN RIGHT(itemcallnumber, 3) LIKE '%Box' THEN
            CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, 'Box', -1), ' ', -1) AS UNSIGNED)
        ELSE 0
    END,
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, '.', 4), '.', -1) AS UNSIGNED),
    CASE
        WHEN itemcallnumber LIKE 'YS: ENG%' OR itemcallnumber LIKE 'YS: CHI%' THEN
            CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, 'L1-', -1), '.', 1) AS UNSIGNED)
        ELSE 0
    END
