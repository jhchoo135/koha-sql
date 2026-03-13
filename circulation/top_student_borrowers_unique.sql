/*
   File: top_student_borrowers_unique.sql

   Purpose:
  Lists student borrowers ranked by the number of unique titles they have borrowed within a certain date range.
  Useful for identifying the most active borrowers in the system.

   Author: JH Choo
   Created: 2025-11-23

   Notes:
     1. Table aliases (eg. b.cardnumber, s.itemnumber, etc.) added for clarity.
        No other changes were made; everything else remained as per the original.

     2. '2024-04-22' and '2024-06-01' are examples used in this query.
         Adjust the dates in the query as needed.

     3. AND b.categorycode = 'ST' is added to the query because we are only interested in student borrowers.
        Remove it or adjust 'ST' to your library patron category code as needed.

     4. LIMIT 50 is to get the top 50 students.
        Adjust the limit (50) in the query as needed.

     5. Books are counted once they are checked out within the specified time period, 
        even if they have not yet been returned.

     6. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT
    b.cardnumber AS student_id,

    -- CONCAT(...) is used to combine first name and surname
    -- firstname and surname are both stored separately in system
    CONCAT(b.firstname, ' ', b.surname) AS student_name,

    -- Counts the number of unique books borrowed
    COUNT(DISTINCT s.itemnumber) AS total

-- Data is obtained from both borrowers and statistics tables
-- The reference point for both is borrowernumber
-- statistics table does not have cardnumber
FROM borrowers b
JOIN statistics s ON b.borrowernumber = s.borrowernumber

-- '2024-04-22' and '2024-06-01' are sample dates
-- Replace with the required date range for filtering
WHERE DATE(s.datetime) BETWEEN '2024-04-22' AND '2024-06-01'

  -- Only retrieves data for Students ('ST')
  AND b.categorycode = 'ST'

-- Combines the data based on b.borrowernumber   
GROUP BY b.borrowernumber

-- Arranges the results by most to least books borrowed   
ORDER BY total DESC

-- Gets only the top 50 from the arranged results
-- LIMIT can be adjusted as required
LIMIT 50
