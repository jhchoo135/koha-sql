/*
   File: find_unused_barcodes.sql

   Purpose:
   Lists gaps between barcodes in the system within a specified range.
   Useful for identifying unused barcodes in sequence.

   Author: Online Source
   Created: 2025-11-23

   Notes:
     1. Works for barcodes that are numeric and sequential.

     2. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT 
   -- Line below refers to where the missing barcode gap starts
   -- Eg. 1, 2, 3, 5, 6... gap_starts_at = 4
   -- Eg. 1, 6... gap_starts_at = 2
   (i1.barcode + 1) AS gap_starts_at,
   
   -- Lines below refer to where the missing barcode gap ends
   -- Eg. 1, 2, 3, 5, 6... gap_ends_at = 4
   -- Eg. 1, 6... gap_ends_at = 5
   (SELECT MIN(i3.barcode) - 1 
     FROM items i3 
     WHERE i3.barcode > i1.barcode) AS gap_ends_at
FROM items i1

-- The line below only checks for barcodes from 0 to 10000
-- Feel free to change the values as needed
WHERE i1.barcode BETWEEN 0 AND 10000
  
  -- The line below checks if the next barcode after the current i1 barcode exists
  -- Eg. 1, 2, 3, 5, 6... value becomes TRUE only when i2 = 4
  -- Eg. 1, 6... value becomes TRUE only when i2 = 2, 3, 4, 5
  AND NOT EXISTS (
      SELECT i2.barcode 
      FROM items i2 
      WHERE i2.barcode = i1.barcode + 1
  )

-- To make sure only missing barcodes are included
-- Otherwise, a barcode just after the range might be assumed missing, 
-- even though it exists outside the defined range
-- Eg. WHERE i1.barcode BETWEEN 0 AND 10
-- Eg. 1, 6, 7, 9, 10, 11, 12
-- If line below is removed, gap_starts_at = 11, gap_ends_at = NULL
HAVING gap_ends_at IS NOT NULL
