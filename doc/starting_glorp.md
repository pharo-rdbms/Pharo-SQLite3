# Starting with Glorp

Load into Pharo using 

```
Metacello new
  repository: 'github://pharo-rdbms/Pharo-SQLite3/src';
  baseline: 'SQLite3';
  load: #('glorp')
```

Set SQLite3 as the DefaultDriver 

```
PharoDatabaseAccessor DefaultDriver: SQLite3Driver.
```

Create the database

```
connection := SQLite3Connection on: (Smalltalk imageDirectory / 'mydatabase.db') fullName.
connection open. 
connection close.
```

Login to the database 

```
login := Login new
	database: UDBCSQLite3Platform new;
	host: Smalltalk imageDirectory fullName;
	password:'';
	databaseName: 'mydatabase.db';
	yourself.
	
accessor := DatabaseAccessor forLogin: login.
accessor login.
```

Test that its logged in

```
accessor isLoggedIn
```
