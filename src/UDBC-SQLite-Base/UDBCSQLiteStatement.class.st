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

{ #category : #'public - accessing' }
UDBCSQLiteStatement >> at: aColumn putString: aString [
	^ UDBCSQLiteLibrary current with: handle at: aColumn putString: aString
]

{ #category : #public }
UDBCSQLiteStatement >> basicExecute: aBlock [
	| ret |
	
	ret := self step. 
	(ret = 101) " == SQLITE_DONE, meaning step should not be sent again."
		ifTrue: [ aBlock value: self ]
		ifFalse: [
			[ ret = 100 ] whileTrue: [ " == SQLITE_ROW, meaning another row is available."
				aBlock value: self.
				ret := self step ]]
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

{ #category : #'public - accessing' }
UDBCSQLiteStatement >> integerAt: aColumn [ 
	^UDBCSQLiteLibrary current integerFrom: handle at: aColumn
]

{ #category : #private }
UDBCSQLiteStatement >> step [
	^ UDBCSQLiteLibrary current step: handle
]
