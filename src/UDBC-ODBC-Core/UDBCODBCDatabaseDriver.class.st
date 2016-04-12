"
Database driver for ODBC
"
Class {
	#name : #UDBCODBCDatabaseDriver,
	#superclass : #UDBCDatabaseDriver,
	#category : #'UDBC-ODBC-Core-Driver'
}

{ #category : #accessing }
UDBCODBCDatabaseDriver class >> driverId [

	^ 'odbc'
]

{ #category : #initialization }
UDBCODBCDatabaseDriver class >> initialize [

	self subscribeDriver
]

{ #category : #'testing - encoding' }
UDBCODBCDatabaseDriver class >> supportsEncoding: aString [

	^true
]
