/*
   File: list_items_by_callnumber3.sql

   Purpose:
      Retrieves the following by category / prefix / item call number:
        1. Barcode 
        2. Item Call Number
    Note: This query may not work in certain situations,
        e.g., our library's TR-420 category.

   Author: JH Choo
   Created: 2025-11-23

   Notes:
     1. 'YS: ENG 050.L1' is used as an example in this query.
        Change it based on your library's call number system.
     2. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT 
    barcode,
    itemcallnumber
FROM items
WHERE itemcallnumber LIKE 'YS: ENG 050.L1%'
ORDER BY 
    IF(
        RIGHT(itemcallnumber, 3) LIKE '%nd%' 
        OR RIGHT(itemcallnumber, 3) LIKE '%na%', 
        LEFT(RIGHT(itemcallnumber, 6), 3), 
        LEFT(RIGHT(itemcallnumber, 8), 3)
    )
