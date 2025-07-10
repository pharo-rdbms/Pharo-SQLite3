"
I represent an SQLite non-ok condition.
"
Class {
	#name : #SQLite3AbstractError,
	#superclass : #Error,
	#instVars : [
		'resultCode'
	],
	#category : #'SQLite3-Core-Errors'
}

{ #category : #testing }
SQLite3AbstractError class >> isAbstract [

	^self name = #SQLite3AbstractError
]

{ #category : #accessing }
SQLite3AbstractError >> resultCode [
	^ resultCode
]

{ #category : #accessing }
SQLite3AbstractError >> resultCode: anObject [
	resultCode := anObject
]
