"
A test class for `SQLite3Database`
"
Class {
	#name : #SQLite3DatabaseTest,
	#superclass : #TestCase,
	#category : 'SQLite3-Core-Tests-Base'
}

{ #category : #tests }
SQLite3DatabaseTest >> testPrintString [

	self assert: SQLite3Database memory printString equals: 'a SQLite3Database(":memory:")'
]
