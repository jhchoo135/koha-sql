/*
   File: count_items_by_category.sql

   Purpose:
   Lists the number of items in each category / prefix / itemcallnumber.

   Author: JH Choo
   Created: 2025-11-23

   Notes:
     1. If a new category is added, kindly update this query.
        For example, the category / prefix 'XLL' exists in the library
        but was not included in this query.

     2. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT 
COUNT(CASE WHEN itemcallnumber LIKE 'JNF/%' THEN 1 END) AS 'Junior Non-Fiction Series Total',

-- Line below excludes Junior Fiction Series ('JF-S' prefix) from the count, since it has its own category
-- 'JF-S823.' is a Junior Fiction prefix for non-series items (for authors' surname/publishers/titles beginning with 'S')
-- Without 'AND NOT itemcallnumber LIKE 'JF-S823.%'', all 'JF-S823.' would be incorrectly subtracted
(COUNT(CASE WHEN itemcallnumber LIKE 'JF-%' THEN 1 END) - COUNT(CASE WHEN itemcallnumber LIKE 'JF-S%' AND NOT itemcallnumber LIKE 'JF-S823.%' THEN 1 END)) AS 'Junior Fiction Total',

-- Line below excludes 'JF-S823.' (Junior Fiction prefix for non-series items for authors' surname/publishers/titles beginning with 'S')   
COUNT(CASE WHEN itemcallnumber LIKE 'JF-S%' AND NOT itemcallnumber LIKE 'JF-S823.%' THEN 1 END) AS 'Junior Fiction Series Total',

COUNT(CASE WHEN itemcallnumber LIKE 'JNF-%' THEN 1 END) AS 'Junior Non-Fiction Total',

-- Line below counts Non-Fiction items ('NF' prefix) but excludes Reference items ('NF/REF' prefix)
COUNT(CASE WHEN itemcallnumber LIKE 'NF%' AND NOT itemcallnumber LIKE 'NF/REF%' THEN 1 END) AS 'Non-Fiction Total',
   
COUNT(CASE WHEN itemcallnumber LIKE 'NF/REF-%' THEN 1 END) AS 'Reference Total',
COUNT(CASE WHEN itemcallnumber LIKE 'BC %' THEN 1 END) AS 'Big Cat Total',

-- Line below includes both '985.1' and '495.1' prefixes due to partially implemented prefix changes 
COUNT(CASE WHEN itemcallnumber LIKE '895.1.%' OR itemcallnumber LIKE '495.1.%' THEN 1 END) AS 'Chinese General Total',

-- 'SC CHI' refers to Science/Educational Chinese Comics, while 'CSC' refers to 'Chinese Serial Comics'
COUNT(CASE WHEN itemcallnumber LIKE 'SC CHI%' OR itemcallnumber LIKE 'CSC %' THEN 1 END) AS 'Chinese Comic Total',
   
COUNT(CASE WHEN itemcallnumber LIKE 'YS: CHI%' THEN 1 END) AS 'Chinese Young Scientist Total',
COUNT(CASE WHEN itemcallnumber LIKE 'AB:%' THEN 1 END) AS 'Adventure Box Total',
COUNT(CASE WHEN itemcallnumber LIKE 'ABMAX%' THEN 1 END) AS 'Adventure Box Max Total',
COUNT(CASE WHEN itemcallnumber LIKE 'DB%' THEN 1 END) AS 'Discovery Box Total',
COUNT(CASE WHEN itemcallnumber LIKE 'SB%' THEN 1 END) AS 'Story Box Total',
COUNT(CASE WHEN itemcallnumber LIKE 'T+S%' THEN 1 END) AS 'Think + Science Total',
COUNT(CASE WHEN itemcallnumber LIKE 'ENG CM%' THEN 1 END) AS 'English Comic Total',
COUNT(CASE WHEN itemcallnumber LIKE 'Sc-502.%' THEN 1 END) AS 'Integrated Thematic Science Total',
COUNT(CASE WHEN itemcallnumber LIKE 'YS: ENG%' THEN 1 END) AS 'English Young Scientist Total',
COUNT(CASE WHEN itemcallnumber LIKE 'SG: MAL%' THEN 1 END) AS 'Malay Educational Comic Total',
COUNT(CASE WHEN itemcallnumber LIKE 'F-%' THEN 1 END) AS 'General Fiction Total',

-- Line below includes both '899.28.' and '499.28.' prefixes due to partially implemented prefix changes 
COUNT(CASE WHEN itemcallnumber LIKE '899.28.%' OR itemcallnumber LIKE '499.28.%' THEN 1 END) AS 'Malay Fiction Total',
   
COUNT(CASE WHEN itemcallnumber LIKE 'TR-%' THEN 1 END) AS 'Teacher Resource Total',
COUNT(CASE WHEN itemcallnumber LIKE 'YAF-%' THEN 1 END) AS 'Young Adult Fiction Total'
FROM items
