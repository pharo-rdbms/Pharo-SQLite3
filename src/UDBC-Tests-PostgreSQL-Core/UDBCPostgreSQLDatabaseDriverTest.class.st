"
Unit test for SQLite database driver
"
Class {
	#name : #UDBCPostgreSQLDatabaseDriverTest,
	#superclass : #UDBCDatabaseDriverTest,
	#category : #'UDBC-Tests-PostgreSQL-Core-Driver'
}

{ #category : #accessing }
UDBCPostgreSQLDatabaseDriverTest >> defaultTestClass [
	"Return the default test class"

	^UDBCPostgreSQLDatabaseDriver 
]
