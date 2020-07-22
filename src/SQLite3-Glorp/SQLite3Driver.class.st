Class {
	#name : #SQLite3Driver,
	#superclass : #DatabaseDriver,
	#instVars : [
		'isInTransaction',
		'transactionMutex'
	],
	#category : #'SQLite3-Glorp'
}

{ #category : #executing }
SQLite3Driver >> basicExecuteSQLString: aString [

	^ self basicExecuteSQLString: aString binding: #()
]

{ #category : #executing }
SQLite3Driver >> basicExecuteSQLString: aString binding: aBinding [

	^ connection execute: aString with: aBinding
]

{ #category : #transactions }
SQLite3Driver >> beginTransaction [

	transactionMutex
		critical: [ 
			isInTransaction
				ifFalse: [ 
					connection beginTransaction.
					isInTransaction := true
					]
			]
]

{ #category : #transactions }
SQLite3Driver >> commitTransaction [

	transactionMutex
		critical: [ 
			isInTransaction
				ifTrue: [ 
					connection commitTransaction.
					isInTransaction := false
					]
			]
]

{ #category : #accessing }
SQLite3Driver >> connect: aLogin [

	connection := self connectionClass
		openOn: ( aLogin host asFileReference / aLogin databaseName ) fullName
]

{ #category : #accessing }
SQLite3Driver >> connectionClass [

	^ SQLite3Connection
]

{ #category : #initialization }
SQLite3Driver >> initialize [

	super initialize.
	isInTransaction := false.
	transactionMutex := Semaphore forMutualExclusion
]

{ #category : #testing }
SQLite3Driver >> isConnected [

	^ connection isNotNil and: [ connection isOpen ]
]

{ #category : #login }
SQLite3Driver >> logout [

	connection close
]

{ #category : #transactions }
SQLite3Driver >> rollbackTransaction [

	transactionMutex
		critical: [ 
			isInTransaction
				ifTrue: [ 
					connection rollbackTransaction.
					isInTransaction := false
					]
			]
]
