"
Driver for OpenDBX with various backends
"
Class {
	#name : #UDBCOpenDBXDatabaseDriver,
	#superclass : #UDBCDatabaseDriver,
	#category : #'UDBC-OpenDBX-Core-Driver'
}

{ #category : #accessing }
UDBCOpenDBXDatabaseDriver class >> driverId [

	^ 'opendbx'
]

{ #category : #initialization }
UDBCOpenDBXDatabaseDriver class >> initialize [

	self subscribeDriver
]

{ #category : #encoding }
UDBCOpenDBXDatabaseDriver class >> supportsEncoding: aString [
	"This should actually depend on the backend"

	^ true
]
