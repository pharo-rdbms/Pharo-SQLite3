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
UDBCSQLiteStatement >> at: aColumn putDateTime: aDateTime [

	| s |
	s := UDBCSQLiteDateTimeString streamContents: [ :stream | aDateTime printOn: stream ].
	^ self library with: handle at: aColumn putString: s
]

{ #category : #'public - accessing' }
UDBCSQLiteStatement >> at: aColumn putInteger: anInteger [

	^ self library with: handle at: aColumn putInteger: anInteger
]

{ #category : #'public - accessing' }
UDBCSQLiteStatement >> at: aColumn putObject: anObject [
	^ self library with: handle at: aColumn putBlob: (FLSerializer serializeToByteArray: anObject)
]

{ #category : #'public - accessing' }
UDBCSQLiteStatement >> at: aColumn putString: aString [
	^ self library with: handle at: aColumn putString: aString
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

{ #category : #public }
UDBCSQLiteStatement >> clearBindings [
	connection clearBindings: self
]

{ #category : #'private - accessing' }
UDBCSQLiteStatement >> connection: anObject [
	connection := anObject
]

{ #category : #'public - accessing' }
UDBCSQLiteStatement >> dataValuesAvailable [
	^ self library dataValuesAvailable: handle
]

{ #category : #'public - accessing' }
UDBCSQLiteStatement >> dateTimeAt: aColumn [	
	^ DateAndTime fromString: (self library stringFrom: handle at: aColumn)
]

{ #category : #initialization }
UDBCSQLiteStatement >> finalize [
	UDBCSQLiteLibrary current apiFinalize: handle.
	handle := nil
]

{ #category : #'public - accessing' }
UDBCSQLiteStatement >> floatAt: aColumn [

	^self library floatFrom: handle at: aColumn
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
	^self library integerFrom: handle at: aColumn
]

{ #category : #private }
UDBCSQLiteStatement >> library [
	^UDBCSQLiteLibrary current
]

{ #category : #'public - accessing' }
UDBCSQLiteStatement >> nameOfColumn: aColumn [
	^ self library nameFor: handle at: aColumn
]

{ #category : #'public - accessing' }
UDBCSQLiteStatement >> objectAt: aColumn [
	^ FLMaterializer materializeFromByteArray: (self library blobFrom: handle at: aColumn)  
]

{ #category : #public }
UDBCSQLiteStatement >> reset [
	connection reset: self
]

{ #category : #private }
UDBCSQLiteStatement >> step [
	^ UDBCSQLiteLibrary current step: handle
]

{ #category : #operating }
UDBCSQLiteStatement >> stringAt: aColumn [	 
	^ UDBCSQLiteLibrary current stringFrom: handle at: aColumn
]
