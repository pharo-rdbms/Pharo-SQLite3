"
SQL unsigned integer datatype
"
Class {
	#name : #UDBCODBCSQLUInteger,
	#superclass : #FFIExternalStructure,
	#category : #'UDBC-ODBC-Base-UFFI-Types'
}

{ #category : #accessing }
UDBCODBCSQLUInteger class >> fieldsDesc [
	" 
	self rebuildFieldAccessors
	"
	^ #(ulong value)
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLUInteger >> value [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLUInteger >> value: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]
