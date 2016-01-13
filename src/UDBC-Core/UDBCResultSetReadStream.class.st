"
I provide a stream-like  API to access a result set. I ask the result set for its rows in a lazy way. If no more rows are available, the #next method will return nil and the #next: method will return just an array with the available rows.
"
Class {
	#name : #UDBCResultSetReadStream,
	#superclass : #Object,
	#instVars : [
		'resultSet',
		'position'
	],
	#category : #'UDBC-Core-Utilities'
}

{ #category : #'instance creation' }
UDBCResultSetReadStream class >> on: aResultSet [

	^(self new )
		on: aResultSet;
		yourself
]

{ #category : #accessing }
UDBCResultSetReadStream >> currentRow [
	"Gets the current row of the stream"

	self flag: #possibleBug.
	^ [ resultSet rowAt: position ]
		on: SubscriptOutOfBounds
		do: [ nil ]
]

{ #category : #initialize }
UDBCResultSetReadStream >> initialize [
	"Initializes the receiver"
	
	super initialize.
	position := 0.
]

{ #category : #accessing }
UDBCResultSetReadStream >> next [
	"Advances the stream and retrieves the row at the current position. If no more rows are available, it returns nil."

	position := position + 1.
	^ self currentRow
]

{ #category : #iterating }
UDBCResultSetReadStream >> next: anInteger [
	"Advances the stream and tries to retrieve the following N rows of the result set. If not enough rows 
	 are available, the retrieved array will contain only the available elements."

	^ Array
		streamContents:
			[ :str | anInteger timesRepeat: [ self next ifNotNilDo: [ :next | str nextPut: next ] ] ]
]

{ #category : #initialize }
UDBCResultSetReadStream >> on: aResultSet [ 

	resultSet := aResultSet
]
