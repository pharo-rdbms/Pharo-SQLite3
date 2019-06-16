"
I represent an SQLite non-ok condition.
"
Class {
	#name : #SQLite3Error,
	#superclass : #Error,
	#instVars : [
		'resultCode'
	],
	#category : #'SQLite3-Core-Errors'
}

{ #category : #accessing }
SQLite3Error >> resultCode [
	^ resultCode
]

{ #category : #accessing }
SQLite3Error >> resultCode: anObject [
	resultCode := anObject
]
