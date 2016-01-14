"
Unit test for SQLite connection strings
"
Class {
	#name : #UDBCSQLiteConnectionStringTest,
	#superclass : #TestCase,
	#category : #'UDBC-Tests-SQLite-Core-Connections'
}

{ #category : #tests }
UDBCSQLiteConnectionStringTest >> testUnixLikeConnectionString [

	self assert: 
(UDBCSQLiteDatabaseDriver fromConnectionString: (UDBCConnectionString  fromString: 'sqlite:///Users/guillermopolito/work/temp/dbxtalk/sodbxtest.db'))
	database equals: '/Users/guillermopolito/work/temp/dbxtalk/sodbxtest.db'
]

{ #category : #tests }
UDBCSQLiteConnectionStringTest >> testWindowsLikeConnectionString [

	self assert: (UDBCSQLiteDatabaseDriver fromConnectionString: (UDBCConnectionString fromString: 'sqlite://C:\Users\guillermopolito\work\temp\dbxtalk\sodbxtest.db'))
	database equals: 'C:\Users\guillermopolito\work\temp\dbxtalk\sodbxtest.db'
]
