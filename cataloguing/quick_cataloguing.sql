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
        Change it based on your library's call number system.
     2. Terminology:
        - EXCEL: usually refers to overall records
        - DDC: usually refers to item call number / category / prefix
     3. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT (SELECT barcode FROM items ORDER BY barcode DESC LIMIT 1) as EXCEL_LastBarcode, 
barcode as DDC_LastBarcode, 
itemcallnumber as LastDDC 
FROM items 
WHERE itemcallnumber LIKE 'YS: ENG 050.L1%' 
ORDER BY 
    IF(
        RIGHT(itemcallnumber, 3) LIKE '%nd%' 
        OR RIGHT(itemcallnumber, 3) LIKE '%na%',
        LEFT(RIGHT(itemcallnumber, 6), 3),
        LEFT(RIGHT(itemcallnumber, 8), 3)
    ) DESC
LIMIT 1
