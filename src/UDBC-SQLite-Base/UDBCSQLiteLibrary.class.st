"
I am the (unified) FFI interface to SQLite.
"
Class {
	#name : #UDBCSQLiteLibrary,
	#superclass : #Object,
	#classVars : [
		'Current',
		'DataTypeMap',
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

{ #category : #'private - accessing' }
UDBCSQLiteLibrary class >> dateTimeTypes [
	^ #('datetime' 'date' 'timestamp')
]

{ #category : #'unified FFI - binding' }
UDBCSQLiteLibrary class >> ffiBindingOf: aTypeName [
	 
	^ TypeMap at: aTypeName ifAbsent: [ super ffiBindingOf: aTypeName ]
]

{ #category : #'class initialization' }
UDBCSQLiteLibrary class >> initialize [

	self 
		initializeTypeMap;
		initializeDataTypeMap
]

{ #category : #'private - initialization' }
UDBCSQLiteLibrary class >> initializeDataTypeMap [

	DataTypeMap := Dictionary newFromPairs: #(
		1			#integerAt: 
		2			#floatAt:
		3			#stringAt:
		4			#byteArrayAt:
		5			#nilAt:
	)
]

{ #category : #'private - initialization' }
UDBCSQLiteLibrary class >> initializeTypeMap [

	TypeMap := Dictionary newFromPairs: #(
		sqlite3		      #UDBCSQLiteDatabaseExternalObject
		sqlite3_stmt			#UDBCSQLiteStatementExternalObject
		"sqlite3_backup		NBSQLite3BackupExternalObject 
		sqlite3_blob			NBSQLite3BlobExternalObject "
		sqlite3_int64		FFIInt64
	)
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiBindBlob: aStatement atColumn: aColumn with: aByteArray with: anInteger with: aPointer [
	"int sqlite3_bind_blob(sqlite3_stmt*, int, const void *, int, void(*)(void*))"

	^ self ffiCall: #(int sqlite3_bind_blob (sqlite3_stmt* aStatement, int aColumn, void* aByteArray, int anInteger, int aPointer)) "SQLITE_TRANSIENT"
		module: self library

]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiBindDouble: aStatement atColumn: aColumn with: aFloat [
	"int sqlite3_bind_double(sqlite3_stmt*, int, double)"
	
	^ self ffiCall: #(int sqlite3_bind_double (sqlite3_stmt* aStatement, int aColumn, double aFloat))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiBindInteger: aStatement atColumn: aColumn with: anInteger [
	"int sqlite3_bind_int64(sqlite3_stmt*, int, sqlite_int64)"

	^ self
		ffiCall: #(int sqlite3_bind_int64 (sqlite3_stmt* aStatement,int aColumn,sqlite3_int64 anInteger))
		module: self library
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiBindString: aStatement atColumn: aColumn with: aString with: anInteger with: anotherInteger [
	"int sqlite3_bind_text(sqlite3_stmt*, int, const char*, int, void(*)(void*))"
	 
	^ self ffiCall: #(int sqlite3_bind_text (sqlite3_stmt* aStatement, int aColumn, String aString, int anInteger, int anotherInteger))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiClearBindings: aStatement [
	"int sqlite3_clear_bindings(sqlite3_stmt*)"

	^ self ffiCall: #(int sqlite3_clear_bindings (sqlite3_stmt* aStatement))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiClose: handle [
	"int sqlite3_close(sqlite3*)"
	 
	^self ffiCall: #(int sqlite3_close(sqlite3 *handle)) module: self library.
	 
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiColumnBlob: aStatement atColumn: aColumn [
	"const void *sqlite3_column_blob(sqlite3_stmt*, int)"
	
	^ self ffiCall: #(const void *sqlite3_column_blob (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiColumnBytes: aStatement atColumn: aColumn [
	"int sqlite3_column_bytes(sqlite3_stmt*, int)"

	^ self ffiCall: #(int sqlite3_column_bytes (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiColumnDeclaredType: aStatement atColumn: aColumn [
	"const char *sqlite3_column_decltype(sqlite3_stmt*, int)"

	^ self
		ffiCall: #(#String #sqlite3_column_decltype #(#sqlite3_stmt #aStatement #, #int #aColumn))
		module: self library
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiColumnDouble: aStatement atColumn: aColumn [
	"double sqlite3_column_double(sqlite3_stmt*, int)"

	^ self nbCall: #(double sqlite3_column_double (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiColumnInt: aStatement atColumn: aColumn [
	"int sqlite3_column_int(sqlite3_stmt*, int)"
	 
	^ self ffiCall: #(int sqlite3_column_int (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiColumnName: aStatement atColumn: aColumn [
	"const char *sqlite3_column_name(sqlite3_stmt*, int)"

	^ self
		ffiCall: #(String sqlite3_column_name(sqlite3_stmt* aStatement, int aColumn))
		module: self library
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiColumnText: aStatement atColumn: aColumn [
	"const unsigned char *sqlite3_column_text(sqlite3_stmt*, int)"
	 
	^ self ffiCall: #(String sqlite3_column_text (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiColumnType: aStatement atColumn: aColumn [
	"int sqlite3_column_type(sqlite3_stmt*, int)"

	^ self
		ffiCall: #(int sqlite3_column_type(sqlite3_stmt* aStatement,int aColumn))
		module: self library
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiDataCount: handle [
	"int sqlite3_data_count(sqlite3_stmt*)"
	
	^ self ffiCall: #(int sqlite3_data_count (sqlite3_stmt handle)) module: self library

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

	^ self ffiCall: #(int sqlite3_prepare_v2 (sqlite3* dbHandle, String anSQLText, int textSize, sqlite3_stmt** sHandle, const char** tail))
		module: self library
	
]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiReset: handle [
	"int sqlite3_reset(sqlite3_stmt*)"
	 
	^ self ffiCall: #(int sqlite3_reset (sqlite3_stmt handle))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiStep: handle [
	"int sqlite3_step(sqlite3_stmt*)"
	 
	^ self ffiCall: #(int sqlite3_step (sqlite3_stmt* handle))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLiteLibrary >> apiTrace: handle with: callback with: appdata [
	"void *sqlite3_trace(sqlite3* void(*)(void*, const char*), void*)"
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self ffiCallout 
		options: #( optMayGC );
		function: #(void* sqlite3_trace (sqlite3* handle, FFICallback callback, ExternalAddress appdata))
		module: self library

]

{ #category : #accessing }
UDBCSQLiteLibrary >> blobFrom: aStatement at: aColumn [
	| address size array |
	
	address := self apiColumnBlob: aStatement atColumn: aColumn.
	size := self apiColumnBytes: aStatement atColumn: aColumn.
	array := address copyFrom: 1 to: size.
	^array 
	 
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

{ #category : #cleaning }
UDBCSQLiteLibrary >> clearBindings: sHandle on: dbHandle [
	
	^ self checkForOk: (self apiClearBindings: sHandle) on: dbHandle
	

]

{ #category : #'connection handling' }
UDBCSQLiteLibrary >> close: aHandle [	
	^ self checkForOk: (self apiClose: aHandle) on: aHandle
]

{ #category : #accessing }
UDBCSQLiteLibrary >> dataValuesAvailable: aStatementHandle [
	^ self apiDataCount: aStatementHandle
	

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

{ #category : #accessing }
UDBCSQLiteLibrary >> floatFrom: aStatement at: aColumn [

	^ self apiColumnDouble: aStatement atColumn: aColumn
]

{ #category : #operating }
UDBCSQLiteLibrary >> integerFrom: aStatement at: aColumn [
	^ self apiColumnInt: aStatement atColumn: aColumn
]

{ #category : #'private - accessing' }
UDBCSQLiteLibrary >> library [

	Smalltalk os isMacOS ifTrue: [ ^ #sqlite3 ].
	^ 'sqlite3'
]

{ #category : #accessing }
UDBCSQLiteLibrary >> nameFor: aStatement at: aColumn [
	^ self apiColumnName: aStatement atColumn: aColumn
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
							with: (ExternalAddress new))
		 on: aDBHandle
	

]

{ #category : #cleaning }
UDBCSQLiteLibrary >> reset: aStatementHandle on: aDBHandle [	
	^ self checkForOk: (self apiReset: aStatementHandle) on: aDBHandle
	

]

{ #category : #'private - utilities' }
UDBCSQLiteLibrary >> signal: exceptionClass with: value on: handle [
	(exceptionClass new)
		resultCode: value; 
		signal: (self apiErrorMessage: handle)
]

{ #category : #stepping }
UDBCSQLiteLibrary >> step: aStatementHandle [	
	^ self apiStep: aStatementHandle
	

]

{ #category : #operating }
UDBCSQLiteLibrary >> stringFrom: aStatement at: aColumn [
	^ self utf8StringToPharo: (self apiColumnText: aStatement atColumn: aColumn)
]

{ #category : #tracing }
UDBCSQLiteLibrary >> trace: handle with: callback with: appdata [
	^ self apiTrace: handle with: callback with: appdata

]

{ #category : #'private - utilities' }
UDBCSQLiteLibrary >> typeFor: aStatement at: aColumn [
	| selector declared |
	
	selector := DataTypeMap at: (self apiColumnType: aStatement atColumn: aColumn).
	(selector = #stringAt:) ifTrue: [
		declared := (self apiColumnDeclaredType: aStatement atColumn: aColumn).
		declared notNil ifTrue: [ 
			(self class dateTimeTypes includes: declared asLowercase) ifTrue: [ ^ #dateTimeAt: ]]].
	^ selector

]

{ #category : #'private - conversion' }
UDBCSQLiteLibrary >> utf8StringToPharo: anUTF8String [
	"Converts from SQLite UTF-8 to Pharo Multibyte Characters"
	
	^(ZnCharacterReadStream on: anUTF8String asByteArray readStream) upToEnd
]

{ #category : #operating }
UDBCSQLiteLibrary >> with: aStatement at: aColumn putBlob: aByteArray [
	^ self apiBindBlob: aStatement atColumn: aColumn with: aByteArray with: aByteArray size with: -1 
]

{ #category : #operating }
UDBCSQLiteLibrary >> with: aStatement at: aColumn putFloat: aFloat [
	^ self apiBindDouble: aStatement atColumn: aColumn with: aFloat
]

{ #category : #operating }
UDBCSQLiteLibrary >> with: aStatement at: aColumn putInteger: anInteger [
	^ self apiBindInteger: aStatement atColumn: aColumn with: anInteger   
]

{ #category : #operating }
UDBCSQLiteLibrary >> with: aStatement at: aColumn putString: aString [ 
	^self apiBindString: aStatement atColumn: aColumn with: (self pharoStringToUTF8: aString) with: -1 with: -1 
]
