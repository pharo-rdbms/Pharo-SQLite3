"
I represent an SQLite non-ok condition.
"
Class {
	#name : #UDBCSQLiteError,
	#superclass : #Error,
	#instVars : [
		'resultCode'
	],
	#category : #'UDBC-SQLite-Base-Errors'
}

{ #category : #accessing }
UDBCSQLiteError >> resultCode [
	^ resultCode
]

{ #category : #accessing }
UDBCSQLiteError >> resultCode: anObject [
	resultCode := anObject
]
