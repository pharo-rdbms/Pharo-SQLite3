"
Unit test for SQLite database driver
"
Class {
	#name : #UDBCSQLiteDatabaseDriverTest,
	#superclass : #UDBCDatabaseDriverTest,
	#category : #'UDBC-Tests-SQLite-Core-Driver'
}

{ #category : #accessing }
UDBCSQLiteDatabaseDriverTest >> defaultTestClass [
	"Return the default test class"

	^UDBCSQLiteDatabaseDriver 
]

{ #category : #'tests - connections' }
UDBCSQLiteDatabaseDriverTest >> testUnixLikeConnectionString [

	self
		assert:
			(self defaultTestClass 
				fromConnectionString: (UDBCConnectionString fromString: 'sqlite:///Users/guillermopolito/work/temp/dbxtalk/sodbxtest.db'))
				database
		equals: '/Users/guillermopolito/work/temp/dbxtalk/sodbxtest.db'
]

{ #category : #'tests - connections' }
UDBCSQLiteDatabaseDriverTest >> testWindowsLikeConnectionString [

	self
		assert:
			(self defaultTestClass
				fromConnectionString: (UDBCConnectionString fromString: 'sqlite://C:\Users\guillermopolito\work\temp\dbxtalk\sodbxtest.db'))
				database
		equals: 'C:\Users\guillermopolito\work\temp\dbxtalk\sodbxtest.db'
]
