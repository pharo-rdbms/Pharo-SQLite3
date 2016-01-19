"
SQL float datatype
"
Class {
	#name : #UDBCODBCSQLFloat,
	#superclass : #FFIExternalStructure,
	#category : #'UDBC-ODBC-Base-UFFI-Types'
}

{ #category : #accessing }
UDBCODBCSQLFloat class >> fieldsDesc [
	" 
	self rebuildFieldAccessors
	"
	^ #(float value)
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLFloat >> value [
	"This method was automatically generated"
	^handle floatAt: 1
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLFloat >> value: anObject [
	"This method was automatically generated"
	handle floatAt: 1 put: anObject
]
