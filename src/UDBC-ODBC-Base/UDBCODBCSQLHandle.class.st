"
An external handle 
"
Class {
	#name : #UDBCODBCSQLHandle,
	#superclass : #FFIExternalStructure,
	#category : #'UDBC-ODBC-Base-UFFI-Types'
}

{ #category : #accessing }
UDBCODBCSQLHandle class >> fieldsDesc [
	" 
	self rebuildFieldAccessors
	"
	^ #(long value)
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLHandle >> value [
	"This method was automatically generated"
	^handle signedLongAt: 1
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLHandle >> value: anObject [
	"This method was automatically generated"
	handle signedLongAt: 1 put: anObject
]
