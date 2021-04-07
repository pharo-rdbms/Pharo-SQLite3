"
I represent an SQLite prepared statement.
"
Class {
	#name : #SQLite3PreparedStatement,
	#superclass : #Object,
	#instVars : [
		'connection',
		'handle',
		'changes',
		'columnNames'
	],
	#pools : [
		'SQLite3Constants'
	],
	#category : #'SQLite3-Core-Database'
}

{ #category : #bindings }
SQLite3PreparedStatement >> at: aColumn putBoolean: aBoolean [

	^ self library 
		with: handle 
		at: aColumn 
		putInteger: (aBoolean ifTrue: [ 1 ] ifFalse: [ 0 ])
		
"See http://www.sqlite.org/datatype3.html."
]

{ #category : #bindings }
SQLite3PreparedStatement >> at: aColumn putByteArray: anObject [
	^ self library with: handle at: aColumn putBlob: anObject
]

{ #category : #bindings }
SQLite3PreparedStatement >> at: aColumn putDate: aDate [

	| string |

	string := SQLite3DateTimeString
		streamContents: [ :stream | BasicDatePrinter new printDate: aDate format: #() on: stream ].
	^ self library with: handle at: aColumn putString: string
]

{ #category : #bindings }
SQLite3PreparedStatement >> at: aColumn putDateTime: aDateTime [
	| s |
	
	s := SQLite3DateTimeString streamContents: [ :stream | aDateTime asDateAndTime printOn: stream ].
	^ self library with: handle at: aColumn putString: s
]

{ #category : #bindings }
SQLite3PreparedStatement >> at: aColumn putFloat: aFloat [
	| f |
	
	f := (aFloat isKindOf: Fraction)
		ifTrue: [ aFloat asFloat ]
		ifFalse: [ aFloat ].
	^ self library with: handle at: aColumn putFloat: f
]

{ #category : #bindings }
SQLite3PreparedStatement >> at: aColumn putInteger: anInteger [

	^ self library with: handle at: aColumn putInteger: anInteger
]

{ #category : #bindings }
SQLite3PreparedStatement >> at: aColumn putNil: anObject [
	"Goofy interface note - anObject is ignored here."
	"When used by SQLite3Connection, anObject will always be nil."
	^ self library with: handle putNullAt: aColumn
]

{ #category : #bindings }
SQLite3PreparedStatement >> at: aColumn putObject: anObject [
	^ self library with: handle at: aColumn putBlob: (FLSerializer serializeToByteArray: anObject)
]

{ #category : #bindings }
SQLite3PreparedStatement >> at: aColumn putString: aString [
	^ self library with: handle at: aColumn putString: aString
]

{ #category : #bindings }
SQLite3PreparedStatement >> at: aColumn putTime: aTime [

	| string |

	string := SQLite3DateTimeString streamContents: [ :stream | aTime printOn: stream ].
	^ self library with: handle at: aColumn putString: string
]

{ #category : #public }
SQLite3PreparedStatement >> basicExecute: aBlock [
	| ret |
	
	ret := self step. 
	(ret = SQLITE_DONE) " == SQLITE_DONE, meaning step should not be sent again."
		ifTrue: [ aBlock value: self ]
		ifFalse: [
			[ ret = SQLITE_ROW ] whileTrue: [ " == SQLITE_ROW, meaning another row is available."
				aBlock value: self.
				ret := self step ]]
]

{ #category : #bindings }
SQLite3PreparedStatement >> bindParameterCount [
	^ self library bindParameterCount: handle
]

{ #category : #bindings }
SQLite3PreparedStatement >> bindParameterIndex: aName [
	^ self library bindParameterIndex: handle for: aName
]

{ #category : #bindings }
SQLite3PreparedStatement >> bindParameters: bindings [
	"A 'variable' or 'parameter' token specifies a placeholder in the expression for a value that is filled in at runtime using the sqlite3_bind() family of C/C++ interfaces. Parameters can take several forms:

?NNN		A question mark followed by a number NNN holds a spot for the NNN-th parameter. NNN must be between 1 and SQLITE_MAX_VARIABLE_NUMBER.
?		A question mark that is not followed by a number creates a parameter with a number one greater than the largest parameter number already assigned. If this means the parameter number is greater than SQLITE_MAX_VARIABLE_NUMBER, it is an error. This parameter format is provided for compatibility with other database engines. But because it is easy to miscount the question marks, the use of this parameter format is discouraged. Programmers are encouraged to use one of the symbolic formats below or the ?NNN format above instead.
:AAAA		A colon followed by an identifier name holds a spot for a named parameter with the name :AAAA. Named parameters are also numbered. The number assigned is one greater than the largest parameter number already assigned. If this means the parameter would be assigned a number greater than SQLITE_MAX_VARIABLE_NUMBER, it is an error. To avoid confusion, it is best to avoid mixing named and numbered parameters.
@AAAA		An 'at' sign works exactly like a colon, except that the name of the parameter created is @AAAA.
$AAAA		A dollar-sign followed by an identifier name also holds a spot for a named parameter with the name $AAAA. The identifier name in this case can include one or more occurrences of '::' and a suffix enclosed in '(...)' containing any text at all. This syntax is the form of a variable name in the Tcl programming language. The presence of this syntax results from the fact that SQLite is really a Tcl extension that has escaped into the wild.
Parameters that are not assigned values using sqlite3_bind() are treated as NULL. The sqlite3_bind_parameter_index() interface can be used to translate a symbolic parameter name into its equivalent numeric index."

	(bindings isCollection and: [ bindings isString not ])
		ifFalse: [ SQLite3AbstractError
				signal: 'Unable to execute SQL on instance of ' , bindings class asString ].
			
	bindings
		keysAndValuesDo: [ :k :v | 
			| idx |
			k isInteger
				ifTrue: [ idx := k ]
				ifFalse: [ idx := self bindParameterIndex: k.
					idx = 0
						ifTrue: [ idx := self bindParameterIndex: '@' , k ].
					idx = 0
						ifTrue: [ idx := self bindParameterIndex: ':' , k ].
					idx = 0
						ifTrue: [ idx := self bindParameterIndex: '$' , k ].
					(idx = 0 and: [ k isAllDigits ])
						ifTrue: [ idx := k asInteger ] ].
			idx > 0
				ifTrue: [ self perform: (self dataTypeForObject: v) with: idx with: v ] ]
]

{ #category : #fetching }
SQLite3PreparedStatement >> booleanAt: aColumn [ 
	^self library booleanFrom: handle at: aColumn
]

{ #category : #fetching }
SQLite3PreparedStatement >> byteArrayAt: aColumn [
	^ self library blobFrom: handle at: aColumn

]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> changes [ 
	^changes ifNil: [ changes := 0 ]
]

{ #category : #private }
SQLite3PreparedStatement >> checkOk: aValue [

	"These are normal conditions."	
	aValue = SQLITE_OK ifTrue: [ ^aValue ].
	
	"These are error conditions."
	(aValue = SQLITE_BUSY)
		ifTrue: [ connection signal: SQLite3Busy with: aValue ].
	(aValue = SQLITE_MISUSE)
		ifTrue: [ connection signal: SQLite3Misuse with: aValue ].				

	"Catch any error not specifically handled above."
	connection signal: SQLite3AbstractError with: aValue

]

{ #category : #bindings }
SQLite3PreparedStatement >> clearBindings [ 

	^self library clearBindings: handle on: connection handle
]

{ #category : #public }
SQLite3PreparedStatement >> columnCount [
	^self library columnCount: handle
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> columnNames [ 
	^columnNames ifNil: [ 
		columnNames := Array new: self columnCount.
		(1 to: columnNames size) do: [ :c | columnNames at: c put: (self nameOfColumn: c - 1) ].
		columnNames
	].
]

{ #category : #'private - accessing' }
SQLite3PreparedStatement >> connection: anObject [
	connection := anObject
]

{ #category : #bindings }
SQLite3PreparedStatement >> dataTypeForObject: anObject [

	anObject ifNil: [ ^ #at:putNil: ].

	( anObject isKindOf: Boolean )
		ifTrue: [ ^ #at:putBoolean: ].

	( anObject isKindOf: Integer )
		ifTrue: [ ^ #at:putInteger: ].

	( self isFloatLike: anObject )
		ifTrue: [ ^ #at:putFloat: ].

	( anObject isKindOf: String )
		ifTrue: [ ^ #at:putString: ].

	( anObject isKindOf: ByteArray )
		ifTrue: [ ^ #at:putByteArray: ].

	( anObject isKindOf: DateAndTime )
		ifTrue: [ ^ #at:putDateTime: ].

	( anObject isKindOf: Time )
		ifTrue: [ ^ #at:putTime: ].

	( anObject isKindOf: Date )
		ifTrue: [ ^ #at:putDate: ].

	^ #at:putObject:
]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> dataValuesAvailable [
	^ self library dataValuesAvailable: handle
]

{ #category : #fetching }
SQLite3PreparedStatement >> dateAt: aColumn [

	^ Date fromString: ( self stringAt: aColumn )
]

{ #category : #fetching }
SQLite3PreparedStatement >> dateTimeAt: aColumn [

	^ DateAndTime fromString: ( self stringAt: aColumn )
]

{ #category : #'private - accessing' }
SQLite3PreparedStatement >> dbHandle [
	^(self library dbHandle: handle) 
]

{ #category : #operating }
SQLite3PreparedStatement >> execute: bindings [ 

	| result |
	self checkOk: self reset.
	self clearBindings.
	self bindParameters: bindings. 
	result := self step.
	changes := connection changes.
	^SQLite3Cursor on: self
]

{ #category : #initialization }
SQLite3PreparedStatement >> finalize [
	"Finalize the statement as required by the SQLite3 API. As per the API, the user is expected to finalize a statement after use.
	
	Since executing a new statement without having finalized the previous one might cause SQLITE_BUSY errors, we can't rely on the garbage collector to execute the finalization, or we'll be exposed to non-deterministic behaviour."

	handle
		ifNotNil:
			[ "Remove the statement object from its finalization registry. This should happen before the actual finalization to avoid finalizing the statement twice, which might result in 'undefined and undesirable behavior such as segfaults and heap corruption' as per the SQLite3 API"
			handle manualRelease.
			connection finalize: handle.
			handle := nil ].
	^ 0
]

{ #category : #fetching }
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

{ #category : #fetching }
SQLite3PreparedStatement >> integerAt: aColumn [ 
	^self library integerFrom: handle at: aColumn
]

{ #category : #'private - testing' }
SQLite3PreparedStatement >> isFloatLike: anObject [
	^ (anObject isKindOf: Float) or: [ anObject isKindOf: Fraction ]
		

]

{ #category : #'public - accessing' }
SQLite3PreparedStatement >> isReadOnly [ 
	^self library statementReadOnly: handle
]

{ #category : #'private - accessing' }
SQLite3PreparedStatement >> library [ 
	^SQLite3Library current
]

{ #category : #fetching }
SQLite3PreparedStatement >> nameOfColumn: aColumn [
	^ self library nameFor: handle at: aColumn
]

{ #category : #fetching }
SQLite3PreparedStatement >> nilAt: aColumn [
	^ nil  
]

{ #category : #fetching }
SQLite3PreparedStatement >> objectAt: aColumn [
	^ FLMaterializer materializeFromByteArray: (self library blobFrom: handle at: aColumn)  
]

{ #category : #public }
SQLite3PreparedStatement >> prepare: anSQLText [
	self library prepare: handle on: connection handle with: anSQLText.
]

{ #category : #public }
SQLite3PreparedStatement >> reset [
	^connection reset: self
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
	(aValue = SQLITE_ROW or: [aValue = SQLITE_DONE]) ifTrue: [
		changes := connection changes.
		^aValue  ].
	
	"These are error conditions."
	(aValue = SQLITE_BUSY)
		ifTrue: [ connection signal: SQLite3Busy with: aValue ].
	(aValue = SQLITE_MISUSE)
		ifTrue: [ connection signal: SQLite3Misuse with: aValue ].
	(aValue = SQLITE_CONSTRAINT)
		ifTrue:  [ connection signal: SQLite3ConstraintViolation with: aValue].				

	"Catch any error not specifically handled above."
	connection signal: SQLite3AbstractError with: aValue

]

{ #category : #fetching }
SQLite3PreparedStatement >> stringAt: aColumn [	 
	^ self library stringFrom: handle at: aColumn
]

{ #category : #fetching }
SQLite3PreparedStatement >> timeAt: aColumn [

	^ Time fromString: ( self stringAt: aColumn )
]

{ #category : #fetching }
SQLite3PreparedStatement >> timestampAt: aColumn [

	^ DateAndTime fromString: ( self stringAt: aColumn )
]

{ #category : #fetching }
SQLite3PreparedStatement >> typeOfColumn: aColumn [
	^ self library typeFor: handle at: aColumn
]

{ #category : #fetching }
SQLite3PreparedStatement >> valueOfColumn: aColumn [
	^ self perform: (self typeOfColumn: aColumn) with: aColumn

]
