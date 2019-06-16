"
I represent an SQLite prepared statement.
"
Class {
	#name : #SQLite3Statement,
	#superclass : #Object,
	#instVars : [
		'connection',
		'handle'
	],
	#pools : [
		'SQLite3Constants'
	],
	#category : #'SQLite3-Core-Database'
}

{ #category : #'public - accessing' }
SQLite3Statement >> at: aColumn putBoolean: aBoolean [

	^ self library 
		with: handle 
		at: aColumn 
		putInteger: (aBoolean ifTrue: [ 1 ] ifFalse: [ 0 ])
		
"See http://www.sqlite.org/datatype3.html."
]

{ #category : #'public - accessing' }
SQLite3Statement >> at: aColumn putByteArray: anObject [
	^ self library with: handle at: aColumn putBlob: anObject
]

{ #category : #'public - accessing' }
SQLite3Statement >> at: aColumn putDateTime: aDateTime [
	| s |
	
	s := SQLite3DateTimeString streamContents: [ :stream | aDateTime asDateAndTime printOn: stream ].
	^ self library with: handle at: aColumn putString: s
]

{ #category : #'public - accessing' }
SQLite3Statement >> at: aColumn putFloat: aFloat [
	| f |
	
	f := (aFloat isKindOf: Fraction)
		ifTrue: [ aFloat asFloat ]
		ifFalse: [ aFloat ].
	^ self library with: handle at: aColumn putFloat: f
]

{ #category : #'public - accessing' }
SQLite3Statement >> at: aColumn putInteger: anInteger [

	^ self library with: handle at: aColumn putInteger: anInteger
]

{ #category : #'public - accessing' }
SQLite3Statement >> at: aColumn putNil: anObject [
	"Goofy interface note - anObject is ignored here."
	"When used by SQLite3Connection, anObject will always be nil."
	^ self library with: handle putNullAt: aColumn
]

{ #category : #'public - accessing' }
SQLite3Statement >> at: aColumn putObject: anObject [
	^ self library with: handle at: aColumn putBlob: (FLSerializer serializeToByteArray: anObject)
]

{ #category : #'public - accessing' }
SQLite3Statement >> at: aColumn putString: aString [
	^ self library with: handle at: aColumn putString: aString
]

{ #category : #public }
SQLite3Statement >> basicExecute: aBlock [
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
SQLite3Statement >> bindParameterCount [
	^ self library bindParameterCount: handle
]

{ #category : #'public - accessing' }
SQLite3Statement >> bindParameterIndex: aName [
	^ self library bindParameterIndex: handle for: aName
]

{ #category : #'public - accessing' }
SQLite3Statement >> booleanAt: aColumn [ 
	^self library booleanFrom: handle at: aColumn
]

{ #category : #'public - accessing' }
SQLite3Statement >> byteArrayAt: aColumn [
	^ self library blobFrom: handle at: aColumn

]

{ #category : #public }
SQLite3Statement >> clearBindings [
	connection clearBindings: self
]

{ #category : #'private - accessing' }
SQLite3Statement >> connection: anObject [
	connection := anObject
]

{ #category : #'public - accessing' }
SQLite3Statement >> dataTypeForObject: anObject [

	anObject ifNil: [ ^#at:putNil: ].

	(anObject isKindOf: Boolean)
		ifTrue: [ ^#at:putBoolean: ].

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
SQLite3Statement >> dataValuesAvailable [
	^ self library dataValuesAvailable: handle
]

{ #category : #'public - accessing' }
SQLite3Statement >> dateTimeAt: aColumn [	
	^ DateAndTime fromString: (self library stringFrom: handle at: aColumn)
]

{ #category : #initialization }
SQLite3Statement >> finalize [
	| result |
	
	result := connection finalize: self sqlText.
	"Let FFIExternalResourceManager take care."
	"SQLite3Library current apiFinalize: handle."
	handle := nil.
	^ 0
]

{ #category : #'public - accessing' }
SQLite3Statement >> floatAt: aColumn [

	^self library floatFrom: handle at: aColumn
]

{ #category : #'private - accessing' }
SQLite3Statement >> handle [
	^ handle
]

{ #category : #initialization }
SQLite3Statement >> initialize [

	super initialize.
	handle := SQLite3StatementExternalObject new.
	handle autoRelease
]

{ #category : #'public - accessing' }
SQLite3Statement >> integerAt: aColumn [ 
	^self library integerFrom: handle at: aColumn
]

{ #category : #'private - testing' }
SQLite3Statement >> isDateAndTimeLike: anObject [

	^ ((anObject isKindOf: DateAndTime) or: [ anObject isKindOf: Date ])
			or: [ anObject isKindOf: Time ]
		

]

{ #category : #'private - testing' }
SQLite3Statement >> isFloatLike: anObject [
	^ (anObject isKindOf: Float) or: [ anObject isKindOf: Fraction ]
		

]

{ #category : #private }
SQLite3Statement >> library [
	^SQLite3Library current
]

{ #category : #'public - accessing' }
SQLite3Statement >> nameOfColumn: aColumn [
	^ self library nameFor: handle at: aColumn
]

{ #category : #'public - accessing' }
SQLite3Statement >> nilAt: aColumn [
	^ nil  
]

{ #category : #'public - accessing' }
SQLite3Statement >> objectAt: aColumn [
	^ FLMaterializer materializeFromByteArray: (self library blobFrom: handle at: aColumn)  
]

{ #category : #public }
SQLite3Statement >> reset [
	connection reset: self
]

{ #category : #operating }
SQLite3Statement >> sqlText [ 
	^ self library sqlText: handle
]

{ #category : #public }
SQLite3Statement >> step [
	^ self stepOk: (self library step: handle)
]

{ #category : #private }
SQLite3Statement >> stepOk: aValue [

	"These are normal conditions."	
	(aValue = ROW) ifTrue: [ ^ ROW ].
	(aValue = DONE) ifTrue: [ ^ DONE ].
	
	"These are error conditions."
	(aValue = BUSY)
		ifTrue: [ connection signal: SQLite3Busy with: aValue ].
	(aValue = MISUSE)
		ifTrue: [ connection signal: SQLite3Misuse with: aValue ].				

	"Catch any error not specifically handled above."
	connection signal: SQLite3Error with: aValue

]

{ #category : #operating }
SQLite3Statement >> stringAt: aColumn [	 
	^ self library stringFrom: handle at: aColumn
]

{ #category : #public }
SQLite3Statement >> typeOfColumn: aColumn [
	^ self library typeFor: handle at: aColumn
]

{ #category : #public }
SQLite3Statement >> valueOfColumn: aColumn [
	^ self perform: (self typeOfColumn: aColumn) with: aColumn

]
