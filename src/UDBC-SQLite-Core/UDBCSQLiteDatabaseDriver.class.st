"
Database driver for SQLite3
"
Class {
	#name : #UDBCSQLiteDatabaseDriver,
	#superclass : #UDBCDatabaseDriver,
	#category : #'UDBC-SQLite-Core-Driver'
}

{ #category : #accessing }
UDBCSQLiteDatabaseDriver class >> driverId [

	^ 'sqlite'
]

{ #category : #'instance creation' }
UDBCSQLiteDatabaseDriver class >> fromConnectionString: aConnectionString [

	| database |
	database := aConnectionString host, 
		(aConnectionString port ifNotEmpty: [:port | ':', port]), 
			(aConnectionString database ifNotEmpty: [:port | '/', port]).
	^ self new
		connectionString: aConnectionString;
		database: (database = 'memory' ifTrue: [ ':memory:' ] ifFalse: [ database ]);
		yourself
]

{ #category : #initialization }
UDBCSQLiteDatabaseDriver class >> initialize [

	self subscribeDriver
]

{ #category : #encoding }
UDBCSQLiteDatabaseDriver class >> supportsEncoding: anEncoding [
	
	^ (ZnCharacterEncoder newForEncoding: anEncoding) = ZnUTF8Encoder new
]
