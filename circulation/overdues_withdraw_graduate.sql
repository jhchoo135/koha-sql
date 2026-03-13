/*
   File: overdues_withdraw_graduate.sql

   Purpose:
   Lists patrons who have the following comment restrictions added: 
                       1) 'Pending Overdue Book'
                       2) 'Pending Overdue Charges'
                       3) 'Pending'
                       4) 'Withdraw'
                       5) Other cases (includes graduating)

   Retrieves the following fields:
                       1) Card Number (ID Tag Number)
                       2) Surname
                       3) First Name
                       4) Restriction Comments

   Author: JH Choo
   Created: 2025-11-23

   Notes:
     1. 'categorycode' is not used, as only students are charged overdues
         at the time of writing.

     2. This query is only useful if restriction comments field are filled.

     3. KOHA installations can differ slightly. Some libraries may have 
     custom fields or table modifications. Always check your local 
     database schema before running queries.
*/

SELECT 
    b.cardnumber,
    b.surname,
    b.firstname,

    -- GROUP_CONCAT(...) consolidates all comment restrictions of a patron into one field
    -- Comment restrictions with 'Pending Overdue Book' will be displayed first,
    -- followed by 'Pending Overdue Charges', then 'Pending', then 'Withdraw'
    -- Any other comments that do not fit the sentences mentioned will be displayed later in the list
    -- Each different comment will be separated with a '; '
    GROUP_CONCAT(

        -- No need to CONCAT(...) again
        CONCAT(
            d.comment
        )
        ORDER BY 
            CASE 
                WHEN d.comment LIKE '%Pending Overdue Book%' THEN 0
                WHEN d.comment LIKE '%Pending Overdue Charges%' THEN 1
                WHEN d.comment LIKE '%Pending%' THEN 2
                WHEN d.comment LIKE '%Withdraw%' THEN 3
                ELSE 4
            END
        SEPARATOR '; '
    ) AS all_restrictions

-- Data is obtained from both borrower_debarments and borrowers tables
-- The reference point for both is borrowernumber
-- borrower_debarments table does not have cardnumber  
FROM borrower_debarments d
JOIN borrowers b ON b.borrowernumber = d.borrowernumber

-- Since borrowernumber and cardnumber are unique,
-- no need to group by all four, just use borrowernumber or cardnumber
GROUP BY 
    b.borrowernumber, b.cardnumber, b.surname, b.firstname

-- There are alternative ways of doing this
-- Patron results are arranged by the comment restrictions
-- Comment restrictions with 'Pending Overdue Book' will be displayed first,
-- followed by 'Pending Overdue Charges', then 'Pending', then 'Withdraw'
-- Any other comments that do not fit the sentences mentioned will be displayed later in the list
ORDER BY 
    CASE 
        WHEN SUM(d.comment LIKE '%Pending Overdue Book%') > 0 THEN 0
        WHEN SUM(d.comment LIKE '%Pending Overdue Charges%') > 0 THEN 1
        WHEN SUM(d.comment LIKE '%Pending%') > 0 THEN 2
        WHEN SUM(d.comment LIKE '%Withdraw%') > 0 THEN 3
        ELSE 4
    END
