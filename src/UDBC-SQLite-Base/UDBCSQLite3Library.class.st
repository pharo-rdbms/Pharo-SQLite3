"
I am the (unified) FFI interface to SQLite.
"
Class {
	#name : #UDBCSQLite3Library,
	#superclass : #Object,
	#classVars : [
		'Current',
		'DataTypeMap',
		'TypeMap'
	],
	#pools : [
		'UDBCSQLite3Constants'
	],
	#category : #'UDBC-SQLite-Base-UFFI'
}

{ #category : #factory }
UDBCSQLite3Library class >> current [

	^Current ifNil: [ Current := self new ]
]

{ #category : #'private - accessing' }
UDBCSQLite3Library class >> dateTimeTypes [
	^ #('datetime' 'date' 'timestamp')
]

{ #category : #'unified FFI - binding' }
UDBCSQLite3Library class >> ffiBindingOf: aTypeName [
	 
	^ TypeMap at: aTypeName ifAbsent: [ super ffiBindingOf: aTypeName ]
]

{ #category : #'class initialization' }
UDBCSQLite3Library class >> initialize [

	self 
		initializeTypeMap;
		initializeDataTypeMap
]

{ #category : #'private - initialization' }
UDBCSQLite3Library class >> initializeDataTypeMap [

	DataTypeMap := Dictionary newFromPairs: #(
		1			#integerAt: 
		2			#floatAt:
		3			#stringAt:
		4			#byteArrayAt:
		5			#nilAt:
	)
]

{ #category : #'private - initialization' }
UDBCSQLite3Library class >> initializeTypeMap [

	TypeMap := Dictionary newFromPairs: #(
		sqlite3		      #UDBCSQLite3DatabaseExternalObject
		sqlite3_stmt			#UDBCSQLite3StatementExternalObject
		"sqlite3_backup		NBSQLite3BackupExternalObject 
		sqlite3_blob			NBSQLite3BlobExternalObject "
		sqlite3_int64		FFIInt64
	)
]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiBindBlob: aStatement atColumn: aColumn with: aByteArray with: anInteger with: aPointer [
	"int sqlite3_bind_blob(sqlite3_stmt*, int, const void *, int, void(*)(void*))"

	^ self ffiCall: #(int sqlite3_bind_blob (sqlite3_stmt* aStatement, int aColumn, void* aByteArray, int anInteger, int aPointer)) "SQLITE_TRANSIENT"
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiBindDouble: aStatement atColumn: aColumn with: aFloat [
	"int sqlite3_bind_double(sqlite3_stmt*, int, double)"
	
	^ self ffiCall: #(int sqlite3_bind_double (sqlite3_stmt* aStatement, int aColumn, double aFloat))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiBindInteger: aStatement atColumn: aColumn with: anInteger [
	"int sqlite3_bind_int64(sqlite3_stmt*, int, sqlite_int64)"

	^ self
		ffiCall: #(int sqlite3_bind_int64 (sqlite3_stmt* aStatement,int aColumn,sqlite3_int64 anInteger))
		module: self library
]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiBindString: aStatement atColumn: aColumn with: aString with: anInteger with: anotherInteger [
	"int sqlite3_bind_text(sqlite3_stmt*, int, const char*, int, void(*)(void*))"
	 
	^ self ffiCall: #(int sqlite3_bind_text (sqlite3_stmt* aStatement, int aColumn, String aString, int anInteger, int anotherInteger))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiChanges: handle [
	"int sqlite3_changes(sqlite3*)"

	^ self ffiCall: #(int sqlite3_changes (sqlite3 *handle))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiClearBindings: aStatement [
	"int sqlite3_clear_bindings(sqlite3_stmt*)"

	^ self ffiCall: #(int sqlite3_clear_bindings (sqlite3_stmt* aStatement))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiClose: handle [
	"int sqlite3_close(sqlite3*)"
	 
	^self ffiCall: #(int sqlite3_close(sqlite3 *handle)) module: self library.
	 
]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiColumnBlob: aStatement atColumn: aColumn [
	"const void *sqlite3_column_blob(sqlite3_stmt*, int)"
	
	^ self ffiCall: #(const void *sqlite3_column_blob (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiColumnBytes: aStatement atColumn: aColumn [
	"int sqlite3_column_bytes(sqlite3_stmt*, int)"

	^ self ffiCall: #(int sqlite3_column_bytes (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiColumnDeclaredType: aStatement atColumn: aColumn [
	"const char *sqlite3_column_decltype(sqlite3_stmt*, int)"

	^ self
		ffiCall: #(String sqlite3_column_decltype #(sqlite3_stmt *aStatement, int aColumn))
		module: self library
]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiColumnDouble: aStatement atColumn: aColumn [
	"double sqlite3_column_double(sqlite3_stmt*, int)"

	^ self nbCall: #(double sqlite3_column_double (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiColumnInt: aStatement atColumn: aColumn [
	"int sqlite3_column_int(sqlite3_stmt*, int)"
	 
	^ self ffiCall: #(int sqlite3_column_int (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiColumnName: aStatement atColumn: aColumn [
	"const char *sqlite3_column_name(sqlite3_stmt*, int)"

	^ self
		ffiCall: #(String sqlite3_column_name(sqlite3_stmt* aStatement, int aColumn))
		module: self library
]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiColumnText: aStatement atColumn: aColumn [
	"const unsigned char *sqlite3_column_text(sqlite3_stmt*, int)"
	 
	^ self ffiCall: #(String sqlite3_column_text (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiColumnType: aStatement atColumn: aColumn [
	"int sqlite3_column_type(sqlite3_stmt*, int)"

	^ self
		ffiCall: #(int sqlite3_column_type(sqlite3_stmt* aStatement,int aColumn))
		module: self library
]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiDataCount: handle [
	"int sqlite3_data_count(sqlite3_stmt*)"
	
	^ self ffiCall: #(int sqlite3_data_count (sqlite3_stmt *handle)) module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiErrorMessage: handle [ 
	"const char *sqlite3_errmsg(sqlite3*)"
	 
	^self ffiCall: #(String sqlite3_errmsg(sqlite3 *handle)) module: self library.
	 
]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiExec: dbHandle withSQLText: anSQLText with: callback with: callbackData with: errorMessageBuffer [
	"int sqlite3_exec(sqlite3*, const char*, int (*callback), void*, char **)"

	^self ffiCall: #(int sqlite3_exec (sqlite3 *dbHandle, String anSQLText, void *callback, void *callbackData, char **errorMessageBuffer))
		module: self library
	
]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiFinalize: handle [
	"int sqlite3_finalize(sqlite3_stmt*)"
	 
	^self ffiCall: #(int sqlite3_finalize(sqlite3_stmt *handle)) module: self library.
	 
]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiOpen: filename via: handle [
	"int sqlite3_open(const char*, sqlite3**)"
	 
	^self ffiCall: #(int sqlite3_open(String filename, sqlite3 **handle)) module: self library.
	 
]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiPrepare: dbHandle withSQLText: anSQLText with: textSize with: sHandle with: tail [
	"int sqlite3_prepare_v2(sqlite3*, const char*, int, sqlite3_stmt**, const char **)"

	^ self ffiCall: #(int sqlite3_prepare_v2 (sqlite3* dbHandle, String anSQLText, int textSize, sqlite3_stmt** sHandle, const char** tail))
		module: self library
	
]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiReset: handle [
	"int sqlite3_reset(sqlite3_stmt*)"
	 
	^ self ffiCall: #(int sqlite3_reset (sqlite3_stmt *handle))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiStep: handle [
	"int sqlite3_step(sqlite3_stmt*)"
	 
	^ self ffiCall: #(int sqlite3_step (sqlite3_stmt* handle))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiTotalChanges: handle [
	"int sqlite3_total_changes(sqlite3*)"

	^ self ffiCall: #(int sqlite3_total_changes (sqlite3 *handle))
		module: self library

]

{ #category : #'private - api' }
UDBCSQLite3Library >> apiTrace: handle with: callback with: appdata [
	"void *sqlite3_trace(sqlite3* void(*)(void*, const char*), void*)"
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self ffiCallout 
		options: #( optMayGC );
		function: #(void* sqlite3_trace (sqlite3* handle, FFICallback callback, ExternalAddress appdata))
		module: self library

]

{ #category : #accessing }
UDBCSQLite3Library >> blobFrom: aStatement at: aColumn [
	| address size array |
	
	address := self apiColumnBlob: aStatement atColumn: aColumn.
	size := self apiColumnBytes: aStatement atColumn: aColumn.
	array := address copyFrom: 1 to: size.
	^array 
	 
]

{ #category : #introspection }
UDBCSQLite3Library >> changes: aHandle [	
	^ self apiChanges: aHandle
	

]

{ #category : #'private - utilities' }
UDBCSQLite3Library >> checkForOk: aValue on: aHandle [

	(aValue = OK)
		ifFalse: [ 
			(aValue = BUSY)
				ifTrue: [ self signal: UDBCSQLite3Busy with: aValue on: aHandle ].
			(aValue = LOCKED)
				ifTrue: [ self signal: UDBCSQLite3Locked with: aValue on: aHandle ].
			(aValue = MISUSE)
				ifTrue: [ self signal: UDBCSQLite3Misuse with: aValue on: aHandle ].				
			self signal: UDBCSQLite3Error with: aValue on: aHandle ].	
	^ OK
]

{ #category : #cleaning }
UDBCSQLite3Library >> clearBindings: sHandle on: dbHandle [
	
	^ self checkForOk: (self apiClearBindings: sHandle) on: dbHandle
	

]

{ #category : #'connection handling' }
UDBCSQLite3Library >> close: aHandle [	
	^ self checkForOk: (self apiClose: aHandle) on: aHandle
]

{ #category : #accessing }
UDBCSQLite3Library >> dataValuesAvailable: aStatementHandle [
	^ self apiDataCount: aStatementHandle
	

]

{ #category : #operating }
UDBCSQLite3Library >> execute: anSQLText on: aDBHandle [
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
UDBCSQLite3Library >> floatFrom: aStatement at: aColumn [

	^ self apiColumnDouble: aStatement atColumn: aColumn
]

{ #category : #operating }
UDBCSQLite3Library >> integerFrom: aStatement at: aColumn [
	^ self apiColumnInt: aStatement atColumn: aColumn
]

{ #category : #'private - accessing' }
UDBCSQLite3Library >> library [

	Smalltalk os isMacOS ifTrue: [ ^ #sqlite3 ].
	^ 'sqlite3'
]

{ #category : #accessing }
UDBCSQLite3Library >> nameFor: aStatement at: aColumn [
	^ self apiColumnName: aStatement atColumn: aColumn
]

{ #category : #'connection handling' }
UDBCSQLite3Library >> open: aFilename via: aHandle [	
	^ self checkForOk: (self apiOpen: aFilename via: aHandle) on: aHandle
]

{ #category : #'private - conversion' }
UDBCSQLite3Library >> pharoStringToUTF8: aPharoString [
	"Converts from Pharo Multibyte Characters to SQLite3 UTF-8 storage format"
	
	^ZnUTF8Encoder new encodeString: aPharoString
]

{ #category : #operating }
UDBCSQLite3Library >> prepare: aStatementHandle on: aDBHandle with: anSQLText [

	^ self checkForOk: (self apiPrepare: aDBHandle 
							withSQLText: anSQLText
							with: (anSQLText size)
							with: aStatementHandle
							with: (ExternalAddress new))
		 on: aDBHandle
	

]

{ #category : #cleaning }
UDBCSQLite3Library >> reset: aStatementHandle on: aDBHandle [	
	^ self checkForOk: (self apiReset: aStatementHandle) on: aDBHandle
	

]

{ #category : #'private - utilities' }
UDBCSQLite3Library >> signal: exceptionClass with: value on: handle [
	(exceptionClass new)
		resultCode: value; 
		signal: (self apiErrorMessage: handle)
]

{ #category : #stepping }
UDBCSQLite3Library >> step: aStatementHandle [	
	^ self apiStep: aStatementHandle
	

]

{ #category : #operating }
UDBCSQLite3Library >> stringFrom: aStatement at: aColumn [
	^ self utf8StringToPharo: (self apiColumnText: aStatement atColumn: aColumn)
]

{ #category : #introspection }
UDBCSQLite3Library >> totalChanges: aHandle [	
	^ self apiTotalChanges: aHandle
	

]

{ #category : #tracing }
UDBCSQLite3Library >> trace: handle with: callback with: appdata [
	^ self apiTrace: handle with: callback with: appdata

]

{ #category : #'private - utilities' }
UDBCSQLite3Library >> typeFor: aStatement at: aColumn [
	| selector declared |
	
	selector := DataTypeMap at: (self apiColumnType: aStatement atColumn: aColumn).
	(selector = #stringAt:) ifTrue: [
		declared := (self apiColumnDeclaredType: aStatement atColumn: aColumn).
		declared notNil ifTrue: [ 
			(self class dateTimeTypes includes: declared asLowercase) ifTrue: [ ^ #dateTimeAt: ]]].
	^ selector

]

{ #category : #'private - conversion' }
UDBCSQLite3Library >> utf8StringToPharo: anUTF8String [
	"Converts from SQLite UTF-8 to Pharo Multibyte Characters"
	
	^(ZnCharacterReadStream on: anUTF8String asByteArray readStream) upToEnd
]

{ #category : #operating }
UDBCSQLite3Library >> with: aStatement at: aColumn putBlob: aByteArray [
	^ self apiBindBlob: aStatement atColumn: aColumn with: aByteArray with: aByteArray size with: -1 
]

{ #category : #operating }
UDBCSQLite3Library >> with: aStatement at: aColumn putFloat: aFloat [
	^ self apiBindDouble: aStatement atColumn: aColumn with: aFloat
]

{ #category : #operating }
UDBCSQLite3Library >> with: aStatement at: aColumn putInteger: anInteger [
	^ self apiBindInteger: aStatement atColumn: aColumn with: anInteger   
]

{ #category : #operating }
UDBCSQLite3Library >> with: aStatement at: aColumn putString: aString [ 
	^self apiBindString: aStatement atColumn: aColumn with: (self pharoStringToUTF8: aString) with: -1 with: -1 
]
