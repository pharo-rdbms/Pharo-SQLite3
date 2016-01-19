"
SQL byte datatype
"
Class {
	#name : #UDBCODBCSQLByte,
	#superclass : #FFIExternalStructure,
	#category : #'UDBC-ODBC-Base-UFFI-Types'
}

{ #category : #accessing }
UDBCODBCSQLByte class >> fieldsDesc [
	" 
	self rebuildFieldAccessors
	"
	^ #(byte value)
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLByte >> value [
	"This method was automatically generated"
	^handle unsignedByteAt: 1
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLByte >> value: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: 1 put: anObject
]
