This section explains how to get started with [SQLite3](../README) in [Pharo](http://www.pharo.org).

## Creating a connection
The first step is to create a connection to a SQLite3 database.
There are two possibilities:
- Create a database stored in memory (i.e. the RAM)

```st
connection := SQLite3Connection memory.
```

- Create a database stored on the file system.

```st
connection := SQLite3Connection on: (Smalltalk imageDirectory / 'mydatabase.db') fullName.
```

## Opening a connection
Either memory and file databases need to be opened before further use.
This can be achieve using `#open` message.

```st
connection open.
```

## Executing a simple query
Once the connection is open, it is possible to execute an arbitrary number of queries on it.
In this tutorial, we create a table named `'person'`.
This table has 3 columns:
- `id` of type `INTEGER` being the primary key of the table. Additionally, this column is autoincremented which means that if a row is inserted without specifying the value for `id` column, it will automatically gets the value resulting of the query `SELECT MAX(id) + 1 FROM person;`
- `name` of type `TEXT` storing the name of a person as a string of arbitrary length
- `age` of type `INTEGER` storing the age of a person as an integer

```st
connection execute: 'CREATE TABLE person(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL,
	age INTEGER NOT NULL
);'.
```

## Executing a parametrized query
It is possible to inject parameters into a query template.
Such query template are called "prepared statements".
These parameters can be described in two ways in the query string: per index in an array of argument or per parameter name in a dictionary of arguments.

### Parameterize per index
The interrogation mark allows to inject parameters from an array of arguments.
If interrogation marks are written as is, the parameters are taken in the order they are provided by the array of arguments:

```st
connection execute: 'INSERT INTO person(name,age) VALUES (?, ?);' value: 'Julien' value: 24.
```

If the interrogation mark is followed by an integer, the parameter is taken at the corresponding index of the array of arguments:

```st
connection execute: 'INSERT INTO person(name,age) VALUES (?2, ?1);' value: 25 value: 'Cyril'.
```

This last query is equivalent to the following which is useful when the arguments array is big.

```st
connection execute: 'INSERT INTO person(name,age) VALUES (?2, ?1);' with: #(25 'Cyril').
```

### Parameterize per name
Parameters can be referenced through a name, either prefixed by `:` or `@` character.
The two following examples are equivalent:

```st
connection execute: 'INSERT INTO person(name,age) VALUES (:name, :age);' with: { 
	':name' -> 'Guillaume'.
	':age' -> 30 } asDictionary.
```

```st
connection execute: 'INSERT INTO person(name,age) VALUES (@name, @age);' with: { 
	'@name' -> 'Guillaume'.
	'@age' -> 30 } asDictionary.
```

## Gather results from a query
All calls to execute return a `SQLite3Cursor` object.
This object allows one to retrieve the results of the query.

```st
cursor := connection execute: 'SELECT * FROM person;'.
```

One can ask a cursor if it has more results to provide.

```st
cursor hasNext. "true"
```

If the answer is true, the next row of results can be retrieved.

```st
cursor next. "a SQLite3Row(id : 1, name : 'Cyril', age : 25)"
```

It is also possible to ask for all remaining rows of the cursor as an array.

```st
cursor rows. "an Array(a SQLite3Row(id : 2, name : 'Julien', age : 24) a SQLite3Row(id : 3, name : 'Guillaume', age : 30) )"
```

Thus, the cursor has no more row to provide.

```st
cursor hasNext. "false"
```

## Closing a connection
Either memory and file databases need to be closed when no longer needed.
This can be achieve using `#close` message.

```st
connection close.
```
