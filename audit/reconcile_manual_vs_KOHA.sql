/*
   File: reconcile_manual_vs_system.sql

   Purpose:
  Compares records in KOHA with manual backup records 
  to ensure data consistency.

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
    (SELECT IF(bi.isbn IS NULL, bi.issn, bi.isbn)) AS ISBN_ISSN,
    b.title AS TITLE,
    b.abstract AS SYNOPSIS,
    IF(
        b.author IS NOT NULL, 
        b.author, 
        IF(
            i.itemnotes_nonpublic IS NOT NULL, 
            i.itemnotes_nonpublic, 
            i.itemnotes
        )
    ) AS AUTHOR,
    bi.publishercode AS PUBLISHER,
    b.copyrightdate AS PUBLICATION_DATE,
    i.itemcallnumber AS DDC,
    i.barcode AS BARCODE
FROM items i
LEFT JOIN biblio b USING (biblionumber)
LEFT JOIN biblioitems bi USING (biblionumber)
ORDER BY i.barcode
