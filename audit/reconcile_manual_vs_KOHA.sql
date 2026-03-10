/*
   File: reconcile_manual_vs_system.sql

   Purpose:
  Retrieve records in KOHA to be compared with 
  manual backup records (Excel sheets) to ensure data consistency.

  The query will retrieve: 
   - ISBN / ISSN
   - Title
   - Synopsis
   - Author
   - Publisher
   - Publication Date
   - DDC (itemcallnumber)
   - Barcode

   Author: JH Choo
   Created: 2025-11-23

   Notes:
     1. Terminology:
        - DDC: usually refers to item call number / category / prefix

     2. KOHA installations can differ slightly. Some libraries may have 
        custom fields or table modifications. Always check your local 
        database schema before running queries.
*/

SELECT 
    IF(bi.isbn IS NULL, bi.issn, bi.isbn) AS isbn_issn,
    b.title AS title,
    b.abstract AS synopsis, 
    -- The query below is because 'Author' is sometimes recorded in either
    -- 'Non-Public Notes' or 'Public Notes' field
    IF(
        b.author IS NOT NULL, 
        b.author, 
        IF(
            i.itemnotes_nonpublic IS NOT NULL, 
            i.itemnotes_nonpublic, 
            i.itemnotes
        )
    ) AS author,
    bi.publishercode AS publisher,
    b.copyrightdate AS publication_date,
    i.itemcallnumber AS DDC,
    i.barcode AS barcode
FROM items i
LEFT JOIN biblio b USING (biblionumber)
LEFT JOIN biblioitems bi USING (biblionumber)
ORDER BY i.barcode
