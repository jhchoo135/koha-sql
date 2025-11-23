/*
   File: top_student_borrowers_unique.sql

   Purpose:
  Lists student borrowers ranked by the number of unique titles they have borrowed within a certain date range.
  Useful for identifying the most active borrowers in the system.

   Author: JH Choo
   Created: 2025-11-23

   Notes:
     1. '2024-04-22' and '2024-06-01' are examples used in this query.
         Adjust the dates in the query as needed.
     2. AND b.categorycode = 'ST' is added to the query because we are only interested in student borrowers.
        Remove it or adjust 'ST' to your library patron category code as needed.
     3. LIMIT 50 is to get the top 50 students.
        Adjust the limit (50) in the query as needed.
     4. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT
    cardnumber AS StudentID,
    CONCAT(firstname, ' ', surname) AS StudentName,
    COUNT(DISTINCT itemnumber) AS Total
FROM borrowers b
JOIN statistics s ON b.borrowernumber = s.borrowernumber
WHERE DATE(datetime) BETWEEN '2024-04-22' AND '2024-06-01'
  AND b.categorycode = 'ST'
GROUP BY b.borrowernumber
ORDER BY Total DESC
LIMIT 50
