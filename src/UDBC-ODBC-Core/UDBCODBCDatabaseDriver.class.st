"
Database driver for ODBC
"
Class {
	#name : #UDBCODBCDatabaseDriver,
	#superclass : #Object,
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
