"
Unit tests for UDBCDatabaseDriver
"
Class {
	#name : #UDBCDatabaseDriverTest,
	#superclass : #TestCase,
	#category : #'UDBC-Tests-Core-Driver'
}

{ #category : #testing }
UDBCDatabaseDriverTest class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self name = #UDBCDatabaseDriverTest
			
]

{ #category : #accessing }
UDBCDatabaseDriverTest >> defaultTestClass [

	^self subclassResponsibility 
]

{ #category : #'tests - general' }
UDBCDatabaseDriverTest >> testDriverID [
	"Each driver needs to have an ID"
	|id|
	id := self defaultTestClass driverId.
	self
		assert: id isString; 
		assert: id notEmpty
]
