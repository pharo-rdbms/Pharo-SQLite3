"
Benchmarking harness.
"
Class {
	#name : #UDBCSQLiteBenchmark,
	#superclass : #Object,
	#instVars : [
		'db',
		'stmt'
	],
	#category : #'SQLite3-Core-Tests-Connections'
}

{ #category : #running }
UDBCSQLiteBenchmark >> basicExecute: anSQLText times: aCount [
	
	db beginTransaction.
	1 to: aCount do: [ :i |
		db basicExecute: anSQLText ].
	db commitTransaction.


]

{ #category : #'connecting-disconnecting' }
UDBCSQLiteBenchmark >> connectBy: aConnectionClass [
	db := aConnectionClass openOn: ':memory:'
]

{ #category : #'connecting-disconnecting' }
UDBCSQLiteBenchmark >> disconnect [
	db close
]

{ #category : #running }
UDBCSQLiteBenchmark >> execute: anSQLText times: aCount bindingsBlock: bindingsBlock [
	
	db beginTransaction.
	1 to: aCount do: [ :i |
		db execute: anSQLText with: (bindingsBlock value: i) ].
	db commitTransaction.


]

{ #category : #running }
UDBCSQLiteBenchmark >> finalizeStatement [
	stmt ifNotNil: [ stmt finalize ]


]

{ #category : #running }
UDBCSQLiteBenchmark >> prepStep: anSQLText times: aCount bindingsBlock: bindingsBlock [
	
	stmt := db prepare: anSQLText.
	db beginTransaction.
	1 to: aCount do: [ :i |
		bindingsBlock value: stmt value: i.
		stmt step; clearBindings; reset ].
	db commitTransaction.


]

{ #category : #running }
UDBCSQLiteBenchmark >> runBlock: aBlock [
	
	db beginTransaction.
	aBlock value: db.
	db commitTransaction.


]
