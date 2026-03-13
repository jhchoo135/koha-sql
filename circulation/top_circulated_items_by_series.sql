/*
   File: top_circulated_items_by_series.sql

   Purpose:
    Lists items most frequently circulated by students within a given time period, grouped by series. 
    If an item is not part of a series or the MARC 490 field is empty, the item title is displayed instead.

    Retrieves the following fields:
               1) circs: number of times books had been borrowed
               2) title: series title (or item title if no series)

   Author: JH Choo
   Created: 2025-11-23

   Notes:
     1. '2025-01-01' and '2025-02-19' are examples used in this query.
         Adjust the dates as needed.

     2. 's.type = 'issue'' refers to books being borrowed.
         Books are counted once they are checked out within the specified time period, 
         even if they have not yet been returned.

     3. Results include only items borrowed by students (s.categorycode = 'ST').
        Remove or edit 'AND s.categorycode = 'ST'' as required.

     4. LIMIT 10 is to get the top 10 series/titles.
        Adjust the limit (10) in the query as needed.

     5. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

-- First line counts how many times books had been borrowed
SELECT count(s.datetime) AS circs, 

  -- Checks if MARC 490 field is empty
  -- If MARC 490 field is empty, it gets the item title
  -- If MARC 490 field is NOT empty, gets series title from MARC 490 field
  -- [1] retrieves the first 490 field found for that item
  CASE 
        WHEN ExtractValue(a.metadata, '//datafield[@tag="490"][1]/subfield[@code="a"]') = ''
        THEN b.title
        ELSE ExtractValue(a.metadata, '//datafield[@tag="490"][1]/subfield[@code="a"]')
    END AS title

-- Data is obtained from statistics, items, biblio and biblio_metadata tables
-- datetime, itemnumber, type, categorycode are data taken from statistics
FROM statistics s

-- The reference point for both items and statistics tables is itemnumber
-- itemnumber, biblionumber are data taken from statistics
-- items table is used to connect between statistics, biblio, and biblio_metadata tables
JOIN items i ON (i.itemnumber=s.itemnumber)

-- The reference point for both biblio and items tables are biblionumber
-- title, biblionumber are data taken from biblio
LEFT JOIN biblio b ON (b.biblionumber=i.biblionumber)

-- The reference point for both biblio_metadata and items tables are biblionumber
-- metadata, biblionumber are data taken from biblio_metadata
LEFT JOIN biblio_metadata a ON (a.biblionumber = i.biblionumber)

-- '2025-01-01' and '2025-02-19' are sample dates
-- Replace with the required date range for filtering
WHERE DATE(s.datetime) BETWEEN '2025-01-01' AND '2025-02-19'

-- This only filters books that had been borrowed regardless of if it has been returned or not
AND s.type = 'issue'

-- To retrieve books borrowed by students only
AND s.categorycode = 'ST'

-- Can be removed, as the inner join (JOIN) on items already ensures itemnumber is not NULL
AND s.itemnumber IS NOT NULL

-- Groups titles by series title
GROUP BY 
    CASE 
        WHEN ExtractValue(a.metadata, '//datafield[@tag="490"][1]/subfield[@code="a"]') = ''
        THEN b.title
        ELSE ExtractValue(a.metadata, '//datafield[@tag="490"][1]/subfield[@code="a"]')
    END

-- Results are ordered by number of times borrowed
-- LIMIT 10 limits the results to the top 10 most borrowed series/items
-- LIMIT can be adjusted as required
ORDER BY circs DESC
LIMIT 10
