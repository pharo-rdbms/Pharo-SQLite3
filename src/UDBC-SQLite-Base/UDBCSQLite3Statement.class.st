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
	#pools : [
		'UDBCSQLite3Constants'
	],
	#category : #'UDBC-SQLite-Base-Database'
}

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> at: aColumn putByteArray: anObject [
	^ self library with: handle at: aColumn putBlob: anObject
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> at: aColumn putDateTime: aDateTime [
	| s |
	
	s := UDBCSQLite3DateTimeString streamContents: [ :stream | aDateTime asDateAndTime printOn: stream ].
	^ self library with: handle at: aColumn putString: s
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> at: aColumn putFloat: aFloat [
	| f |
	
	f := (aFloat isKindOf: Fraction)
		ifTrue: [ aFloat asFloat ]
		ifFalse: [ aFloat ].
	^ self library with: handle at: aColumn putFloat: f
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> at: aColumn putInteger: anInteger [

	^ self library with: handle at: aColumn putInteger: anInteger
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> at: aColumn putNil: anObject [
	"Goofy interface note - anObject is ignored here."
	"When used by UDBCSQLite3Connection, anObject will always be nil."
	^ self library with: handle putNullAt: aColumn
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

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> bindParameterCount [
	^ self library bindParameterCount: handle
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> bindParameterIndex: aName [
	^ self library bindParameterIndex: handle for: aName
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> byteArrayAt: aColumn [
	^ self library blobFrom: handle at: aColumn

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
		
	(self isFloatLike: anObject)
		ifTrue: [ ^#at:putFloat: ].
		
	(anObject isKindOf: String)
		ifTrue: [ ^#at:putString: ].
		
	(anObject isKindOf: ByteArray)
		ifTrue: [ ^#at:putByteArray: ].
		
	(self isDateAndTimeLike: anObject)
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
	
	"Let FFIExternalResourceManager take care."
	"UDBCSQLite3Library current apiFinalize: handle."
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
	handle autoRelease
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> integerAt: aColumn [ 
	^self library integerFrom: handle at: aColumn
]

{ #category : #'private - testing' }
UDBCSQLite3Statement >> isDateAndTimeLike: anObject [

	^ ((anObject isKindOf: DateAndTime) or: [ anObject isKindOf: Date ])
			or: [ anObject isKindOf: Time ]
		

]

{ #category : #'private - testing' }
UDBCSQLite3Statement >> isFloatLike: anObject [
	^ (anObject isKindOf: Float) or: [ anObject isKindOf: Fraction ]
		

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
UDBCSQLite3Statement >> nilAt: aColumn [
	^ nil  
]

{ #category : #'public - accessing' }
UDBCSQLite3Statement >> objectAt: aColumn [
	^ FLMaterializer materializeFromByteArray: (self library blobFrom: handle at: aColumn)  
]

{ #category : #public }
UDBCSQLite3Statement >> reset [
	connection reset: self
]

{ #category : #public }
UDBCSQLite3Statement >> step [
	^ self stepOk: (self library step: handle)
]

{ #category : #private }
UDBCSQLite3Statement >> stepOk: aValue [

	"These are normal conditions."	
	(aValue = ROW) ifTrue: [ ^ ROW ].
	(aValue = DONE) ifTrue: [ ^ DONE ].
	
	"These are error conditions."
	(aValue = BUSY)
		ifTrue: [ connection signal: UDBCSQLite3Busy with: aValue ].
	(aValue = MISUSE)
		ifTrue: [ connection signal: UDBCSQLite3Misuse with: aValue ].				

	"Catch any error not specifically handled above."
	connection signal: UDBCSQLite3Error with: aValue

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
