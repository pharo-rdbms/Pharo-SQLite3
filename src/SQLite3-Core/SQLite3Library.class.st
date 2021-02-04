"
I am the (unified) FFI interface to SQLite.
"
Class {
	#name : #SQLite3Library,
	#superclass : #FFILibrary,
	#classVars : [
		'DataTypeMap',
		'DateTimeTypeMap',
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
	^self uniqueInstance
]

{ #category : #'unified FFI - binding' }
SQLite3Library class >> ffiBindingOf: aTypeName [
	 
	^ TypeMap at: aTypeName ifAbsent: [ super ffiBindingOf: aTypeName ]
]

{ #category : #'class initialization' }
SQLite3Library class >> initialize [

	self 
		initializeTypeMap;
		initializeDataTypeMap;
		initializeDateTimeTypeMap
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

{ #category : #'private - accessing' }
SQLite3Library class >> initializeDateTimeTypeMap [
	DateTimeTypeMap := { 
		'datetime' -> #dateTimeAt:.
		'date' -> #dateAt:.
		'timestamp' -> #timestampAt:. 
		'time' -> #timeAt: } asDictionary

]

{ #category : #'private - initialization' }
SQLite3Library class >> initializeTypeMap [

	TypeMap := Dictionary newFromPairs: #(
		sqlite3		      #SQLite3DatabaseExternalObject
		sqlite3_stmt			#SQLite3StatementExternalObject
		sqlite3_backup		#NBSQLite3BackupExternalObject 
		"sqlite3_blob			NBSQLite3BlobExternalObject "
		sqlite3_int64		FFIInt64
	)
]

{ #category : #factory }
SQLite3Library class >> reset [
	uniqueInstance := nil
]

{ #category : #'private - api' }
SQLite3Library >> apiBackupFinish: backupHandle [
	"int sqlite3_backup_finish(sqlite3_backup *p)"
	 
	^ self ffiCall: #(int sqlite3_backup_finish(SQLite3BackupExternalReference *backupHandle))
		

]

{ #category : #'private - api' }
SQLite3Library >> apiBackupPageCount: backupHandle [
	"int sqlite3_backup_pagecount(sqlite3_backup *p)"
	 
	^ self ffiCall: #(int sqlite3_backup_pagecount(sqlite3_backup *backupHandle))

]

{ #category : #'private - api' }
SQLite3Library >> apiBackupRemaining: backupHandle [
	"int sqlite3_backup_remaining(sqlite3_backup *p)"
	 
	^ self ffiCall: #(int sqlite3_backup_remaining(sqlite3_backup *backupHandle))
]

{ #category : #'private - api' }
SQLite3Library >> apiBackupStep:nPage via: backupHandle [
	"int sqlite3_backup_step(sqlite3_backup *p, int nPage)"
	 
	^ self ffiCall: #(int sqlite3_backup_step(SQLite3BackupExternalReference *backupHandle, int nPage))
]

{ #category : #'private - api' }
SQLite3Library >> apiBackupTo: pDest named: zDestName from: pSource named: zSourceName [
	"sqlite3_backup *sqlite3_backup_init(
  sqlite3 *pDest,                        /* Destination database handle */
  const char *zDestName,                 /* Destination database name */
  sqlite3 *pSource,                      /* Source database handle */
  const char *zSourceName                /* Source database name */
)"
	 
	^ self ffiCall: #(SQLite3BackupExternalReference *sqlite3_backup_init(
  sqlite3 *pDest, String zDestName, sqlite3 *pSource, String zSourceName))
]

{ #category : #'private - api' }
SQLite3Library >> apiBindBlob: aStatement atColumn: aColumn with: aByteArray with: anInteger with: aPointer [
	"int sqlite3_bind_blob(sqlite3_stmt*, int, const void *, int, void(*)(void*))"

	^ self ffiCall: #(int sqlite3_bind_blob (sqlite3_stmt* aStatement, int aColumn, void* aByteArray, int anInteger, int aPointer)) "SQLITE_TRANSIENT"

]

{ #category : #'private - api' }
SQLite3Library >> apiBindDouble: aStatement atColumn: aColumn with: aFloat [
	"int sqlite3_bind_double(sqlite3_stmt*, int, double)"
	
	^ self ffiCall: #(int sqlite3_bind_double (sqlite3_stmt* aStatement, int aColumn, double aFloat))
		

]

{ #category : #'private - api' }
SQLite3Library >> apiBindInteger: aStatement atColumn: aColumn with: anInteger [
	"int sqlite3_bind_int64(sqlite3_stmt*, int, sqlite_int64)"

	^ self
		ffiCall: #(int sqlite3_bind_int64 (sqlite3_stmt* aStatement,int aColumn,sqlite3_int64 anInteger))
		
]

{ #category : #'private - api' }
SQLite3Library >> apiBindNull: aStatement atColumn: aColumn [
	"int sqlite3_bind_null(sqlite3_stmt*, int)"

	^ self ffiCall: #(int sqlite3_bind_null (sqlite3_stmt* aStatement, int aColumn))
		

]

{ #category : #'private - api' }
SQLite3Library >> apiBindParameterCount: aStatement [
	"int sqlite3_bind_parameter_count(sqlite3_stmt*)"

	^ self ffiCall: #(int sqlite3_bind_parameter_count (sqlite3_stmt* aStatement))
		
]

{ #category : #'private - api' }
SQLite3Library >> apiBindParameterIndex: aStatement for: aName [
	"int sqlite3_bind_parameter_index(sqlite3_stmt*, const char* zName)"

	^ self ffiCall: #(int sqlite3_bind_parameter_index (sqlite3_stmt* aStatement, String aName))
		

]

{ #category : #'private - api' }
SQLite3Library >> apiBindString: aStatement atColumn: aColumn with: aString with: anInteger with: anotherInteger [
	"int sqlite3_bind_text(sqlite3_stmt*, int, const char*, int, void(*)(void*))"
	 
	^ self ffiCall: #(int sqlite3_bind_text (sqlite3_stmt* aStatement, int aColumn, String aString, int anInteger, int anotherInteger))
		
]

{ #category : #'private - api' }
SQLite3Library >> apiChanges: handle [
	"int sqlite3_changes(sqlite3*)"

	^ self ffiCall: #(int sqlite3_changes (sqlite3 *handle))


]

{ #category : #'private - api' }
SQLite3Library >> apiClearBindings: aStatement [
	"int sqlite3_clear_bindings(sqlite3_stmt*)"

	^ self ffiCall: #(int sqlite3_clear_bindings (sqlite3_stmt* aStatement))
	

]

{ #category : #'private - api' }
SQLite3Library >> apiClose: handle [
	"int sqlite3_close(sqlite3*)"
	 
	^self ffiCall: #(int sqlite3_close(sqlite3 *handle)) 
	 
]

{ #category : #'private - api' }
SQLite3Library >> apiColumnBlob: aStatement atColumn: aColumn [
	"const void *sqlite3_column_blob(sqlite3_stmt*, int)"
	
	^ self ffiCall: #(const void *sqlite3_column_blob (sqlite3_stmt* aStatement, int aColumn))
		

]

{ #category : #'private - api' }
SQLite3Library >> apiColumnBytes: aStatement atColumn: aColumn [
	"int sqlite3_column_bytes(sqlite3_stmt*, int)"

	^ self ffiCall: #(int sqlite3_column_bytes (sqlite3_stmt* aStatement, int aColumn))
		

]

{ #category : #'private - api' }
SQLite3Library >> apiColumnCount: aStatement [
	"int sqlite3_column_count(sqlite3_stmt *pStmt)"
	 
	^ self ffiCall: #(int sqlite3_column_count(sqlite3_stmt *aStatement))

]

{ #category : #'private - api' }
SQLite3Library >> apiColumnDeclaredType: aStatement atColumn: aColumn [
	"const char *sqlite3_column_decltype(sqlite3_stmt*, int)"

	^ self
		ffiCall: #(String sqlite3_column_decltype #(sqlite3_stmt *aStatement, int aColumn))
		
]

{ #category : #'private - api' }
SQLite3Library >> apiColumnDouble: aStatement atColumn: aColumn [
	"double sqlite3_column_double(sqlite3_stmt*, int)"

	^ self ffiCall: #(double sqlite3_column_double (sqlite3_stmt* aStatement, int aColumn))
	

]

{ #category : #'private - api' }
SQLite3Library >> apiColumnInt: aStatement atColumn: aColumn [
	"int sqlite3_column_int(sqlite3_stmt*, int)"
	 
	^ self ffiCall: #(sqlite3_int64 sqlite3_column_int64 (sqlite3_stmt* aStatement, int aColumn))

]

{ #category : #'private - api' }
SQLite3Library >> apiColumnName: aStatement atColumn: aColumn [
	"const char *sqlite3_column_name(sqlite3_stmt*, int)"

	^ self
		ffiCall: #(String sqlite3_column_name(sqlite3_stmt* aStatement, int aColumn))
		
]

{ #category : #'private - api' }
SQLite3Library >> apiColumnText: aStatement atColumn: aColumn [
	"const unsigned char *sqlite3_column_text(sqlite3_stmt*, int)"
	 
	^ self ffiCall: #(String sqlite3_column_text (sqlite3_stmt* aStatement, int aColumn))
		

]

{ #category : #'private - api' }
SQLite3Library >> apiColumnType: aStatement atColumn: aColumn [
	"int sqlite3_column_type(sqlite3_stmt*, int)"

	^ self
		ffiCall: #(int sqlite3_column_type(sqlite3_stmt* aStatement,int aColumn))
		
]

{ #category : #'private - api' }
SQLite3Library >> apiConfigLoadExtension: dbHandle with: op with: onoff with: retpointer [
	"This is a specific invocation of sqlite3_db_config(sqlite3*, int, ...)."

	^self ffiCall: #(int sqlite3_db_config (sqlite3 *dbHandle, int op, int onoff, int *retpointer))
	

"Notes from https://www.sqlite.org/c3ref/c_dbconfig_enable_fkey.html:
op == SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION
This option is used to enable or disable the sqlite3_load_extension() interface independently of the load_extension() SQL function. The sqlite3_enable_load_extension() API enables or disables both the C-API sqlite3_load_extension() and the SQL function load_extension(). There should be two additional arguments. When the first argument to this interface is 1, then only the C-API is enabled and the SQL function remains disabled. If the first argument to this interface is 0, then both the C-API and the SQL function are disabled. If the first argument is -1, then no changes are made to state of either the C-API or the SQL function. The second parameter is a pointer to an integer into which is written 0 or 1 to indicate whether sqlite3_load_extension() interface is disabled or enabled following this call. The second parameter may be a NULL pointer, in which case the new setting is not reported back. 
"	
]

{ #category : #'private - api' }
SQLite3Library >> apiDBHandle: statementHandle [
	"sqlite3 *sqlite3_db_handle(sqlite3_stmt*);"
	 
	^self ffiCall: #(SQLite3DatabaseExternalObject *sqlite3_db_handle(SQLite3StatementExternalObject *statementHandle))

]

{ #category : #'private - api' }
SQLite3Library >> apiDataCount: handle [
	"int sqlite3_data_count(sqlite3_stmt*)"
	
	^ self ffiCall: #(int sqlite3_data_count (sqlite3_stmt *handle)) 

]

{ #category : #'private - api' }
SQLite3Library >> apiErrorMessage: handle [ 
	"const char *sqlite3_errmsg(sqlite3*)"
	 
	^self ffiCall: #(String sqlite3_errmsg(sqlite3 *handle)) 
	 
]

{ #category : #'private - api' }
SQLite3Library >> apiExec: dbHandle withSQLText: anSQLText with: callback with: callbackData with: errorMessageBuffer [
	"int sqlite3_exec(sqlite3*, const char*, int (*callback), void*, char **)"

	^self ffiCall: #(int sqlite3_exec (sqlite3 *dbHandle, String anSQLText, void *callback, void *callbackData, char **errorMessageBuffer))
		
	
]

{ #category : #'private - api' }
SQLite3Library >> apiFinalize: handle [
	"int sqlite3_finalize(sqlite3_stmt*)"
	 
	^self ffiCall: #(int sqlite3_finalize(sqlite3_stmt *handle)) 
	 
]

{ #category : #'private - api' }
SQLite3Library >> apiGetAutocommit: handle [
	"int sqlite3_get_autocommit(sqlite3*);"
	
	^ self ffiCall: #(int sqlite3_get_autocommit (sqlite3 *handle))
	 
]

{ #category : #'private - api' }
SQLite3Library >> apiLastInsertRowid: handle [
	"sqlite3_int64 sqlite3_last_insert_rowid(sqlite3*)"

	^ self ffiCall: #(long sqlite3_last_insert_rowid(SQLite3DatabaseExternalObject *handle))
]

{ #category : #'private - api' }
SQLite3Library >> apiLibVersion [
	"const char *sqlite3_libversion(void)"
	 
	^self ffiCall: #(String sqlite3_libversion(void)) 
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
	 
	^self ffiCall: #(int sqlite3_open(String filename, sqlite3 **handle)) 
	 
]

{ #category : #'private - api' }
SQLite3Library >> apiOpen: filename withFlags: flags vfs: vfs via: handle [
	"int sqlite3_open_v2(
  const char *filename,   /* Database filename (UTF-8) */
  sqlite3 **ppDb,         /* OUT: SQLite db handle */
  int flags,              /* Flags */
  const char *zVfs        /* Name of VFS module to use */
)"
	 
	^self ffiCall: #(int sqlite3_open_v2(String filename, sqlite3 **handle, int flags, String vfs)) 
	 
]

{ #category : #'private - api' }
SQLite3Library >> apiPrepare: dbHandle withSQLText: anSQLText with: textSize with: sHandle with: tail [
	"int sqlite3_prepare_v2(sqlite3*, const char*, int, sqlite3_stmt**, const char **)"

	^ self ffiCall: #(int sqlite3_prepare_v2 (sqlite3* dbHandle, String anSQLText, int textSize, sqlite3_stmt** sHandle, const char** tail))
		
	
]

{ #category : #'private - api' }
SQLite3Library >> apiReset: handle [
	"int sqlite3_reset(sqlite3_stmt*)"
	 
	^ self ffiCall: #(int sqlite3_reset (sqlite3_stmt *handle))
		

]

{ #category : #'private - api' }
SQLite3Library >> apiSleep [
	"int sqlite3_sleep(int)"
	 
	^ self ffiCall: #(int sqlite3_sleep(int))
]

{ #category : #'private - api' }
SQLite3Library >> apiSql: handle [
	"const char *sqlite3_sql(sqlite3_stmt*)"
	 
	^ self ffiCall: #(String sqlite3_sql (sqlite3_stmt* handle))
		

]

{ #category : #'private - api' }
SQLite3Library >> apiStatementReadOnly: handle [
	"int sqlite3_stmt_readonly(sqlite3_stmt *pStmt)"
	
	^ self ffiCall: #(int sqlite3_stmt_readonly (SQLite3StatementExternalObject * handle))
		

]

{ #category : #'private - api' }
SQLite3Library >> apiStep: handle [
	"int sqlite3_step(sqlite3_stmt*)"
	 
	^ self ffiCall: #(int sqlite3_step (sqlite3_stmt* handle))
		

]

{ #category : #'private - api' }
SQLite3Library >> apiThreadsafe [
	"int sqlite3_threadsafe(void)"
	 
	^self ffiCall: #(int sqlite3_threadsafe(void)) 
	 
]

{ #category : #'private - api' }
SQLite3Library >> apiTotalChanges: handle [
	"int sqlite3_total_changes(sqlite3*)"

	^ self ffiCall: #(int sqlite3_total_changes (sqlite3 *handle))
		

]

{ #category : #'private - api' }
SQLite3Library >> apiTrace: handle with: callback with: appdata [

	^ self ffiCall: #(void* sqlite3_trace (sqlite3* handle, FFICallback callback, ExternalAddress appdata)) 

]

{ #category : #operating }
SQLite3Library >> backup: backupHandle step: nPages [
	^self apiBackupStep: nPages via: backupHandle
]

{ #category : #operating }
SQLite3Library >> backupTo: dstConnection named: dstName from: srcConnection named: srcName [
	^self apiBackupTo: dstConnection named: dstName from: srcConnection named: srcName
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
SQLite3Library >> checkForOk: anInteger on: aHandle [
	^ self sqlite3ResultFor: anInteger ifNoneMatch: [ 
	 		
		 (SQLite3NativeError forNativeErrorCode: anInteger messageText: (self apiErrorMessage: aHandle)) signal ]
	
]

{ #category : #cleaning }
SQLite3Library >> clearBindings: sHandle on: dbHandle [
	
	^ self checkForOk: (self apiClearBindings: sHandle) on: dbHandle
	

]

{ #category : #'connection handling' }
SQLite3Library >> close: aHandle [	
	^ self apiClose: aHandle
]

{ #category : #'connection handling' }
SQLite3Library >> columnCount: aStatementHandle [	
	^ self apiColumnCount: aStatementHandle
]

{ #category : #accessing }
SQLite3Library >> dataValuesAvailable: aStatementHandle [
	^ self apiDataCount: aStatementHandle
	

]

{ #category : #'connection handling' }
SQLite3Library >> dbHandle: statementHandle [
	^self apiDBHandle: statementHandle
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

{ #category : #operating }
SQLite3Library >> finalize: aStatementHandle on: aDBHandle [
	^ self checkForOk: (self apiFinalize: aStatementHandle) on: aDBHandle
]

{ #category : #accessing }
SQLite3Library >> floatFrom: aStatement at: aColumn [

	^ self apiColumnDouble: aStatement atColumn: aColumn
]

{ #category : #accessing }
SQLite3Library >> getAutoCommit: aHandle [

	^ (self apiGetAutocommit: aHandle) ~= 0
]

{ #category : #operating }
SQLite3Library >> integerFrom: aStatement at: aColumn [
	^ self apiColumnInt: aStatement atColumn: aColumn
]

{ #category : #accessing }
SQLite3Library >> lastInsertRowId: dbHandle [

	^ self apiLastInsertRowid: dbHandle
]

{ #category : #'private - accessing' }
SQLite3Library >> library [ 
	^self libraryName
]

{ #category : #accessing }
SQLite3Library >> libraryVersion [
	"See http://sqlite.org/c3ref/libversion.html"
	^self apiLibVersion 
]

{ #category : #'private - api' }
SQLite3Library >> loadExtension: dbHandle with: aFilename [

	^ self checkForOk: (self apiLoadExtension: dbHandle 
										with: aFilename
										with: ExternalAddress new
										with: ExternalAddress new)
		on: dbHandle
]

{ #category : #'private - accessing' }
SQLite3Library >> macLibraryName [
	| pluginDir |
	pluginDir := FileSystem /'usr'/'lib'.
	#('libsqlite3.dylib' 'libsqlite3.0.dylib')
		detect: [ :each | (pluginDir / each) exists ] 
		ifFound: [ :libName | ^ (pluginDir / libName) fullName  ].

	self error: 'Module not found.'
]

{ #category : #'private - accessing' }
SQLite3Library >> macModuleName [
	"Remove later - this is just to satisfy old Pharo 6"
	^self macLibraryName 
]

{ #category : #accessing }
SQLite3Library >> nameFor: aStatement at: aColumn [
	^ self apiColumnName: aStatement atColumn: aColumn
]

{ #category : #'connection handling' }
SQLite3Library >> open: aFilename via: aHandle [	
	^ self checkForOk: (self apiOpen: aFilename via: aHandle) on: aHandle
]

{ #category : #accessing }
SQLite3Library >> open: aFilename withFlags: flags vfs: vfs via: aHandle [	
	^ self checkForOk: (self apiOpen: aFilename withFlags: flags vfs: vfs via: aHandle) on: aHandle
]

{ #category : #accessing }
SQLite3Library >> open: aFilename withFlags: flags via: aHandle [	
	^ self checkForOk: (self apiOpen: aFilename withFlags: flags vfs: nil via: aHandle) on: aHandle
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
SQLite3Library >> reset: aStatementHandle [
	
	^ aStatementHandle 
		ifNil: [ 0 ]
		ifNotNil: [ self apiReset: aStatementHandle ]
	

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

{ #category : #'private - utilities' }
SQLite3Library >> sqlite3ResultFor: anInteger ifNoneMatch: aBlock [

	^[ 
		SQLite3Result forNativeResultCode: anInteger
	] on: NotFound do: aBlock
]

{ #category : #stepping }
SQLite3Library >> statementReadOnly:handle [	
	"int sqlite3_stmt_readonly(sqlite3_stmt *pStmt)"
	
	^((self apiStatementReadOnly:handle) = 0) not
	

]

{ #category : #stepping }
SQLite3Library >> step: aStatementHandle [	
	^ self apiStep: aStatementHandle
	

]

{ #category : #operating }
SQLite3Library >> stringFrom: aStatement at: aColumn [
	^ self utf8StringToPharo: (self apiColumnText: aStatement atColumn: aColumn)
]

{ #category : #stepping }
SQLite3Library >> threadsafe [
	"http://sqlite.org/c3ref/threadsafe.html"
	^self apiThreadsafe 
	

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
			^DateTimeTypeMap at: declared asLowercase ifAbsent: [ selector ]]].
	^ selector

]

{ #category : #'private - accessing' }
SQLite3Library >> unix32LibraryName [ 
	(#('/usr/lib/i386-linux-gnu' '/usr/lib32' '/usr/lib'),
			((OSEnvironment current at: 'LD_LIBRARY_PATH' ifAbsent: [ '' ]) substrings: ':'))
		do: [ :path | 
			#('libsqlite3.so.0' 'libsqlite3.so') do: [ :libraryName |
			| libraryPath |
			libraryPath := path asFileReference / libraryName.
			libraryPath exists
				ifTrue: [ ^ libraryPath fullName ] ] ].
	self error: 'Module not found.'
]

{ #category : #'private - accessing' }
SQLite3Library >> unix32ModuleName [ 
	"Remove later - this is just to satisfy old Pharo 6"
	
	^self unix32LibraryName
]

{ #category : #'private - accessing' }
SQLite3Library >> unix64LibraryName [ 
	(#('/usr/lib/x86_64-linux-gnu' '/lib/x86_64-linux-gnu' '/usr/lib'),
			((OSEnvironment current at: 'LD_LIBRARY_PATH' ifAbsent: [ '' ]) substrings: ':'))
		do: [ :path | 
			#('libsqlite3.so.0' 'libsqlite3.so') do: [ :libraryName |
				| libraryPath |
				libraryPath := path asFileReference /  libraryName.
				libraryPath exists
					ifTrue: [ ^ libraryPath fullName ]]].
	self error: 'Module not found.'

]

{ #category : #'private - accessing' }
SQLite3Library >> unix64ModuleName [ 
	"Remove later - this is just to satisfy old Pharo 6"
	
	^self unix64LibraryName
]

{ #category : #'private - conversion' }
SQLite3Library >> utf8StringToPharo: anUTF8String [
	"Converts from SQLite UTF-8 to Pharo Multibyte Characters"
	
	^(ZnCharacterReadStream on: anUTF8String asByteArray readStream) upToEnd
]

{ #category : #'private - accessing' }
SQLite3Library >> win32LibraryName [
	^ 'sqlite3'
]

{ #category : #'private - accessing' }
SQLite3Library >> win32ModuleName [ 
	"Remove later - this is just to satisfy old Pharo 6"
	
	^self win32LibraryName
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
