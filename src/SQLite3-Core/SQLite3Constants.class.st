"
I provide SQLIte's constants.
"
Class {
	#name : #SQLite3Constants,
	#superclass : #SharedPool,
	#classVars : [
		'SQLITE3_TEXT',
		'SQLITE_ABORT',
		'SQLITE_ABORT_ROLLBACK',
		'SQLITE_AUTH',
		'SQLITE_AUTH_USER',
		'SQLITE_BLOB',
		'SQLITE_BUSY',
		'SQLITE_BUSY_RECOVERY',
		'SQLITE_BUSY_SNAPSHOT',
		'SQLITE_CANTOPEN',
		'SQLITE_CANTOPEN_CONVPATH',
		'SQLITE_CANTOPEN_DIRTYWAL',
		'SQLITE_CANTOPEN_FULLPATH',
		'SQLITE_CANTOPEN_ISDIR',
		'SQLITE_CANTOPEN_NOTEMPDIR',
		'SQLITE_CHECKPOINT_FULL',
		'SQLITE_CHECKPOINT_PASSIVE',
		'SQLITE_CHECKPOINT_RESTART',
		'SQLITE_CHECKPOINT_TRUNCATE',
		'SQLITE_CONSTRAINT',
		'SQLITE_CONSTRAINT_CHECK',
		'SQLITE_CONSTRAINT_COMMITHOOK',
		'SQLITE_CONSTRAINT_FOREIGNKEY',
		'SQLITE_CONSTRAINT_FUNCTION',
		'SQLITE_CONSTRAINT_NOTNULL',
		'SQLITE_CONSTRAINT_PRIMARYKEY',
		'SQLITE_CONSTRAINT_ROWID',
		'SQLITE_CONSTRAINT_TRIGGER',
		'SQLITE_CONSTRAINT_UNIQUE',
		'SQLITE_CONSTRAINT_VTAB',
		'SQLITE_CORRUPT',
		'SQLITE_CORRUPT_SEQUENCE',
		'SQLITE_CORRUPT_VTAB',
		'SQLITE_DONE',
		'SQLITE_EMPTY',
		'SQLITE_ERROR',
		'SQLITE_ERROR_MISSING_COLLSEQ',
		'SQLITE_ERROR_RETRY',
		'SQLITE_ERROR_SNAPSHOT',
		'SQLITE_FLOAT',
		'SQLITE_FORMAT',
		'SQLITE_FULL',
		'SQLITE_INTEGER',
		'SQLITE_INTERNAL',
		'SQLITE_INTERRUPT',
		'SQLITE_IOERR',
		'SQLITE_IOERR_ACCESS',
		'SQLITE_IOERR_AUTH',
		'SQLITE_IOERR_BEGIN_ATOMIC',
		'SQLITE_IOERR_BLOCKED',
		'SQLITE_IOERR_CHECKRESERVEDLOCK',
		'SQLITE_IOERR_CLOSE',
		'SQLITE_IOERR_COMMIT_ATOMIC',
		'SQLITE_IOERR_CONVPATH',
		'SQLITE_IOERR_DELETE',
		'SQLITE_IOERR_DELETE_NOENT',
		'SQLITE_IOERR_DIR_CLOSE',
		'SQLITE_IOERR_DIR_FSYNC',
		'SQLITE_IOERR_FSTAT',
		'SQLITE_IOERR_FSYNC',
		'SQLITE_IOERR_GETTEMPPATH',
		'SQLITE_IOERR_LOCK',
		'SQLITE_IOERR_MMAP',
		'SQLITE_IOERR_NOMEM',
		'SQLITE_IOERR_RDLOCK',
		'SQLITE_IOERR_READ',
		'SQLITE_IOERR_ROLLBACK_ATOMIC',
		'SQLITE_IOERR_SEEK',
		'SQLITE_IOERR_SHMLOCK',
		'SQLITE_IOERR_SHMMAP',
		'SQLITE_IOERR_SHMOPEN',
		'SQLITE_IOERR_SHMSIZE',
		'SQLITE_IOERR_SHORT_READ',
		'SQLITE_IOERR_TRUNCATE',
		'SQLITE_IOERR_UNLOCK',
		'SQLITE_IOERR_VNODE',
		'SQLITE_IOERR_WRITE',
		'SQLITE_LOCKED',
		'SQLITE_LOCKED_SHAREDCACHE',
		'SQLITE_LOCKED_VTAB',
		'SQLITE_MISMATCH',
		'SQLITE_MISUSE',
		'SQLITE_NOLFS',
		'SQLITE_NOMEM',
		'SQLITE_NOTADB',
		'SQLITE_NOTFOUND',
		'SQLITE_NOTICE',
		'SQLITE_NOTICE_RECOVER_ROLLBACK',
		'SQLITE_NOTICE_RECOVER_WAL',
		'SQLITE_NULL',
		'SQLITE_OK',
		'SQLITE_OK_LOAD_PERMANENTLY',
		'SQLITE_OPEN_AUTOPROXY',
		'SQLITE_OPEN_CREATE',
		'SQLITE_OPEN_DELETEONCLOSE',
		'SQLITE_OPEN_EXCLUSIVE',
		'SQLITE_OPEN_FULLMUTEX',
		'SQLITE_OPEN_MAIN_DB',
		'SQLITE_OPEN_MAIN_JOURNAL',
		'SQLITE_OPEN_MASTER_JOURNAL',
		'SQLITE_OPEN_MEMORY',
		'SQLITE_OPEN_NOMUTEX',
		'SQLITE_OPEN_PRIVATECACHE',
		'SQLITE_OPEN_READONLY',
		'SQLITE_OPEN_READWRITE',
		'SQLITE_OPEN_SHAREDCACHE',
		'SQLITE_OPEN_SUBJOURNAL',
		'SQLITE_OPEN_TEMP_DB',
		'SQLITE_OPEN_TEMP_JOURNAL',
		'SQLITE_OPEN_TRANSIENT_DB',
		'SQLITE_OPEN_URI',
		'SQLITE_OPEN_WAL',
		'SQLITE_PERM',
		'SQLITE_PROTOCOL',
		'SQLITE_RANGE',
		'SQLITE_READONLY',
		'SQLITE_READONLY_CANTINIT',
		'SQLITE_READONLY_CANTLOCK',
		'SQLITE_READONLY_DBMOVED',
		'SQLITE_READONLY_DIRECTORY',
		'SQLITE_READONLY_RECOVERY',
		'SQLITE_READONLY_ROLLBACK',
		'SQLITE_ROW',
		'SQLITE_SCHEMA',
		'SQLITE_TEXT',
		'SQLITE_TOOBIG',
		'SQLITE_WARNING',
		'SQLITE_WARNING_AUTOINDEX'
	],
	#category : #'SQLite3-Core-UFFI-Support'
}

{ #category : #'private - initialization' }
SQLite3Constants class >> initCheckpointModes [

    SQLITE_CHECKPOINT_PASSIVE := 0.
    SQLITE_CHECKPOINT_FULL := 1.
    SQLITE_CHECKPOINT_RESTART := 2.
    SQLITE_CHECKPOINT_TRUNCATE := 3.
			
	
]

{ #category : #'private - initialization' }
SQLite3Constants class >> initConstants [
	
	self 
		initResultCodes;			
		initErrorCodes;
		initExtendedErrorCodes;
		initFileOpenFlags
	
	

]

{ #category : #'private - initialization' }
SQLite3Constants class >> initDataTypes [
	"Fundamental Datatypes"
	
	SQLITE_INTEGER := 1.
	SQLITE_FLOAT := 2.
	SQLITE_TEXT := 3.
	SQLITE3_TEXT := 3.
	SQLITE_BLOB := 4.	
	SQLITE_NULL := 5
			
	
]

{ #category : #'private - initialization constants' }
SQLite3Constants class >> initErrorCodes [
	"In its default configuration, SQLite API routines return one of 26 integer 
	[SQLITE_OK | result codes]."

	SQLITE_ERROR := 1. 			"SQL error or missing database"
	SQLITE_INTERNAL := 2.			"Internal logic error in SQLite"
	SQLITE_PERM := 3.				"Access permission denied"	
	SQLITE_ABORT := 4.				"Callback routine requested an abort"											
	SQLITE_BUSY := 5.  			"The database file is locked" 
	SQLITE_LOCKED := 6. 			"A table in the database is locked"
	SQLITE_NOMEM := 7.				"A malloc() failed"
	SQLITE_READONLY := 8.			"Attempt to write a readonly database"
	SQLITE_INTERRUPT := 9.		"Operation terminated by sqlite3_interrupt()"
	SQLITE_IOERR := 10.			"Some kind of disk I/O error occurred"
	SQLITE_CORRUPT := 11.			"The database disk image is malformed"
	SQLITE_NOTFOUND := 12.		"Unknown opcode in sqlite3_file_control()"							
	SQLITE_FULL := 13.				"Insertion failed because database is full"	
	SQLITE_CANTOPEN := 14.   	"Unable to open the database file"
	SQLITE_PROTOCOL := 15.		"Database lock protocol error"
	SQLITE_EMPTY := 16.			"Database is empty"
	SQLITE_SCHEMA := 17.			"The database schema changed"
	SQLITE_TOOBIG := 18.			"String or BLOB exceeds size limit"			
	SQLITE_CONSTRAINT := 19.		"Abort due to constraint violation"
	SQLITE_MISMATCH := 20.		"Data type mismatch"		
	SQLITE_MISUSE := 21. 			"Library used incorrectly"
	SQLITE_NOLFS := 22.			"Uses OS features not supported on host"	
	SQLITE_AUTH := 23.				"Authorization denied"			
	SQLITE_FORMAT := 24.			"Auxiliary database format error"	
	SQLITE_RANGE := 25.			"2nd parameter to sqlite3_bind out of range"
	SQLITE_NOTADB := 26.			"File opened that is not a database file"
	SQLITE_NOTICE := 27.			"Notifications from sqlite3_log()"
	SQLITE_WARNING := 28.			"Warnings from sqlite3_log()"
]

{ #category : #'private - initialization constants' }
SQLite3Constants class >> initExtendedErrorCodes [
	"Newer versions of SQLite (version 3.3.8 and later) include support for additional result codes that provide more detailed information about errors. The extended result codes are enabled or disabled on a per database connection basis using the [sqlite3_extended_result_codes()] API."

    SQLITE_ERROR_MISSING_COLLSEQ    := (SQLITE_ERROR | (1<<8)).
    SQLITE_ERROR_RETRY              := (SQLITE_ERROR | (2<<8)).
    SQLITE_ERROR_SNAPSHOT           := (SQLITE_ERROR | (3<<8)).
    SQLITE_IOERR_READ               := (SQLITE_IOERR | (1<<8)).
    SQLITE_IOERR_SHORT_READ         := (SQLITE_IOERR | (2<<8)).
    SQLITE_IOERR_WRITE              := (SQLITE_IOERR | (3<<8)).
    SQLITE_IOERR_FSYNC              := (SQLITE_IOERR | (4<<8)).
    SQLITE_IOERR_DIR_FSYNC          := (SQLITE_IOERR | (5<<8)).
    SQLITE_IOERR_TRUNCATE           := (SQLITE_IOERR | (6<<8)).
    SQLITE_IOERR_FSTAT              := (SQLITE_IOERR | (7<<8)).
    SQLITE_IOERR_UNLOCK             := (SQLITE_IOERR | (8<<8)).
    SQLITE_IOERR_RDLOCK             := (SQLITE_IOERR | (9<<8)).
    SQLITE_IOERR_DELETE             := (SQLITE_IOERR | (10<<8)).
    SQLITE_IOERR_BLOCKED            := (SQLITE_IOERR | (11<<8)).
    SQLITE_IOERR_NOMEM              := (SQLITE_IOERR | (12<<8)).
    SQLITE_IOERR_ACCESS             := (SQLITE_IOERR | (13<<8)).
    SQLITE_IOERR_CHECKRESERVEDLOCK  := (SQLITE_IOERR | (14<<8)).
    SQLITE_IOERR_LOCK               := (SQLITE_IOERR | (15<<8)).
    SQLITE_IOERR_CLOSE              := (SQLITE_IOERR | (16<<8)).
    SQLITE_IOERR_DIR_CLOSE          := (SQLITE_IOERR | (17<<8)).
    SQLITE_IOERR_SHMOPEN            := (SQLITE_IOERR | (18<<8)).
    SQLITE_IOERR_SHMSIZE            := (SQLITE_IOERR | (19<<8)).
    SQLITE_IOERR_SHMLOCK            := (SQLITE_IOERR | (20<<8)).
    SQLITE_IOERR_SHMMAP             := (SQLITE_IOERR | (21<<8)).
    SQLITE_IOERR_SEEK               := (SQLITE_IOERR | (22<<8)).
    SQLITE_IOERR_DELETE_NOENT       := (SQLITE_IOERR | (23<<8)).
    SQLITE_IOERR_MMAP               := (SQLITE_IOERR | (24<<8)).
    SQLITE_IOERR_GETTEMPPATH        := (SQLITE_IOERR | (25<<8)).
    SQLITE_IOERR_CONVPATH           := (SQLITE_IOERR | (26<<8)).
    SQLITE_IOERR_VNODE              := (SQLITE_IOERR | (27<<8)).
    SQLITE_IOERR_AUTH               := (SQLITE_IOERR | (28<<8)).
    SQLITE_IOERR_BEGIN_ATOMIC       := (SQLITE_IOERR | (29<<8)).
    SQLITE_IOERR_COMMIT_ATOMIC      := (SQLITE_IOERR | (30<<8)).
    SQLITE_IOERR_ROLLBACK_ATOMIC    := (SQLITE_IOERR | (31<<8)).
    SQLITE_LOCKED_SHAREDCACHE       := (SQLITE_LOCKED |  (1<<8)).
    SQLITE_LOCKED_VTAB              := (SQLITE_LOCKED |  (2<<8)).
    SQLITE_BUSY_RECOVERY            := (SQLITE_BUSY   |  (1<<8)).
    SQLITE_BUSY_SNAPSHOT            := (SQLITE_BUSY   |  (2<<8)).
    SQLITE_CANTOPEN_NOTEMPDIR       := (SQLITE_CANTOPEN | (1<<8)).
    SQLITE_CANTOPEN_ISDIR           := (SQLITE_CANTOPEN | (2<<8)).
    SQLITE_CANTOPEN_FULLPATH        := (SQLITE_CANTOPEN | (3<<8)).
    SQLITE_CANTOPEN_CONVPATH        := (SQLITE_CANTOPEN | (4<<8)).
    SQLITE_CANTOPEN_DIRTYWAL        := (SQLITE_CANTOPEN | (5<<8)). "Not Used"
    SQLITE_CORRUPT_VTAB             := (SQLITE_CORRUPT | (1<<8)).
    SQLITE_CORRUPT_SEQUENCE         := (SQLITE_CORRUPT | (2<<8)).
    SQLITE_READONLY_RECOVERY        := (SQLITE_READONLY | (1<<8)).
    SQLITE_READONLY_CANTLOCK        := (SQLITE_READONLY | (2<<8)).
    SQLITE_READONLY_ROLLBACK        := (SQLITE_READONLY | (3<<8)).
    SQLITE_READONLY_DBMOVED         := (SQLITE_READONLY | (4<<8)).
    SQLITE_READONLY_CANTINIT        := (SQLITE_READONLY | (5<<8)).
    SQLITE_READONLY_DIRECTORY       := (SQLITE_READONLY | (6<<8)).
    SQLITE_ABORT_ROLLBACK           := (SQLITE_ABORT | (2<<8)).
    SQLITE_CONSTRAINT_CHECK         := (SQLITE_CONSTRAINT | (1<<8)).
    SQLITE_CONSTRAINT_COMMITHOOK    := (SQLITE_CONSTRAINT | (2<<8)).
    SQLITE_CONSTRAINT_FOREIGNKEY    := (SQLITE_CONSTRAINT | (3<<8)).
    SQLITE_CONSTRAINT_FUNCTION      := (SQLITE_CONSTRAINT | (4<<8)).
    SQLITE_CONSTRAINT_NOTNULL       := (SQLITE_CONSTRAINT | (5<<8)).
    SQLITE_CONSTRAINT_PRIMARYKEY    := (SQLITE_CONSTRAINT | (6<<8)).
    SQLITE_CONSTRAINT_TRIGGER       := (SQLITE_CONSTRAINT | (7<<8)).
    SQLITE_CONSTRAINT_UNIQUE        := (SQLITE_CONSTRAINT | (8<<8)).
    SQLITE_CONSTRAINT_VTAB          := (SQLITE_CONSTRAINT | (9<<8)).
    SQLITE_CONSTRAINT_ROWID         := (SQLITE_CONSTRAINT |(10<<8)).
    SQLITE_NOTICE_RECOVER_WAL       := (SQLITE_NOTICE | (1<<8)).
    SQLITE_NOTICE_RECOVER_ROLLBACK  := (SQLITE_NOTICE | (2<<8)).
    SQLITE_WARNING_AUTOINDEX        := (SQLITE_WARNING | (1<<8)).
    SQLITE_AUTH_USER                := (SQLITE_AUTH | (1<<8)).
    SQLITE_OK_LOAD_PERMANENTLY      := (SQLITE_OK | (1<<8)).
]

{ #category : #'private - initialization constants' }
SQLite3Constants class >> initFileOpenFlags [

	SQLITE_OPEN_READONLY      	  := Integer readFrom: '00000001' base: 16.  " Ok for sqlite3_open_v2() "
	SQLITE_OPEN_READWRITE         := Integer readFrom: '00000002' base: 16.  " Ok for sqlite3_open_v2() "
	SQLITE_OPEN_CREATE            := Integer readFrom: '00000004' base: 16.  " Ok for sqlite3_open_v2() "
	SQLITE_OPEN_DELETEONCLOSE     := Integer readFrom: '00000008' base: 16.  " VFS only "
	SQLITE_OPEN_EXCLUSIVE         := Integer readFrom: '00000010' base: 16.  " VFS only "
	SQLITE_OPEN_AUTOPROXY         := Integer readFrom: '00000020' base: 16.  " VFS only "
	SQLITE_OPEN_URI               := Integer readFrom: '00000040' base: 16.  " Ok for sqlite3_open_v2() "
	SQLITE_OPEN_MEMORY            := Integer readFrom: '00000080' base: 16.  " Ok for sqlite3_open_v2() "
	SQLITE_OPEN_MAIN_DB           := Integer readFrom: '00000100' base: 16.  " VFS only "
	SQLITE_OPEN_TEMP_DB           := Integer readFrom: '00000200' base: 16.  " VFS only "
	SQLITE_OPEN_TRANSIENT_DB      := Integer readFrom: '00000400' base: 16.  " VFS only "
	SQLITE_OPEN_MAIN_JOURNAL      := Integer readFrom: '00000800' base: 16.  " VFS only "
	SQLITE_OPEN_TEMP_JOURNAL      := Integer readFrom: '00001000' base: 16.  " VFS only "
	SQLITE_OPEN_SUBJOURNAL        := Integer readFrom: '00002000' base: 16.  " VFS only "
	SQLITE_OPEN_MASTER_JOURNAL    := Integer readFrom: '00004000' base: 16.  " VFS only "
	SQLITE_OPEN_NOMUTEX           := Integer readFrom: '00008000' base: 16.  " Ok for sqlite3_open_v2() "
	SQLITE_OPEN_FULLMUTEX         := Integer readFrom: '00010000' base: 16.  " Ok for sqlite3_open_v2() "
	SQLITE_OPEN_SHAREDCACHE       := Integer readFrom: '00020000' base: 16.  " Ok for sqlite3_open_v2() "
	SQLITE_OPEN_PRIVATECACHE      := Integer readFrom: '00040000' base: 16.  " Ok for sqlite3_open_v2() "
	SQLITE_OPEN_WAL               := Integer readFrom: '00080000' base: 16.  " VFS only "
]

{ #category : #'private - initialization constants' }
SQLite3Constants class >> initResultCodes [

	SQLITE_OK := 0.		 			"Successful result"
	SQLITE_ROW := 100.				"sqlite3_step() has another row ready"
	SQLITE_DONE := 101 			"sqlite3_step() has finished executing"
]

{ #category : #initialization }
SQLite3Constants class >> initialize [
	self 
		initConstants;
		initDataTypes;
		initCheckpointModes 
			
	
]
