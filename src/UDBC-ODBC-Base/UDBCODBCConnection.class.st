"
I represent a connection to an ODBC database.

"
Class {
	#name : #UDBCODBCConnection,
	#superclass : #Object,
	#category : #'UDBC-ODBC-Base-Connections'
}

{ #category : #'private - accessing' }
UDBCODBCConnection class >> workstationId [
	^ Author fullNamePerSe , '@' , NetNameResolver localHostName
]
