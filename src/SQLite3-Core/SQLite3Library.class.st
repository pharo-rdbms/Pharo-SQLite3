"
I am the (unified) FFI interface to SQLite.
"
Class {
	#name : #SQLite3Library,
	#superclass : #Object,
	#classVars : [
		'Current',
		'DataTypeMap',
		'TypeMap'
	],
	#pools : [
		'SQLite3Constants'
	],
	#category : #'SQLite3-Core-UFFI'
}

{ #category : #'private - accessing' }
SQLite3Library class >> booleanSQLFalseWords [
	^ #('false' 'f')
]

{ #category : #'private - accessing' }
SQLite3Library class >> booleanSQLTrueWords [
	^ #('true' 't')
]

{ #category : #'private - accessing' }
SQLite3Library class >> booleanTypes [
	^ #('boolean' 'bool')
]

{ #category : #factory }
SQLite3Library class >> current [

	^Current ifNil: [ Current := self new ]
]

{ #category : #'private - accessing' }
SQLite3Library class >> dateTimeTypes [
	^ #('datetime' 'date' 'timestamp' 'time')
]

{ #category : #'unified FFI - binding' }
SQLite3Library class >> ffiBindingOf: aTypeName [
	 
	^ TypeMap at: aTypeName ifAbsent: [ super ffiBindingOf: aTypeName ]
]

{ #category : #'class initialization' }
SQLite3Library class >> initialize [

	self 
		initializeTypeMap;
		initializeDataTypeMap
]

{ #category : #'private - initialization' }
SQLite3Library class >> initializeDataTypeMap [

	DataTypeMap := Dictionary newFromPairs: #(
		1			#integerAt: 
		2			#floatAt:
		3			#stringAt:
		4			#byteArrayAt:
		5			#nilAt:
	)
]

{ #category : #'private - initialization' }
SQLite3Library class >> initializeTypeMap [

	TypeMap := Dictionary newFromPairs: #(
		sqlite3		      #SQLite3DatabaseExternalObject
		sqlite3_stmt			#SQLite3StatementExternalObject
		"sqlite3_backup		NBSQLite3BackupExternalObject 
		sqlite3_blob			NBSQLite3BlobExternalObject "
		sqlite3_int64		FFIInt64
	)
]

{ #category : #factory }
SQLite3Library class >> reset [
	Current := nil
]

{ #category : #'private - api' }
SQLite3Library >> apiBindBlob: aStatement atColumn: aColumn with: aByteArray with: anInteger with: aPointer [
	"int sqlite3_bind_blob(sqlite3_stmt*, int, const void *, int, void(*)(void*))"

	^ self ffiCall: #(int sqlite3_bind_blob (sqlite3_stmt* aStatement, int aColumn, void* aByteArray, int anInteger, int aPointer)) "SQLITE_TRANSIENT"
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiBindDouble: aStatement atColumn: aColumn with: aFloat [
	"int sqlite3_bind_double(sqlite3_stmt*, int, double)"
	
	^ self ffiCall: #(int sqlite3_bind_double (sqlite3_stmt* aStatement, int aColumn, double aFloat))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiBindInteger: aStatement atColumn: aColumn with: anInteger [
	"int sqlite3_bind_int64(sqlite3_stmt*, int, sqlite_int64)"

	^ self
		ffiCall: #(int sqlite3_bind_int64 (sqlite3_stmt* aStatement,int aColumn,sqlite3_int64 anInteger))
		module: self library
]

{ #category : #'private - api' }
SQLite3Library >> apiBindNull: aStatement atColumn: aColumn [
	"int sqlite3_bind_null(sqlite3_stmt*, int)"

	^ self ffiCall: #(int sqlite3_bind_null (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiBindParameterCount: aStatement [
	"int sqlite3_bind_parameter_count(sqlite3_stmt*)"

	^ self ffiCall: #(int sqlite3_bind_parameter_count (sqlite3_stmt* aStatement))
		module: self library
]

{ #category : #'private - api' }
SQLite3Library >> apiBindParameterIndex: aStatement for: aName [
	"int sqlite3_bind_parameter_index(sqlite3_stmt*, const char* zName)"

	^ self ffiCall: #(int sqlite3_bind_parameter_index (sqlite3_stmt* aStatement, String aName))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiBindString: aStatement atColumn: aColumn with: aString with: anInteger with: anotherInteger [
	"int sqlite3_bind_text(sqlite3_stmt*, int, const char*, int, void(*)(void*))"
	 
	^ self ffiCall: #(int sqlite3_bind_text (sqlite3_stmt* aStatement, int aColumn, String aString, int anInteger, int anotherInteger))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiChanges: handle [
	"int sqlite3_changes(sqlite3*)"

	^ self ffiCall: #(int sqlite3_changes (sqlite3 *handle))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiClearBindings: aStatement [
	"int sqlite3_clear_bindings(sqlite3_stmt*)"

	^ self ffiCall: #(int sqlite3_clear_bindings (sqlite3_stmt* aStatement))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiClose: handle [
	"int sqlite3_close(sqlite3*)"
	 
	^self ffiCall: #(int sqlite3_close(sqlite3 *handle)) module: self library.
	 
]

{ #category : #'private - api' }
SQLite3Library >> apiColumnBlob: aStatement atColumn: aColumn [
	"const void *sqlite3_column_blob(sqlite3_stmt*, int)"
	
	^ self ffiCall: #(const void *sqlite3_column_blob (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiColumnBytes: aStatement atColumn: aColumn [
	"int sqlite3_column_bytes(sqlite3_stmt*, int)"

	^ self ffiCall: #(int sqlite3_column_bytes (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiColumnDeclaredType: aStatement atColumn: aColumn [
	"const char *sqlite3_column_decltype(sqlite3_stmt*, int)"

	^ self
		ffiCall: #(String sqlite3_column_decltype #(sqlite3_stmt *aStatement, int aColumn))
		module: self library
]

{ #category : #'private - api' }
SQLite3Library >> apiColumnDouble: aStatement atColumn: aColumn [
	"double sqlite3_column_double(sqlite3_stmt*, int)"

	^ self nbCall: #(double sqlite3_column_double (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiColumnInt: aStatement atColumn: aColumn [
	"int sqlite3_column_int(sqlite3_stmt*, int)"
	 
	^ self ffiCall: #(sqlite3_int64 sqlite3_column_int64 (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiColumnName: aStatement atColumn: aColumn [
	"const char *sqlite3_column_name(sqlite3_stmt*, int)"

	^ self
		ffiCall: #(String sqlite3_column_name(sqlite3_stmt* aStatement, int aColumn))
		module: self library
]

{ #category : #'private - api' }
SQLite3Library >> apiColumnText: aStatement atColumn: aColumn [
	"const unsigned char *sqlite3_column_text(sqlite3_stmt*, int)"
	 
	^ self ffiCall: #(String sqlite3_column_text (sqlite3_stmt* aStatement, int aColumn))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiColumnType: aStatement atColumn: aColumn [
	"int sqlite3_column_type(sqlite3_stmt*, int)"

	^ self
		ffiCall: #(int sqlite3_column_type(sqlite3_stmt* aStatement,int aColumn))
		module: self library
]

{ #category : #'private - api' }
SQLite3Library >> apiConfigLoadExtension: dbHandle with: op with: onoff with: retpointer [
	"This is a specific invocation of sqlite3_db_config(sqlite3*, int, ...)."

	^self ffiCall: #(int sqlite3_db_config (sqlite3 *dbHandle, int op, int onoff, int *retpointer))
		module: self library

"Notes from https://www.sqlite.org/c3ref/c_dbconfig_enable_fkey.html:
op == SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION
This option is used to enable or disable the sqlite3_load_extension() interface independently of the load_extension() SQL function. The sqlite3_enable_load_extension() API enables or disables both the C-API sqlite3_load_extension() and the SQL function load_extension(). There should be two additional arguments. When the first argument to this interface is 1, then only the C-API is enabled and the SQL function remains disabled. If the first argument to this interface is 0, then both the C-API and the SQL function are disabled. If the first argument is -1, then no changes are made to state of either the C-API or the SQL function. The second parameter is a pointer to an integer into which is written 0 or 1 to indicate whether sqlite3_load_extension() interface is disabled or enabled following this call. The second parameter may be a NULL pointer, in which case the new setting is not reported back. 
"	
]

{ #category : #'private - api' }
SQLite3Library >> apiDataCount: handle [
	"int sqlite3_data_count(sqlite3_stmt*)"
	
	^ self ffiCall: #(int sqlite3_data_count (sqlite3_stmt *handle)) module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiErrorMessage: handle [ 
	"const char *sqlite3_errmsg(sqlite3*)"
	 
	^self ffiCall: #(String sqlite3_errmsg(sqlite3 *handle)) module: self library.
	 
]

{ #category : #'private - api' }
SQLite3Library >> apiExec: dbHandle withSQLText: anSQLText with: callback with: callbackData with: errorMessageBuffer [
	"int sqlite3_exec(sqlite3*, const char*, int (*callback), void*, char **)"

	^self ffiCall: #(int sqlite3_exec (sqlite3 *dbHandle, String anSQLText, void *callback, void *callbackData, char **errorMessageBuffer))
		module: self library
	
]

{ #category : #'private - api' }
SQLite3Library >> apiFinalize: handle [
	"int sqlite3_finalize(sqlite3_stmt*)"
	 
	^self ffiCall: #(int sqlite3_finalize(sqlite3_stmt *handle)) module: self library.
	 
]

{ #category : #'private - api' }
SQLite3Library >> apiLoadExtension: dbHandle with: zFile with: zProc with: pzErrMsg [
	"int sqlite3_load_extension(sqlite3*, const char*, const char*, char **)."

	^self ffiCall: #(int sqlite3_load_extension (sqlite3 *dbHandle, String zFile, const char *zProc, char **pzErrMsg))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiOpen: filename via: handle [
	"int sqlite3_open(const char*, sqlite3**)"
	 
	^self ffiCall: #(int sqlite3_open(String filename, sqlite3 **handle)) module: self library.
	 
]

{ #category : #'private - api' }
SQLite3Library >> apiPrepare: dbHandle withSQLText: anSQLText with: textSize with: sHandle with: tail [
	"int sqlite3_prepare_v2(sqlite3*, const char*, int, sqlite3_stmt**, const char **)"

	^ self ffiCall: #(int sqlite3_prepare_v2 (sqlite3* dbHandle, String anSQLText, int textSize, sqlite3_stmt** sHandle, const char** tail))
		module: self library
	
]

{ #category : #'private - api' }
SQLite3Library >> apiReset: handle [
	"int sqlite3_reset(sqlite3_stmt*)"
	 
	^ self ffiCall: #(int sqlite3_reset (sqlite3_stmt *handle))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiSql: handle [
	"const char *sqlite3_sql(sqlite3_stmt*)"
	 
	^ self ffiCall: #(String sqlite3_sql (sqlite3_stmt* handle))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiStep: handle [
	"int sqlite3_step(sqlite3_stmt*)"
	 
	^ self ffiCall: #(int sqlite3_step (sqlite3_stmt* handle))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiTotalChanges: handle [
	"int sqlite3_total_changes(sqlite3*)"

	^ self ffiCall: #(int sqlite3_total_changes (sqlite3 *handle))
		module: self library

]

{ #category : #'private - api' }
SQLite3Library >> apiTrace: handle with: callback with: appdata [
	"void *sqlite3_trace(sqlite3* void(*)(void*, const char*), void*)"
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self ffiCallout 
		options: #( optMayGC );
		function: #(void* sqlite3_trace (sqlite3* handle, FFICallback callback, ExternalAddress appdata))
		module: self library

]

{ #category : #operating }
SQLite3Library >> bindParameterCount: aStatementHandle [
	^ self apiBindParameterCount: aStatementHandle
]

{ #category : #operating }
SQLite3Library >> bindParameterIndex: aStatementHandle for: aName [
	^ self apiBindParameterIndex: aStatementHandle for: aName
	

]

{ #category : #accessing }
SQLite3Library >> blobFrom: aStatement at: aColumn [
	| address size array |
	
	address := self apiColumnBlob: aStatement atColumn: aColumn.
	size := self apiColumnBytes: aStatement atColumn: aColumn.
	array := address copyFrom: 1 to: size.
	^array 
	 
]

{ #category : #accessing }
SQLite3Library >> booleanFrom: aStatement at: aColumn [
	| declared selector value |
	
	declared := self apiColumnDeclaredType: aStatement atColumn: aColumn.
	(self class booleanTypes includes: declared asLowercase) ifFalse: [ 
		SQLite3AbstractError signal: 'Column is not declared as a boolean.' ].

	selector := DataTypeMap at: (self apiColumnType: aStatement atColumn: aColumn).
	(selector = #nilAt:) ifTrue: [ ^ nil ].
	(selector = #stringAt:) 
		ifTrue: [
			value := self apiColumnText: aStatement atColumn: aColumn.
			(self class booleanSQLTrueWords includes: value asLowercase) 
				ifTrue: [ ^ true ]
				ifFalse: [
					(self class booleanSQLFalseWords includes: value asLowercase)
						ifTrue: [ ^ false ]
						ifFalse: [ SQLite3AbstractError signal: 'Column value cannot be read as a boolean.' ]]].
	(selector = #integerAt:) 
		ifTrue: [
			value := self apiColumnInt: aStatement atColumn: aColumn.
			(value = 1)
				ifTrue: [ ^ true ]
				ifFalse: [ 
					(value = 0) 
						ifTrue: [ ^ false ]
						ifFalse: [ SQLite3AbstractError signal: 'Column value cannot be read as a boolean.' ]]]	
 
 
]

{ #category : #introspection }
SQLite3Library >> changes: aHandle [	
	^ self apiChanges: aHandle
	

]

{ #category : #'private - utilities' }
SQLite3Library >> checkForOk: aValue on: aHandle [

	(aValue = SQLITE_OK)
		ifFalse: [  
			(aValue = SQLITE_BUSY)
				ifTrue: [ self signal: SQLite3Busy with: aValue on: aHandle ].
			(aValue = SQLITE_LOCKED)
				ifTrue: [ self signal: SQLite3Locked with: aValue on: aHandle ].
			(aValue = SQLITE_MISUSE)
				ifTrue: [ self signal: SQLite3Misuse with: aValue on: aHandle ].				
			self signal: SQLite3AbstractError with: aValue on: aHandle ].	
	^ SQLITE_OK
]

{ #category : #cleaning }
SQLite3Library >> clearBindings: sHandle on: dbHandle [
	
	^ self checkForOk: (self apiClearBindings: sHandle) on: dbHandle
	

]

{ #category : #'connection handling' }
SQLite3Library >> close: aHandle [	
	^ self checkForOk: (self apiClose: aHandle) on: aHandle
]

{ #category : #accessing }
SQLite3Library >> dataValuesAvailable: aStatementHandle [
	^ self apiDataCount: aStatementHandle
	

]

{ #category : #configuring }
SQLite3Library >> disableLoadExtension: aHandle [
	^ self checkForOk: (self apiConfigLoadExtension: aHandle with: 1005 with: 0 with: ExternalAddress new) 
		on: aHandle
		
"Magic number 1005 = SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION.
See comment in #apiConfigLoadExtension:with:with:with:."

]

{ #category : #configuring }
SQLite3Library >> enableLoadExtension: aHandle [
	^ self checkForOk: (self apiConfigLoadExtension: aHandle with: 1005 with: 1 with: ExternalAddress new) 
		on: aHandle
		
"Magic number 1005 = SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION.
See comment in #apiConfigLoadExtension:with:with:with:."

]

{ #category : #operating }
SQLite3Library >> execute: anSQLText on: aDBHandle [
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
SQLite3Library >> floatFrom: aStatement at: aColumn [

	^ self apiColumnDouble: aStatement atColumn: aColumn
]

{ #category : #operating }
SQLite3Library >> integerFrom: aStatement at: aColumn [
	^ self apiColumnInt: aStatement atColumn: aColumn
]

{ #category : #'private - accessing' }
SQLite3Library >> library [

	Smalltalk os isMacOS ifTrue: [ ^ #sqlite3 ].
	^ 'sqlite3'
]

{ #category : #'private - api' }
SQLite3Library >> loadExtension: dbHandle with: aFilename [

	^ self checkForOk: (self apiLoadExtension: dbHandle 
										with: aFilename
										with: ExternalAddress new
										with: ExternalAddress new)
		on: dbHandle
]

{ #category : #accessing }
SQLite3Library >> nameFor: aStatement at: aColumn [
	^ self apiColumnName: aStatement atColumn: aColumn
]

{ #category : #'connection handling' }
SQLite3Library >> open: aFilename via: aHandle [	
	^ self checkForOk: (self apiOpen: aFilename via: aHandle) on: aHandle
]

{ #category : #'private - conversion' }
SQLite3Library >> pharoStringToUTF8: aPharoString [
	"Converts from Pharo Multibyte Characters to SQLite3 UTF-8 storage format"
	
	^ZnUTF8Encoder new encodeString: aPharoString
]

{ #category : #operating }
SQLite3Library >> prepare: aStatementHandle on: aDBHandle with: anSQLText [
	| utf8SQL |
	
	utf8SQL := self pharoStringToUTF8: anSQLText.
	^ self checkForOk: (self apiPrepare: aDBHandle 
							withSQLText: utf8SQL
							with: utf8SQL size
							with: aStatementHandle
							with: (ExternalAddress new))
		 on: aDBHandle
	

]

{ #category : #cleaning }
SQLite3Library >> reset: aStatementHandle on: aDBHandle [	
	
	^ aStatementHandle 
		ifNil: [ 0 ]
		ifNotNil: [ self checkForOk: (self apiReset: aStatementHandle) on: aDBHandle ]
	

]

{ #category : #'private - utilities' }
SQLite3Library >> signal: exceptionClass with: value on: handle [
	(exceptionClass new)
		resultCode: value; 
		signal: (self apiErrorMessage: handle)
]

{ #category : #stepping }
SQLite3Library >> sqlText: aStatementHandle [	
	^ self apiSql: aStatementHandle
	

]

{ #category : #stepping }
SQLite3Library >> step: aStatementHandle [	
	^ self apiStep: aStatementHandle
	

]

{ #category : #operating }
SQLite3Library >> stringFrom: aStatement at: aColumn [
	^ self utf8StringToPharo: (self apiColumnText: aStatement atColumn: aColumn)
]

{ #category : #introspection }
SQLite3Library >> totalChanges: aHandle [	
	^ self apiTotalChanges: aHandle
	

]

{ #category : #tracing }
SQLite3Library >> trace: handle with: callback with: appdata [
	^ self apiTrace: handle with: callback with: appdata

]

{ #category : #'private - utilities' }
SQLite3Library >> typeFor: aStatement at: aColumn [
	| selector declared |
	
	declared := (self apiColumnDeclaredType: aStatement atColumn: aColumn).
	declared notNil ifTrue: [
		"Handle column type of boolean as a special case."
		(self class booleanTypes includes: declared) ifTrue: [ ^ #booleanAt: ]].
	
	selector := DataTypeMap at: (self apiColumnType: aStatement atColumn: aColumn).
	(selector = #stringAt:) ifTrue: [
		declared notNil ifTrue: [ 
			"Handle column type of date/time as a special case."
			(self class dateTimeTypes includes: declared asLowercase) ifTrue: [ ^ #dateTimeAt: ]]].
	^ selector

]

{ #category : #'private - conversion' }
SQLite3Library >> utf8StringToPharo: anUTF8String [
	"Converts from SQLite UTF-8 to Pharo Multibyte Characters"
	
	^(ZnCharacterReadStream on: anUTF8String asByteArray readStream) upToEnd
]

{ #category : #operating }
SQLite3Library >> with: aStatement at: aColumn putBlob: aByteArray [
	^ self apiBindBlob: aStatement atColumn: aColumn with: aByteArray with: aByteArray size with: -1 
]

{ #category : #operating }
SQLite3Library >> with: aStatement at: aColumn putFloat: aFloat [
	^ self apiBindDouble: aStatement atColumn: aColumn with: aFloat
]

{ #category : #operating }
SQLite3Library >> with: aStatement at: aColumn putInteger: anInteger [
	^ self apiBindInteger: aStatement atColumn: aColumn with: anInteger   
]

{ #category : #operating }
SQLite3Library >> with: aStatement at: aColumn putString: aString [
	| s |
	
	s := self pharoStringToUTF8: aString.
	^self apiBindString: aStatement atColumn: aColumn with: s with: s size with: -1 
]

{ #category : #operating }
SQLite3Library >> with: aStatement putNullAt: aColumn [ 
	^ self apiBindNull: aStatement atColumn: aColumn

]
