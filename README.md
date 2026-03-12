# koha-sql
- All the SQL I used in KOHA when I was a school librarian. 
- Still a work in progress, will be updated from time to time until completed.

## Contents

### **audit/**
- **count_items_by_category.sql**
Lists the number of items in each category / prefix / itemcallnumber.
- *Used to check if the number of items in the system for each category tallies with the manual records maintained in two other sources.*
- *Helps to double-check if items are recorded properly during cataloguing and for stock-take purposes.*
  
- **list_items_by_callnumber.sql**
Retrieves a list of items based on a given prefix / category.
- *Used because a manual record only stores barcode and itemcallnumber based on specific prefixes / categories.*
- *Helps to double-check if items are recorded properly during cataloguing and for stock-take purposes.*
  
- **list_items_by_callnumber_original.sql**
Primitive version of the above query that uses fixed character positions rather than delimiters.
  
- **reconcile_manual_vs_KOHA.sql**
Retrieves data as per one of the manual records.
- *Used to check if all the records in the system and the manual record tallies*
- *Helps to double-check if items are recorded properly during cataloguing*
- *A full verification has not been performed; only `itemcallnumber` and `barcode` fields were confirmed to match across all files.*

### **cataloguing/** 
- **find_unused_barcodes.sql**
Retrieves gaps between sequential barcodes in the system within a specified range.
- *The library reuses old barcodes from books that have been weeded out or declared missing after a specified number of years*
  
- **quick_cataloguing.sql**
Retrieves the highest barcode in the system’s numbering sequence, as well as the last barcode and full itemcallnumber of the specified prefixes/categories.
- *Designed to reduce manual data entry errors by relying solely on system records rather than updating the two manual files.*
- *Not currently in use, as the manual files were retained.*

### **circulation/**
- **overdues_withdraw_graduate.sql**
Retrieves a list of patrons (students) who have pending overdue books, unpaid fines, other pending library issues, withdrawals, or other issues (including graduation).
- *Helps quickly identify students with pending library issues.*
- *For cases like withdrawals or graduations, the library must notify the relevant departments of any outstanding issues.*
- *Only works if `Restrictions` and `Restriction Comments` are added to the patron's profile.*
  
- **top_student_borrowers_unique.sql** 
Retrieves a list of students with the most number of unique books borrowed.
- *Used for a program encouraging reading.*
- *Some students were borrowing the same book repeatedly, which raised questions from teachers and parents.*
- *By counting only unique books borrowed, the program encourages students to read a wider variety of titles.*

## Author
JH Choo – ex-school librarian and former software engineer
