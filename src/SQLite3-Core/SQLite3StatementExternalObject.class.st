"
I represent the SQLite API 'sqlite3_stmt' C-level type.

"
Class {
	#name : 'SQLite3StatementExternalObject',
	#superclass : 'FFIOpaqueObject',
	#category : 'SQLite3-Core-UFFI-Support',
	#package : 'SQLite3-Core',
	#tag : 'UFFI-Support'
}

{ #category : 'instance finalization' }
SQLite3StatementExternalObject class >> doFinalizeResourceData: aHandle [

	SQLite3Library current ffiCall:
		#( int sqlite3_finalize #( void * aHandle ) )
]

{ #category : 'finalization' }
SQLite3StatementExternalObject class >> finalizeResourceData: aHandle [

	aHandle isNull ifFalse: 
		[| copy |
		copy := aHandle copy.
		aHandle beNull.
		self doFinalizeResourceData: copy]
]

{ #category : 'initialization' }
SQLite3StatementExternalObject >> beNull [

	^ handle beNull
]
