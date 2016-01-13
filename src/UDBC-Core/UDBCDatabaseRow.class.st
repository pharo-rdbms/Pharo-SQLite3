"
I am a row object representing a row from a database query. I provide an array like interface with methods such as #at:, #first, #last
"
Class {
	#name : #UDBCDatabaseRow,
	#superclass : #Object,
	#category : #'UDBC-Core-Base'
}

{ #category : #converting }
UDBCDatabaseRow >> asArray [

	^ self values asArray
]

{ #category : #accessing }
UDBCDatabaseRow >> at: anIndex [

	^ self values at: anIndex
]

{ #category : #accessing }
UDBCDatabaseRow >> first [

	^ self values first
]

{ #category : #accessing }
UDBCDatabaseRow >> last [

	^ self values last
]

{ #category : #accessing }
UDBCDatabaseRow >> size [

	^ self values size
]

{ #category : #accessing }
UDBCDatabaseRow >> values [

	self subclassResponsibility
]
