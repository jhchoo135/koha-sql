/*
   File: list_items_by_callnumber_original1.sql

   Purpose:
      Retrieves the following fields:
        1. Barcode 
        2. Item Call Number
      Arranged by given category / prefix / item call number.

    Note: 
      This query is quite fragile. 
      Instead of using delimiters (e.g., '-', '.') to locate positions, 
      it relies on the number of itemcallnumber characters. 
      
      If the itemcallnumber data format changes even slightly, 
      the query may not work properly. 
      
      This was the initial approach before switching to delimiters 
      (list_items_by_callnumber.sql now uses delimiters).

   Author: JH Choo
   Created: 2025-11-23

   Notes:
     1. 'YS: ENG 050.L1' is used as an example in this query.
        Change it based on your library's call number system and
        the category / prefix / item call number required.

     2. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT 
    barcode,
    itemcallnumber
FROM items
-- 'YS: ENG 050.L1%' below is an example prefix
-- Can be replaced with any other prefix / category / itemcallnumber
-- eg. 'XXX%'(% allows SQL to match anything that follows the prefix)
WHERE itemcallnumber LIKE 'YS: ENG 050.L1%'
ORDER BY 
    -- If itemcallnumber ends with 'na' or 'nd'
    -- eg. 'JF-B823.B43.016.na' or 'JF-B823.B88.032.nd'
    -- RIGHT(..., 6) gets '016.na' / '032.nd'
    -- LEFT(...,3) gets '016' / '032'
    -- If it does NOT end with 'na' or 'nd'
    -- eg. 'JF-B823.B85.048.2012'
    -- RIGHT(..., 8) gets '048.2012'
    -- LEFT(...,3) gets '048'
    -- The itemcallnumber is arranged by the '016' / '032' / '048' part
    IF(
        RIGHT(itemcallnumber, 3) LIKE '%nd%' 
        OR RIGHT(itemcallnumber, 3) LIKE '%na%', 
        LEFT(RIGHT(itemcallnumber, 6), 3), 
        LEFT(RIGHT(itemcallnumber, 8), 3)
    )
