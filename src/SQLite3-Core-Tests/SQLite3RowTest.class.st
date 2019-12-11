"
Unit tests for SQLite3Row
"
Class {
	#name : #SQLite3RowTest,
	#superclass : #TestCase,
	#instVars : [
		'filledRow',
		'emptyRow'
	],
	#category : #'SQLite3-Core-Tests-Database'
}

{ #category : #running }
SQLite3RowTest >> setUp [
	super setUp.
	emptyRow := SQLite3Row new.
	filledRow := SQLite3Row new columnNames: {'foo'. 'bar'. 'pi'}; yourself.
	filledRow
		at: 'foo' put: 1;
		at: 'bar' put: true;
		at: 'pi' put: '3.14'
]

{ #category : #tests }
SQLite3RowTest >> testAsArray [

	self assert: emptyRow asArray equals: #().	
	self assert: filledRow asArray equals: #(1 true '3.14')
]

{ #category : #tests }
SQLite3RowTest >> testAsCombinedDictionary [
	| dict  |
	dict := Dictionary new.
	dict at: 'foo' put: 1.
	dict at: 'bar' put: true.
	dict at: 'pi' put: '3.14'.
	dict at: 1 put: 1.
	dict at: 2 put: true.
	dict at: 3 put: '3.14'.	
	self assert: emptyRow asCombinedDictionary equals: Dictionary new.	
	self assert: filledRow asCombinedDictionary equals: dict
]

{ #category : #tests }
SQLite3RowTest >> testAsDictionary [
	| dict  |
	dict := Dictionary new.
	dict at: 'foo' put: 1.
	dict at: 'bar' put: true.
	dict at: 'pi' put: '3.14'.
	
	self assert: emptyRow asDictionary equals: Dictionary new.	
	self assert: filledRow asDictionary equals: dict
]

{ #category : #tests }
SQLite3RowTest >> testColumnAccessingIfAbsent [
	|blockExecutedFlag|
	blockExecutedFlag := false.
	
	filledRow at: 'foo' ifAbsent: [ blockExecutedFlag := true ].
	
	self deny: blockExecutedFlag.
	
	filledRow at: 'nope' ifAbsent: [ blockExecutedFlag := true ].
	
	self assert: blockExecutedFlag.
]

{ #category : #tests }
SQLite3RowTest >> testColumnAccessingOnEmptyRow [

	self assert: (emptyRow at: 'foo') equals: nil
]

{ #category : #tests }
SQLite3RowTest >> testColumnAccessingOnFilledRow [

	self assert: (filledRow at: 'foo') equals: 1.
	self assert: (filledRow at: 'bar') equals: true.
	self assert: (filledRow at: 'pi') equals: '3.14'.
	
	self assert: (filledRow at: 'nope') equals: nil
]

{ #category : #tests }
SQLite3RowTest >> testColumnNamesOnEmptyRow [
	self assert: emptyRow columnNames equals: #()

]

{ #category : #tests }
SQLite3RowTest >> testColumnNamesOnFilledRow [
		
	self assert: filledRow columnNames equals: #('foo' 'bar' 'pi')
]

{ #category : #tests }
SQLite3RowTest >> testColumnPuttingOnEmptyRow [
 
	self assert: (emptyRow at: 'foo') equals: nil.
	
	emptyRow at: 'foo' put: 42.
	
	self assert: (emptyRow at: 'foo') equals: 42.

]

{ #category : #tests }
SQLite3RowTest >> testColumnPuttingOnFilledRow [
 
	self assert: (filledRow at: 'foo') equals: 1.
	
	filledRow at: 'foo' put: 2.
	
	self assert: (filledRow at: 'foo') equals: 2
]
