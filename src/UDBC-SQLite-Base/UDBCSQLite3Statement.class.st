"
I represent an SQLite prepared statement.
"
Class {
	#name : #UDBCSQLite3Statement,
	#superclass : #Object,
	#instVars : [
		'connection',
		'handle'
	],
	#category : #'UDBC-SQLite-Base-Database'
}

{ #category : #'instance finalization' }
UDBCSQLite3Statement class >> finalizeResourceData: aHandle [
	UDBCSQLite3Library current apiFinalize: aHandle.
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> at: aColumn putDateTime: aDateTime [

	| s |
	s := UDBCSQLite3DateTimeString streamContents: [ :stream | aDateTime printOn: stream ].
	^ self library with: handle at: aColumn putString: s
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> at: aColumn putInteger: anInteger [

	^ self library with: handle at: aColumn putInteger: anInteger
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> at: aColumn putObject: anObject [
	^ self library with: handle at: aColumn putBlob: (FLSerializer serializeToByteArray: anObject)
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> at: aColumn putString: aString [
	^ self library with: handle at: aColumn putString: aString
]

{ #category : #public }
UDBCSQLite3Statement >> basicExecute: aBlock [
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
UDBCSQLite3Statement >> clearBindings [
	connection clearBindings: self
]

{ #category : #'private - accessing' }
UDBCSQLite3Statement >> connection: anObject [
	connection := anObject
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> dataTypeForObject: anObject [

	anObject ifNil: [ ^#at:putNil: ].

	(anObject isKindOf: Integer)
		ifTrue: [ ^#at:putInteger: ].
		
	(anObject isKindOf: Float)
		ifTrue: [ ^#at:putFloat: ].
		
	(anObject isKindOf: String)
		ifTrue: [ ^#at:putString: ].
		
	(anObject isKindOf: ByteArray)
		ifTrue: [ ^#at:putByteArray: ].
		
	(anObject isKindOf: DateAndTime)
		ifTrue: [ ^#at:putDateTime: ].
		
	^ #at:putObject: 
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> dataValuesAvailable [
	^ self library dataValuesAvailable: handle
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> dateTimeAt: aColumn [	
	^ DateAndTime fromString: (self library stringFrom: handle at: aColumn)
]

{ #category : #initialization }
UDBCSQLite3Statement >> finalize [
	UDBCSQLite3Library current apiFinalize: handle.
	handle := nil
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> floatAt: aColumn [

	^self library floatFrom: handle at: aColumn
]

{ #category : #'private - accessing' }
UDBCSQLite3Statement >> handle [
	^ handle
]

{ #category : #initialization }
UDBCSQLite3Statement >> initialize [

	super initialize.
	handle := UDBCSQLite3StatementExternalObject new.
	FFIExternalResourceManager addResource: handle data: handle
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> integerAt: aColumn [ 
	^self library integerFrom: handle at: aColumn
]

{ #category : #private }
UDBCSQLite3Statement >> library [
	^UDBCSQLite3Library current
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> nameOfColumn: aColumn [
	^ self library nameFor: handle at: aColumn
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> objectAt: aColumn [
	^ FLMaterializer materializeFromByteArray: (self library blobFrom: handle at: aColumn)  
]

{ #category : #public }
UDBCSQLite3Statement >> reset [
	connection reset: self
]

{ #category : #private }
UDBCSQLite3Statement >> step [
	^ UDBCSQLite3Library current step: handle
]

{ #category : #operating }
UDBCSQLite3Statement >> stringAt: aColumn [	 
	^ UDBCSQLite3Library current stringFrom: handle at: aColumn
]

{ #category : #public }
UDBCSQLite3Statement >> typeOfColumn: aColumn [
	^ self library typeFor: handle at: aColumn
]

{ #category : #public }
UDBCSQLite3Statement >> valueOfColumn: aColumn [
	^ self perform: (self typeOfColumn: aColumn) with: aColumn

]
