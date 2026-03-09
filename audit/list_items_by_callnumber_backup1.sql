/*
   File: list_items_by_callnumber_backup1.sql

   Purpose:
      Retrieves the following fields:
        1. Barcode 
        2. Item Call Number
      Arranged by given category / prefix / item call number.

    Note: This query may not work in certain situations,
        e.g., our library's Young Scientists' category.

   Author: JH Choo
   Created: 2025-11-23

   Notes:
     1. '895.1.' and '495.1.' are used as examples in this query.
        In this case, a category had two different prefixes 
        (e.g., '895.1.' and '495.1.' in our library).
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
-- OR is used below as both '895.1.' and '495.1.' both refer to the same category
WHERE itemcallnumber LIKE '895.1.%' OR itemcallnumber LIKE '495.1.%'
ORDER BY 
    -- The SQL sentence below gets 77 from 'F-S823.S85.077.2011' 
    -- SUBSTRING_INDEX(..., '.', 3) gets 'F-S823.S85.077'
    -- SUBSTRING_INDEX(..., '.', -1) gets only '077' 
    -- CAST(... AS UNSIGNED) converts '077' into the number 77
    -- The itemcallnumber is arranged by the '077' part
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, '.', 3), '.', -1) AS UNSIGNED),
                                           
    -- The SQL sentence below gets 564 from '895.1.A65.564.2020' 
    -- SUBSTRING_INDEX(..., '.', 4) gets '895.1.A65.564'
    -- SUBSTRING_INDEX(..., '.', -1) gets only '564' 
    -- CAST(... AS UNSIGNED) converts '564' into the number 564
    -- The itemcallnumber is now arranged by the '564' part
    -- 'F-S823.S85.077.2011' that was arranged earlier is not affected
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(itemcallnumber, '.', 4), '.', -1) AS UNSIGNED) ASC
