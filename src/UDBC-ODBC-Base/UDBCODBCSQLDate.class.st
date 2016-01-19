"
SQL date datatype
"
Class {
	#name : #UDBCODBCSQLDate,
	#superclass : #FFIExternalStructure,
	#category : #'UDBC-ODBC-Base-UFFI-Types'
}

{ #category : #accessing }
UDBCODBCSQLDate class >> fieldsDesc [
	" 
	self rebuildFieldAccessors
	"
	^ #(short year;
		ushort month;
		ushort day;
		)
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLDate >> day [
	"This method was automatically generated"
	^handle unsignedShortAt: 5
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLDate >> day: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 5 put: anObject
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLDate >> month [
	"This method was automatically generated"
	^handle unsignedShortAt: 3
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLDate >> month: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 3 put: anObject
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLDate >> year [
	"This method was automatically generated"
	^handle signedShortAt: 1
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLDate >> year: anObject [
	"This method was automatically generated"
	handle signedShortAt: 1 put: anObject
]
