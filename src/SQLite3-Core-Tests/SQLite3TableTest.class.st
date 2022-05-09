"
A test class for `SQLite3Table`
"
Class {
	#name : #SQLite3TableTest,
	#superclass : #TestCase,
	#category : #'SQLite3-Core-Tests-Base'
}

{ #category : #tests }
SQLite3TableTest >> testName [

	| properties table |
	properties := Dictionary newFromPairs: #( #name 'SimpleTable' ).
	table := SQLite3Table properties: properties in: nil.
	self assert: table name equals: 'SimpleTable'
]

{ #category : #tests }
SQLite3TableTest >> testUnitializedName [ 

	self assert: SQLite3Table new name equals: ''
		
]
