# calendar-table
Generate a SQL calendar table. Useful for doing queries against dates.

If you live in Victoria Austalia, then your good to go with public holiday dates for 2017.

## PostgreSQL
This assumes the user can automatically connect to a database with the same name as the user.

In my case a user named `james` and a database named `james`.
```
$ psql -f calendar_postgre.sql
```

## MySQL
This relies on a user `james` and a database `james` that have already been created.
```
$ mysql -ujames james < calendar_mysql.sql
```
