"
I represent the SQLite API 'sqlite3_backup' C-level type.
"
Class {
	#name : 'SQLite3BackupExternalReference',
	#superclass : 'FFIOpaqueObject',
	#category : 'SQLite3-Core-UFFI-Support',
	#package : 'SQLite3-Core',
	#tag : 'UFFI-Support'
}

{ #category : 'initialization' }
SQLite3BackupExternalReference >> beNull [

	^ handle beNull
]
