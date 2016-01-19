"
SQL small integer datatype
"
Class {
	#name : #UDBCODBCSQLSmallInteger,
	#superclass : #FFIExternalStructure,
	#category : #'UDBC-ODBC-Base-UFFI-Types'
}

{ #category : #accessing }
UDBCODBCSQLSmallInteger class >> fieldsDesc [
	" 
	self rebuildFieldAccessors
	"
	^ #(short value)
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLSmallInteger >> value [
	"This method was automatically generated"
	^handle signedShortAt: 1
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLSmallInteger >> value: anObject [
	"This method was automatically generated"
	handle signedShortAt: 1 put: anObject
]
