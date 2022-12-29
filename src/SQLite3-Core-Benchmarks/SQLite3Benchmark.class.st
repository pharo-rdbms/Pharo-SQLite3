"
Benchmarking harness.
"
Class {
	#name : #SQLite3Benchmark,
	#superclass : #Object,
	#instVars : [
		'db',
		'stmt'
	],
	#category : #'SQLite3-Core-Benchmarks-Benchmarking'
}

{ #category : #running }
SQLite3Benchmark >> basicExecute: anSQLText times: aCount [
	
	db beginTransaction.
	1 to: aCount do: [ :i |
		db basicExecute: anSQLText ].
	db commitTransaction.


]

{ #category : #'connecting-disconnecting' }
SQLite3Benchmark >> connectBy: aConnectionClass [
	db := aConnectionClass openOn: ':memory:'
]

{ #category : #'connecting-disconnecting' }
SQLite3Benchmark >> disconnect [
	db close
]

{ #category : #running }
SQLite3Benchmark >> execute: anSQLText times: aCount bindingsBlock: bindingsBlock [
	
	db beginTransaction.
	1 to: aCount do: [ :i |
		db execute: anSQLText with: (bindingsBlock value: i) ].
	db commitTransaction.


]

{ #category : #running }
SQLite3Benchmark >> finalizeStatement [
	stmt ifNotNil: [ stmt finalize ]


]

{ #category : #running }
SQLite3Benchmark >> prepStep: anSQLText times: aCount bindingsBlock: bindingsBlock [
	
	stmt := db prepare: anSQLText.
	db beginTransaction.
	1 to: aCount do: [ :i |
		bindingsBlock value: stmt value: i.
		stmt step; clearBindings; reset ].
	db commitTransaction.


]

{ #category : #running }
SQLite3Benchmark >> runBlock: aBlock [
	
	db beginTransaction.
	aBlock value: db.
	db commitTransaction.


]
