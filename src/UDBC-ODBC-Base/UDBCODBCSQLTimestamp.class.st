"
SQL timestamp datatype
"
Class {
	#name : #UDBCODBCSQLTimestamp,
	#superclass : #FFIExternalStructure,
	#category : #'UDBC-ODBC-Base-UFFI-Types'
}

{ #category : #accessing }
UDBCODBCSQLTimestamp class >> fieldsDesc [
	" 
	self rebuildFieldAccessors
	"
	^ #(short year;
	ushort month;
	ushort day;
	ushort hour;
	ushort minute;
	ushort second;
	ushort fraction;
	)
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> day [
	"This method was automatically generated"
	^handle unsignedShortAt: 5
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> day: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 5 put: anObject
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> fraction [
	"This method was automatically generated"
	^handle unsignedShortAt: 13
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> fraction: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 13 put: anObject
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> hour [
	"This method was automatically generated"
	^handle unsignedShortAt: 7
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> hour: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 7 put: anObject
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> minute [
	"This method was automatically generated"
	^handle unsignedShortAt: 9
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> minute: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 9 put: anObject
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> month [
	"This method was automatically generated"
	^handle unsignedShortAt: 3
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> month: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 3 put: anObject
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> second [
	"This method was automatically generated"
	^handle unsignedShortAt: 11
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> second: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 11 put: anObject
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> year [
	"This method was automatically generated"
	^handle signedShortAt: 1
]

{ #category : #'accessing structure variables' }
UDBCODBCSQLTimestamp >> year: anObject [
	"This method was automatically generated"
	handle signedShortAt: 1 put: anObject
]
