"
SQL timestamp datatype
"
Class {
	#name : #UDBCODBCSQLTime,
	#superclass : #FFIExternalStructure,
	#category : #'UDBC-ODBC-Base-UFFI-Types'
}

{ #category : #accessing }
UDBCODBCSQLTime class >> fieldsDesc [
	" 
	self rebuildFieldAccessors
	"
	^ #(ushort hour;
	ushort minute;
	ushort second;
	)
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTime >> hour [
	"This method was automatically generated"
	^handle unsignedShortAt: 1
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTime >> hour: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 1 put: anObject
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTime >> minute [
	"This method was automatically generated"
	^handle unsignedShortAt: 3
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTime >> minute: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 3 put: anObject
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTime >> second [
	"This method was automatically generated"
	^handle unsignedShortAt: 5
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTime >> second: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 5 put: anObject
]
