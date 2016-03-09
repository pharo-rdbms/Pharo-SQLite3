"
I represent an SQLite non-ok condition.
"
Class {
	#name : #UDBCSQLite3Error,
	#superclass : #Error,
	#instVars : [
		'resultCode'
	],
	#category : #'UDBC-SQLite-Base-Errors'
}

{ #category : #accessing }
UDBCSQLite3Error >> resultCode [
	^ resultCode
]

{ #category : #accessing }
UDBCSQLite3Error >> resultCode: anObject [
	resultCode := anObject
]
