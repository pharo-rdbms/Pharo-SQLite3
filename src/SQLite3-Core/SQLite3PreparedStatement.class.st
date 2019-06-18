"
I represent an SQLite prepared statement.
"
Class {
	#name : #SQLite3PreparedStatement,
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
SQLite3PreparedStatement >> at: aColumn putBoolean: aBoolean [

	^ self library 
		with: handle 
		at: aColumn 
		putInteger: (aBoolean ifTrue: [ 1 ] ifFalse: [ 0 ])
		
"See http://www.sqlite.org/datatype3.html."
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> at: aColumn putByteArray: anObject [
	^ self library with: handle at: aColumn putBlob: anObject
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> at: aColumn putDateTime: aDateTime [
	| s |
	
	s := SQLite3DateTimeString streamContents: [ :stream | aDateTime asDateAndTime printOn: stream ].
	^ self library with: handle at: aColumn putString: s
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> at: aColumn putFloat: aFloat [
	| f |
	
	f := (aFloat isKindOf: Fraction)
		ifTrue: [ aFloat asFloat ]
		ifFalse: [ aFloat ].
	^ self library with: handle at: aColumn putFloat: f
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> at: aColumn putInteger: anInteger [

	^ self library with: handle at: aColumn putInteger: anInteger
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> at: aColumn putNil: anObject [
	"Goofy interface note - anObject is ignored here."
	"When used by SQLite3Connection, anObject will always be nil."
	^ self library with: handle putNullAt: aColumn
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> at: aColumn putObject: anObject [
	^ self library with: handle at: aColumn putBlob: (FLSerializer serializeToByteArray: anObject)
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> at: aColumn putString: aString [
	^ self library with: handle at: aColumn putString: aString
]

{ #category : #public }
SQLite3PreparedStatement >> basicExecute: aBlock [
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
SQLite3PreparedStatement >> bindParameterCount [
	^ self library bindParameterCount: handle
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> bindParameterIndex: aName [
	^ self library bindParameterIndex: handle for: aName
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> booleanAt: aColumn [ 
	^self library booleanFrom: handle at: aColumn
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> byteArrayAt: aColumn [
	^ self library blobFrom: handle at: aColumn

]

{ #category : #public }
SQLite3PreparedStatement >> clearBindings [
	connection clearBindings: self
]

{ #category : #'private - accessing' }
SQLite3PreparedStatement >> connection: anObject [
	connection := anObject
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> dataTypeForObject: anObject [

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
SQLite3PreparedStatement >> dataValuesAvailable [
	^ self library dataValuesAvailable: handle
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> dateTimeAt: aColumn [	
	^ DateAndTime fromString: (self library stringFrom: handle at: aColumn)
]

{ #category : #initialization }
SQLite3PreparedStatement >> finalize [
	| result |
	
	result := connection finalize: self sqlText.
	"Let FFIExternalResourceManager take care."
	"SQLite3Library current apiFinalize: handle."
	handle := nil.
	^ 0
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> floatAt: aColumn [

	^self library floatFrom: handle at: aColumn
]

{ #category : #'private - accessing' }
SQLite3PreparedStatement >> handle [
	^ handle
]

{ #category : #initialization }
SQLite3PreparedStatement >> initialize [

	super initialize.
	handle := SQLite3StatementExternalObject new.
	handle autoRelease
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> integerAt: aColumn [ 
	^self library integerFrom: handle at: aColumn
]

{ #category : #'private - testing' }
SQLite3PreparedStatement >> isDateAndTimeLike: anObject [

	^ ((anObject isKindOf: DateAndTime) or: [ anObject isKindOf: Date ])
			or: [ anObject isKindOf: Time ]
		

]

{ #category : #'private - testing' }
SQLite3PreparedStatement >> isFloatLike: anObject [
	^ (anObject isKindOf: Float) or: [ anObject isKindOf: Fraction ]
		

]

{ #category : #private }
SQLite3PreparedStatement >> library [
	^SQLite3Library current
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> nameOfColumn: aColumn [
	^ self library nameFor: handle at: aColumn
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> nilAt: aColumn [
	^ nil  
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> objectAt: aColumn [
	^ FLMaterializer materializeFromByteArray: (self library blobFrom: handle at: aColumn)  
]

{ #category : #public }
SQLite3PreparedStatement >> reset [
	connection reset: self
]

{ #category : #operating }
SQLite3PreparedStatement >> sqlText [ 
	^ self library sqlText: handle
]

{ #category : #public }
SQLite3PreparedStatement >> step [
	^ self stepOk: (self library step: handle)
]

{ #category : #private }
SQLite3PreparedStatement >> stepOk: aValue [

	"These are normal conditions."	
	(aValue = SQLITE_ROW) ifTrue: [ ^ SQLITE_ROW ].
	(aValue = SQLITE_DONE) ifTrue: [ ^ SQLITE_DONE ].
	
	"These are error conditions."
	(aValue = SQLITE_BUSY)
		ifTrue: [ connection signal: SQLite3Busy with: aValue ].
	(aValue = SQLITE_MISUSE)
		ifTrue: [ connection signal: SQLite3Misuse with: aValue ].				

	"Catch any error not specifically handled above."
	connection signal: SQLite3AbstractError with: aValue

]

{ #category : #operating }
SQLite3PreparedStatement >> stringAt: aColumn [	 
	^ self library stringFrom: handle at: aColumn
]

{ #category : #public }
SQLite3PreparedStatement >> typeOfColumn: aColumn [
	^ self library typeFor: handle at: aColumn
]

{ #category : #public }
SQLite3PreparedStatement >> valueOfColumn: aColumn [
	^ self perform: (self typeOfColumn: aColumn) with: aColumn

]
