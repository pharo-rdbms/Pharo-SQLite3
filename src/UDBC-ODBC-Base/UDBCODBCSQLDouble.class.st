"
SQL double datatype
"
Class {
	#name : #UDBCODBCSQLDouble,
	#superclass : #FFIExternalStructure,
	#category : #'UDBC-ODBC-Base-UFFI-Types'
}

{ #category : #accessing }
UDBCODBCSQLDouble class >> fieldsDesc [
	" 
	self rebuildFieldAccessors
	"
	^ #(double value)
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLDouble >> value [
	"This method was automatically generated"
	^handle doubleAt: 1
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLDouble >> value: anObject [
	"This method was automatically generated"
	handle doubleAt: 1 put: anObject
]
