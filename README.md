# koha-sql
- A collection of SQL queries used for library management and reporting in KOHA during my time as a School Librarian (tenure ended in December 2025).
- The library contains over 12,000 items, with records maintained across the KOHA system and multiple manual records for verification and tracking.
- Some queries were created to provide insights not available in standard KOHA reports, such as statistics by series or counts of unique books borrowed.
- Queries are documented with comments to explain their purpose and guide future use. They helped track circulation, audit records,
  and support data-driven decisions, with notes on adjustments and alternative approaches for accuracy and efficiency.
- Status: Work in progress — queries will be updated over time.

## Contents

### **audit/**
**count_items_by_category.sql :**
Lists the number of items in each category / prefix / itemcallnumber.
- *Used to check if the number of items in the system for each category tallies with the manual records maintained in other sources.*
- *Helps to double-check if items are recorded properly during cataloguing and for stock-take purposes.*
  
**list_items_by_callnumber.sql :**
Retrieves a list of items based on a given prefix / category.
- *Used because a manual record only stores barcode and itemcallnumber based on specific prefixes / categories.*
- *Helps to double-check if items are recorded properly during cataloguing and for stock-take purposes.*
  
**list_items_by_callnumber_original.sql :**
Primitive version of the above query that uses fixed character positions rather than delimiters.
  
**reconcile_manual_vs_KOHA.sql :**
Retrieves data as per one of the manual records.
- *Used to verify that the records in the system match the manual records.*
- *Helps to double-check if items are recorded properly during cataloguing.*
- *A full verification has not been performed; only `itemcallnumber` and `barcode` fields were confirmed to match across all files.*

### **cataloguing/** 
**find_unused_barcodes.sql :**
Retrieves gaps between sequential barcodes in the system within a specified range.
- *The library reuses old barcodes from books that have been weeded out or declared missing after a specified number of years*
  
**quick_cataloguing.sql :**
Retrieves the highest barcode in the system’s numbering sequence, as well as the last barcode and full itemcallnumber of the specified prefixes/categories.
- *Designed to reduce manual data entry errors by treating the system as the primary record and updating manual files using data pulled from the system rather than manual copying.*
- Typical workflow (order varies depending on who updates the records):

  1. Insert data into Excel Sheet 1 (all data required in system + some extra info) 
  2. Copy data into the system  
  3. Copy data to Excel Sheet 2 (barcode and item call number for each category)  
  4. Copy data to Excel Sheet 3 (ISBN, book title, how book is sourced)

- *Not currently in use, as the manual files were retained.*

### **circulation/**
**overdues_withdraw_graduate.sql :**
Retrieves a list of patrons (students) who have pending overdue books, unpaid fines, other pending library issues, withdrawals, or other issues (including graduation).
- *Helps quickly identify students with pending library issues.*
- *For cases like withdrawals or graduations, the library must notify the relevant departments of any outstanding issues.*
- *Only works if `Restrictions` and `Restriction Comments` are added to the patron's profile.*

**top_circulated_items_by_series.sql :** 
Lists the top series or item titles borrowed most frequently by students.
- *Improves readability of borrowing reports by grouping items by series rather than displaying them individually.*
- *Provides insight into student borrowing preferences and helps inform decisions on which series to continue acquiring.*
- *Reports in KOHA do not appear to provide results based on series*
  
**top_student_borrowers_unique.sql :** 
Retrieves a list of students with the most number of unique books borrowed.
- *Used for a program encouraging reading.*
- *Some students were borrowing the same book repeatedly, which raised questions from teachers and parents.*
- *By counting only unique books borrowed, the program encourages students to read a wider variety of titles.*
- *Reports in KOHA do not appear to provide results based on the unique number of books borrowed*
- *Slight edit needed to ensure results are accurate (see Notes #1 in file)*

## Author
JH Choo – former school librarian and former software engineer
