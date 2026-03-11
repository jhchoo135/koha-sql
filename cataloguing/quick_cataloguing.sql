/*
   File: quick_cataloguing.sql

   Purpose:
     Retrieves:
       1. Last barcode used in the system
       2. Last barcode used within the given category/prefix
       3. Last item call number (category/prefix)

   Author: JH Choo
   Created: 2025-11-23

   Notes:
     1. 'YS: ENG 050.L1' is used as an example in this query.
        Change it based on your library's call number system and
        the category / prefix / item call number required.

     2. Terminology:
        - EXCEL: usually refers to overall records
        - DDC: usually refers to item call number / category / prefix

     3. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT
   
-- Line below gets the very last barcode used in the system
(SELECT barcode FROM items ORDER BY barcode DESC LIMIT 1) as excel_last_barcode,

-- Line below gets last barcode of prefix / category / itemcallnumber given
barcode as ddc_last_barcode, 

-- Line below gets last itemcallnumber of prefix / category / itemcallnumber given   
itemcallnumber as last_ddc
FROM items

-- 'YS: ENG 050.L1%' below is an example prefix
-- Can be replaced with any other prefix / category / itemcallnumber
-- eg. 'XXX%'(% allows SQL to match anything that follows the prefix)
WHERE itemcallnumber LIKE 'YS: ENG 050.L1%' 
ORDER BY 
   
    -- Below IF(...) logic is based on list_items_by_callnumber_original.sql
    -- This version is fragile (relies on itemcallnumber character positions)
    -- Recommended to replace the IF(...) logic with everything under ORDER BY from
    -- list_items_by_callnumber.sql
    IF(
        RIGHT(itemcallnumber, 3) LIKE '%nd%' 
        OR RIGHT(itemcallnumber, 3) LIKE '%na%',
        LEFT(RIGHT(itemcallnumber, 6), 3),
        LEFT(RIGHT(itemcallnumber, 8), 3)
    ) 

-- 'DESC' arranges 'YS: ENG 050.L1%' in descending order
-- 'LIMIT 1' gets the very top record after arrangement
DESC LIMIT 1
