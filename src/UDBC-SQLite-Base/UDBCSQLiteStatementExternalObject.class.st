"
I represent the SQLite API 'sqlite3_stmt' C-level type.

"
Class {
	#name : #UDBCSQLiteStatementExternalObject,
	#superclass : #FFIExternalObject,
	#category : #'UDBC-SQLite-Base-UFFI-Support'
}

{ #category : #finalization }
UDBCSQLiteStatementExternalObject >> finalizeResourceData: aHandle [
	UDBCSQLiteLibrary current apiFinalize: aHandle.
]
