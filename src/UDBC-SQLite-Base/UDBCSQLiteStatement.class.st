"
I represent an SQLite prepared statement.
"
Class {
	#name : #UDBCSQLiteStatement,
	#superclass : #Object,
	#instVars : [
		'connection',
		'handle'
	],
	#category : #'UDBC-SQLite-Base-Database'
}

{ #category : #'instance finalization' }
UDBCSQLiteStatement class >> finalizeResourceData: aHandle [
	UDBCSQLiteLibrary current apiFinalize: aHandle.
]

{ #category : #'private - accessing' }
UDBCSQLiteStatement >> connection: anObject [
	connection := anObject
]

{ #category : #'private - accessing' }
UDBCSQLiteStatement >> handle [
	^ handle
]

{ #category : #initialization }
UDBCSQLiteStatement >> initialize [

	super initialize.
	handle := UDBCSQLiteStatementExternalObject new.
	FFIExternalResourceManager addResource: handle data: handle
]
