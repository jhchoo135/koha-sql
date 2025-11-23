/*
   File: find_unused_barcodes.sql

   Purpose:
   Lists gaps between barcodes in the system within a specified range (between 0 AND 10000).
   Useful for identifying unused barcodes in sequential runs.

   Author: Online Source
   Created: 2025-11-23

   Notes:
     1. Adjust the range in the query (0, 10000) as needed.
     2. Works for barcodes that are numeric and sequential.
     3. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT 
    (i1.barcode + 1) AS gap_starts_at,
    (SELECT MIN(i3.barcode) - 1 
     FROM items i3 
     WHERE i3.barcode > i1.barcode) AS gap_ends_at
FROM items i1
WHERE i1.barcode BETWEEN 0 AND 10000
  AND NOT EXISTS (
      SELECT i2.barcode 
      FROM items i2 
      WHERE i2.barcode = i1.barcode + 1
  )
HAVING gap_ends_at IS NOT NULL
