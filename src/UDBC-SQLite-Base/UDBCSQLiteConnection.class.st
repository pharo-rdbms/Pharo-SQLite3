"
I represent a connection to an SQLite database.

"
Class {
	#name : #UDBCSQLiteConnection,
	#superclass : #UDBCSQLiteBaseConnection,
	#category : #'UDBC-SQLite-Base-Connections'
}

{ #category : #'public API - operating' }
UDBCSQLiteConnection >> execute: anSQLText [	
	^ self execute: anSQLText with: #()
]

{ #category : #'public API - operating' }
UDBCSQLiteConnection >> execute: anSQLText with: anObject [

	anObject isString
		ifTrue: [ UDBCSQLiteError signal: 'Unable to execute SQL on instance of String.' ].
			
	^ UDBCSQLite3ResultSet new execute: anSQLText with: anObject on: self	

]
