"
I am the (unified) FFI interface to SQLite.
"
Class {
	#name : #UDBCSQLiteLibrary,
	#superclass : #Object,
	#classVars : [
		'Current',
		'TypeMap'
	],
	#pools : [
		'UDBCSQLiteConstants'
	],
	#category : #'UDBC-SQLite-Base-UFFI'
}

{ #category : #factory }
UDBCSQLiteLibrary class >> current [

	^Current ifNil: [ Current := self new ]
]

{ #category : #'unified FFI - binding' }
UDBCSQLiteLibrary class >> ffiBindingOf: aTypeName [
	 
	^ TypeMap at: aTypeName ifAbsent: [ super ffiBindingOf: aTypeName ]
]

{ #category : #'class initialization' }
UDBCSQLiteLibrary class >> initialize [

	self initializeTypeMap.
]

{ #category : #'private - initialization' }
UDBCSQLiteLibrary class >> initializeTypeMap [

	TypeMap := Dictionary newFromPairs: #(
		sqlite3		      #UDBCSQLiteDatabaseExternalObject
		"sqlite3_stmt			NBSQLite3StatementExternalObject
		sqlite3_backup		NBSQLite3BackupExternalObject 
		sqlite3_blob			NBSQLite3BlobExternalObject 
		sqlite3_int64		NBInt64"
	)
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiOpen: filename via: handle [
	"int sqlite3_open(const char*, sqlite3**)"
	 
	^self ffiCall: #(int sqlite3_open(String filename, sqlite3 *handle)) module: self library.
	 
]

{ #category : #'private - utilities' }
UDBCSQLiteLibrary >> checkForOk: aValue on: aHandle [

	(aValue = OK)
		ifFalse: [ 
			(aValue = BUSY)
				ifTrue: [ self signal: UDBCSQLiteBusy with: aValue on: aHandle ].
			(aValue = LOCKED)
				ifTrue: [ self signal: UDBCSQLiteLocked with: aValue on: aHandle ].
			(aValue = MISUSE)
				ifTrue: [ self signal: UDBCSQLiteMisuse with: aValue on: aHandle ].				
			self signal: UDBCSQLiteError with: aValue on: aHandle ].	
	^ OK
]

{ #category : #'private - accessing' }
UDBCSQLiteLibrary >> library [

	Smalltalk os isMacOS ifTrue: [ ^ #sqlite3 ].
	^ 'sqlite3'
]

{ #category : #'connection handling' }
UDBCSQLiteLibrary >> open: aFilename via: aHandle [	
	^ self checkForOk: (self apiOpen: aFilename via: aHandle) on: aHandle gcPointer
]

{ #category : #'private - conversion' }
UDBCSQLiteLibrary >> pharoStringToUTF8: aPharoString [
	"Converts from Pharo Multibyte Characters to SQLite3 UTF-8 storage format"
	
	^ZnUTF8Encoder new encodeString: aPharoString
]
