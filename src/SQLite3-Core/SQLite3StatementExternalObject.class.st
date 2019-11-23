"
I represent the SQLite API 'sqlite3_stmt' C-level type.

"
Class {
	#name : #SQLite3StatementExternalObject,
	#superclass : #FFIOpaqueObject,
	#category : #'SQLite3-Core-UFFI-Support'
}

{ #category : #'instance finalization' }
SQLite3StatementExternalObject class >> finalizeResourceData: aHandle [
	SQLite3Library current 
		ffiCall: #(int sqlite3_finalize (ExternalAddress aHandle))
]

{ #category : #finalization }
SQLite3StatementExternalObject >> finalizeResourceData: aHandle [
	SQLite3Library current apiFinalize: aHandle.
]
