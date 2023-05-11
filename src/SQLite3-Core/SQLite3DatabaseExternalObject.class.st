"
I represent the SQLite API 'sqlite3' C-level type.
"
Class {
	#name : #SQLite3DatabaseExternalObject,
	#superclass : #FFIOpaqueObject,
	#category : #'SQLite3-Core-UFFI-Support'
}

{ #category : #'instance finalization' }
SQLite3DatabaseExternalObject class >> doFinalizeResourceData: resourceData [

	SQLite3Library current ffiCall:
		#( int sqlite3_close_v2 #( void * resourceData ) )
]

{ #category : #finalization }
SQLite3DatabaseExternalObject class >> finalizeResourceData: aHandle [

	self doFinalizeResourceData: aHandle.
	aHandle beNull
]

{ #category : #initialization }
SQLite3DatabaseExternalObject >> beNull [

	^ handle beNull
]
