"
I represent the SQLite API 'sqlite3_stmt' C-level type.

"
Class {
	#name : #SQLite3StatementExternalObject,
	#superclass : #FFIOpaqueObject,
	#category : #'SQLite3-Core-UFFI-Support'
}

{ #category : #'instance finalization' }
SQLite3StatementExternalObject class >> doFinalizeResourceData: aHandle [

	SQLite3Library current ffiCall:
		#( int sqlite3_finalize #( void * aHandle ) )
]

{ #category : #finalization }
SQLite3StatementExternalObject class >> finalizeResourceData: aHandle [

	self doFinalizeResourceData: aHandle.
	aHandle beNull
]

{ #category : #initialization }
SQLite3StatementExternalObject >> beNull [

	^ handle beNull
]
