Class {
	#name : #UDBCPostgreSQLConnectionTest,
	#superclass : #TestCase,
	#category : #'UDBC-Tests-PostgreSQL-Base-Connections'
}

{ #category : #accessing }
UDBCPostgreSQLConnectionTest >> defaultTestClass [
	"Return the default class to test"
	
	^UDBCPostgreSQLConnection 
]

{ #category : #'tests - tracing' }
UDBCPostgreSQLConnectionTest >> testDefaultTraceLevel [

	self assert: self defaultTestClass defaultTraceLevel isInteger 
]
