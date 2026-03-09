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
    -- The SQL sentence below gets 77 from 'F-S823.S85.077.2011' 
    -- SUBSTRING_INDEX(..., '.', 3) gets 'F-S823.S85.077'
    -- SUBSTRING_INDEX(..., '.', -1) gets only '077' 
    -- CAST(... AS UNSIGNED) converts '077' into the number 77
    -- The itemcallnumber is arranged by the '077' part
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, '.', 3), '.', -1) AS UNSIGNED),

    -- If the itemcallnumber has 'Box', get the number after 'Box' for ordering
    -- eg. it gets 1 from 'TR-420.S36.220.nd Box 1'
    -- SUBSTRING_INDEX(..., 'Box', -1) gets ' 1'
    -- SUBSTRING_INDEX(..., ' ', -1) gets '1'
    -- CAST(... AS UNSIGNED) converts '1' into the number 1
    -- The itemcallnumber is arranged by the '1' part
    -- Other itemcallnumber not affected if no 'Box'
   CASE 
        WHEN itemcallnumber LIKE '%Box%' THEN
            CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, 'Box', -1), ' ', -1) AS UNSIGNED)
        ELSE 0
    END,

    -- The SQL sentence below gets 2 from 'F-S823.S65.089.2.2017' 
    -- SUBSTRING_INDEX(..., '.', 4) gets 'F-S823.S65.089.2'
    -- SUBSTRING_INDEX(..., '.', -1) gets only '2' 
    -- CAST(... AS UNSIGNED) converts '2' into the number 2
    -- The itemcallnumber is now arranged by the '2' part
    -- 'F-S823.S85.077.2011' that was arranged earlier is not affected
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, '.', 4), '.', -1) AS UNSIGNED),
   
    -- Only for YS: ENG / YS: CHI items
    -- eg. 'YS: ENG 050.L1-173.2018' or 'YS: CHI 050.L4-03.2022'
    -- The part below sorts by L1, L2, L3, L4
    -- SUBSTRING_INDEX(..., 'L', -1) gets '1-173.2018' or '4-03.2022'
    -- SUBSTRING_INDEX(..., '-', -1) gets '1' or '4'
    -- CAST(... AS UNSIGNED) converts '1' into the number 1 or '4' into the number 4
    -- This arranges all L1 together, then L2, L3, L4, etc.
    CASE
          WHEN itemcallnumber LIKE 'YS: ENG%' OR itemcallnumber LIKE 'YS: CHI%' THEN
           CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, 'L', -1), '-', 1) AS UNSIGNED)
          ELSE 0
      END,

    -- Only for YS: ENG / YS: CHI items
    -- eg. 'YS: ENG 050.L1-173.2018' or 'YS: CHI 050.L4-03.2022'
    -- SUBSTRING_INDEX(..., '-', -1) gets '173.2018' or '03.2022'
    -- SUBSTRING_INDEX(..., '.', 1) gets '173' or '03'
    -- CAST(... AS UNSIGNED) converts '173' into the number 173 or '03' into the number 3
    -- This itemcallnumber for YS:ENG / YS:CHI is now arranged by the '173' or '03' part
    CASE
          WHEN itemcallnumber LIKE 'YS: ENG%' OR itemcallnumber LIKE 'YS: CHI%' THEN
           CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, '-', -1), '.', 1) AS UNSIGNED)
          ELSE 0
       END
