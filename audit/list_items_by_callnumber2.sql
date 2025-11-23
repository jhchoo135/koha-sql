/*
   File: list_items_by_callnumber2.sql

   Purpose:
      Retrieves the following by category / prefix / item call number:
        1. Barcode 
        2. Item Call Number
    Note: This query may not work in certain situations,
        e.g., our library's Young Scientists' category.

   Author: JH Choo
   Created: 2025-11-23

   Notes:
     1. 'TR-910' is used as an example in this query.
        Change it based on your library's call number system.
        Repetition occurs in the case of a category having two different prefixes 
        (e.g., '895.1.' AND '495.1.' in our library).
     2. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT 
    barcode,
    itemcallnumber
FROM items
WHERE itemcallnumber LIKE 'TR-910%' OR itemcallnumber LIKE 'TR-910%'
ORDER BY 
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, '.', 3), '.', -1) AS UNSIGNED),
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, '.', 4), '.', -1) AS UNSIGNED) ASC
