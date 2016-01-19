"
SQL integer datatype
"
Class {
	#name : #UDBCODBCSQLInteger,
	#superclass : #FFIExternalStructure,
	#category : #'UDBC-ODBC-Base-UFFI-Types'
}

{ #category : #accessing }
UDBCODBCSQLInteger class >> fieldsDesc [
	" 
	self rebuildFieldAccessors
	"
	^ #(long value)
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLInteger >> value [
	"This method was automatically generated"
	^handle signedLongAt: 1
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLInteger >> value: anObject [
	"This method was automatically generated"
	handle signedLongAt: 1 put: anObject
]
