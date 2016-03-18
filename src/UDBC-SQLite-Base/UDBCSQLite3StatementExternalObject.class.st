"
I represent the SQLite API 'sqlite3_stmt' C-level type.

"
Class {
	#name : #UDBCSQLite3StatementExternalObject,
	#superclass : #FFIOpaqueObject,
	#category : #'UDBC-SQLite-Base-UFFI-Support'
}

{ #category : #'instance finalization' }
UDBCSQLite3StatementExternalObject class >> finalizeResourceData: aHandle [
	UDBCSQLite3Library current 
		ffiCall: #(int sqlite3_finalize (ExternalAddress aHandle))
		module: UDBCSQLite3Library current library
]

{ #category : #finalization }
UDBCSQLite3StatementExternalObject >> finalizeResourceData: aHandle [
	UDBCSQLite3Library current apiFinalize: aHandle.
]
