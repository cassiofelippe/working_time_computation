# Working Time Computation - SQL

Stored procedure / function to calculate the time spent between two dates, considering a defined working time

The function is currently only available for postgres.  
The working time is defined inside the functions code.

Inside the tests folder are other functions used to test de code.


### Holidays

Currently the function is not validating holidays, there is a function created to this, but it would have to be created a database / table populated with the holidays and also implement the query for the `is_holiday` function.