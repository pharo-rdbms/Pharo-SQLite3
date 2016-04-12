"
Database driver for PostgreSQL
"
Class {
	#name : #UDBCPostgreSQLDatabaseDriver,
	#superclass : #UDBCDatabaseDriver,
	#category : #'UDBC-PostgreSQL-Core-Driver'
}

{ #category : #accessing }
UDBCPostgreSQLDatabaseDriver class >> driverId [

	^ 'postgres'
]

{ #category : #initialization }
UDBCPostgreSQLDatabaseDriver class >> initialize [

	self subscribeDriver
]

{ #category : #'testing - encoding' }
UDBCPostgreSQLDatabaseDriver class >> supportsEncoding: aString [ 	
	"Check: http://www.postgresql.org/docs/9.2/static/multibyte.html"
	
	^ true
]
