WhiskedAway Database - SQL File Run Order
==========================================
1. 01_schema.sql            - Creates the database and all 14 tables (PK/FK/CHECK/UNIQUE constraints)
2. 02_seed_data.sql          - Inserts realistic sample data (10-15 rows per table)
3. 03_crud_operations.sql    - Create/Read/Update/Delete examples, each tied to a business task
4. 04_business_cases.sql     - Advanced aggregate/subquery/join queries + 2 reporting views

Tested against MySQL 8.0 / MariaDB 10.11 in MySQL Workbench-compatible syntax.
Run each file in order against the `whiskedaway` schema created by file 1.
