"
I represent the SQLite API 'sqlite3_stmt' C-level type.

"
Class {
	#name : #UDBCSQLite3StatementExternalObject,
	#superclass : #FFIOpaqueObject,
	#category : #'UDBC-SQLite-Base-UFFI-Support'
}

{ #category : #finalization }
UDBCSQLite3StatementExternalObject >> finalizeResourceData: aHandle [
	UDBCSQLite3Library current apiFinalize: aHandle.
]
