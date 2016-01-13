"
A fake database driver used as mock for testing
"
Class {
	#name : #UDBCMockDatabaseDriver,
	#superclass : #Object,
	#category : #'UDBC-Tests-Core-Mocks'
}

{ #category : #'instance creation' }
UDBCMockDatabaseDriver class >> withId: aString [

	^ (self new)
		initID: aString;
		yourself
]

{ #category : #accessing }
UDBCMockDatabaseDriver >> driverId [
	
	^ id
]

{ #category : #accessing }
UDBCMockDatabaseDriver >> initID: aString [ 
	
	id := aString
]

{ #category : #initialization }
UDBCMockDatabaseDriver >> initialize [
	super initialize.
	self initID: 'id'.
]
