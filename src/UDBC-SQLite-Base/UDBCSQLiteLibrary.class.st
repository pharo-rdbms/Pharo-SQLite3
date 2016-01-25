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
		sqlite3_stmt			#UDBCSQLiteStatementExternalObject
		"sqlite3_backup		NBSQLite3BackupExternalObject 
		sqlite3_blob			NBSQLite3BlobExternalObject 
		sqlite3_int64		NBInt64"
	)
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiClose: handle [
	"int sqlite3_close(sqlite3*)"
	 
	^self ffiCall: #(int sqlite3_close(sqlite3 *handle)) module: self library.
	 
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiErrorMessage: handle [ 
	"const char *sqlite3_errmsg(sqlite3*)"
	 
	^self ffiCall: #(String sqlite3_errmsg(sqlite3 *handle)) module: self library.
	 
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiExec: dbHandle withSQLText: anSQLText with: callback with: callbackData with: errorMessageBuffer [
	"int sqlite3_exec(sqlite3*, const char*, int (*callback), void*, char **)"

	^self ffiCall: #(int sqlite3_exec (sqlite3 dbHandle, String anSQLText, void *callback, void *callbackData, char **errorMessageBuffer))
		module: self library
	
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiFinalize: handle [
	"int sqlite3_finalize(sqlite3_stmt*)"
	 
	^self ffiCall: #(int sqlite3_finalize(sqlite3_stmt handle)) module: self library.
	 
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiOpen: filename via: handle [
	"int sqlite3_open(const char*, sqlite3**)"
	 
	^self ffiCall: #(int sqlite3_open(String filename, sqlite3 **handle)) module: self library.
	 
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiPrepare: dbHandle withSQLText: anSQLText with: textSize with: sHandle with: tail [
	"int sqlite3_prepare_v2(sqlite3*, const char*, int, sqlite3_stmt**, const char **)"

	^ self ffiCall: #(int sqlite3_prepare_v2 (sqlite3 dbHandle, String anSQLText, int textSize, sqlite3_stmt* sHandle, const char** tail))
		module: self library
	
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

{ #category : #'connection handling' }
UDBCSQLiteLibrary >> close: aHandle [	
	^ self checkForOk: (self apiClose: aHandle) on: aHandle
]

{ #category : #operating }
UDBCSQLiteLibrary >> execute: anSQLText on: aDBHandle [
	| null |	
	null := ExternalAddress new.
	^ self checkForOk: (self apiExec: aDBHandle 
							withSQLText: anSQLText
							with: null
							with: null
							with: null)
		 on: aDBHandle
	
]

{ #category : #'private - accessing' }
UDBCSQLiteLibrary >> library [

	Smalltalk os isMacOS ifTrue: [ ^ #sqlite3 ].
	^ 'sqlite3'
]

{ #category : #'connection handling' }
UDBCSQLiteLibrary >> open: aFilename via: aHandle [	
	^ self checkForOk: (self apiOpen: aFilename via: aHandle) on: aHandle
]

{ #category : #'private - conversion' }
UDBCSQLiteLibrary >> pharoStringToUTF8: aPharoString [
	"Converts from Pharo Multibyte Characters to SQLite3 UTF-8 storage format"
	
	^ZnUTF8Encoder new encodeString: aPharoString
]

{ #category : #operating }
UDBCSQLiteLibrary >> prepare: aStatementHandle on: aDBHandle with: anSQLText [

	^ self checkForOk: (self apiPrepare: aDBHandle 
							withSQLText: anSQLText
							with: (anSQLText size)
							with: aStatementHandle
							with: (ExternalAddress null))
		 on: aDBHandle
	

]

{ #category : #'private - utilities' }
UDBCSQLiteLibrary >> signal: exceptionClass with: value on: handle [
	(exceptionClass new)
		resultCode: value; 
		signal: (self apiErrorMessage: handle)
]
