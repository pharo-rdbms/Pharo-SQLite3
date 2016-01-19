"
SQL short datatype
"
Class {
	#name : #UDBCODBCSQLShort,
	#superclass : #FFIExternalStructure,
	#category : #'UDBC-ODBC-Base-UFFI-Types'
}

{ #category : #accessing }
UDBCODBCSQLShort class >> fieldsDesc [
	" 
	self rebuildFieldAccessors
	"
	^ #(short value)
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLShort >> value [
	"This method was automatically generated"
	^handle signedShortAt: 1
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLShort >> value: anObject [
	"This method was automatically generated"
	handle signedShortAt: 1 put: anObject
]
