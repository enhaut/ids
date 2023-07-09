# IDS project

The project was splitted into 4 subtasks.

## Authors
* [Samuel Dobroň](https://github.com/enhaut)
* [Juraj Remeň](https://github.com/belticek17)


## Task 1 - ERD + use case diagram
> Assignment is to analyze an arbitrary information system and create an Entity-Relationship (ER) diagram
> and a Use Case diagram to represent its structure and functionality.


We decided to reuse my [IUS](https://github.com/enhaut/fit/tree/master/1semester/IUS/project) project.
Most of ER/use-case diagram remains the same, however there are some enhancements.

See [xdobro23_xremen02.pdf](task1/xdobro23_xremen02.pdf).


## Task 2 - SQL Script for Creating Database Schema Objects
> This assignment requires the creation of an SQL script that builds the fundamental objects of a database schema. The script should include tables with integrity constraints, such as primary and foreign keys, and populate them with sample data. The generated database schema must align with the data model from the previous project phase and meet the following requirements:
> 1. The database schema tables must contain at least one column with a special value constraint, such as a personal identification number, insurance policy number, person/enterprise identification number, medical facility identification number ISBN or ISSN, bank account number, etc. The database should only allow valid values in this column, which can be implemented using `CHECK` integrity constraints.
> 2. The database schema tables must have an appropriate implementation of the generalization/specialization relationship for a purely relational database. This means that the specified relationship and related entities of the data model must be correctly transformed into a relational database schema. The chosen method for converting the generalization/specialization into a relational database schema should be described and justified in the documentation.
> 3. The script should also include automatic generation of primary key values for a table from a sequence. For example, if the value of the primary key is not defined `NULL` when inserting records into the table.


Our solution is located in [task2.sql](task2/xdobro23_xremen02.sql)


## Task 3 - `SELECT` SQL scripts
> Create an SQL script that first creates the basic database schema objects and populates the tables with sample data (similar to the script in point 2), and then performs several SELECT queries. The script must include at least two queries using joins of two tables, one query using joins of three tables, two queries with GROUP BY clause and an aggregate function, one query containing the EXISTS predicate, and one query with the IN predicate and a nested SELECT statement (not IN with a set of constant data). Each query should have a clear description (in the SQL code comments) of the data it is searching for and its function in the application.

Simple collection of our `SELECT` queries are in [task3.sql](task3/xdobro23_xremen02.sql)


## Task 4 - SQL script for creating advanced database schema objects
> The script should include the following elements:
> * Creation of basic database schema objects and populating tables with sample data.
> * Definition or creation of advanced constraints or database objects based on specific requirements.
> * Demonstrating data manipulation commands and queries that utilize the mentioned constraints and objects (e.g., using `EXPLAIN PLAN` to demonstrate index usage or database triggers based on data manipulation).
> * Specific requirements include creating at least two non-trivial database triggers, at least two non-trivial stored procedures with cursors, exception handling, and variables referencing table columns' data types.
> * Explicit creation of at least one index to optimize query processing, including the relevant query affected by the index, and documenting the usage of the index in the query.
> * Using `EXPLAIN PLAN` to display the execution plan of a query involving multiple tables, aggregation functions, and the `GROUP BY` clause. The documentation should explain the execution plan, including the means used for optimization (e.g., index usage, join types), and propose additional optimizations and their impact on the execution plan.
> * Defining access privileges for the second team member to access database objects.
> * Creating at least one materialized view belonging to the second team member and utilizing tables defined by the first team member. Include SQL commands/queries demonstrating how the materialized view functions.
> 
> Optional elements or additional complexity beyond the stated requirements may earn extra points, such as developing a client application aligned with the use cases described in the first part of the project or demonstrating transaction processing with SQL queries and commands, including explanations of atomicity and concurrency control mechanisms.


Our SQL scripts are in [task4.sql](task4/xdobro23_xremen02.sql), report is located in [task4.pdf](task4/xdobro23_xremen02.pdf).

