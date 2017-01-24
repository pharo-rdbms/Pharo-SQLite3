"
Benchmarking harness.
"
Class {
	#name : #UDBCSQLiteBenchmark,
	#superclass : #Object,
	#instVars : [
		'db'
	],
	#category : #'UDBC-Tests-SQLite-Base-Connections'
}

{ #category : #processing }
UDBCSQLiteBenchmark >> connectBy: aConnectionClass [
	db := aConnectionClass openOn: ':memory:'
]

{ #category : #processing }
UDBCSQLiteBenchmark >> disconnect [
	db close
]

{ #category : #processing }
UDBCSQLiteBenchmark >> run: anSQLText times: aCount bindingsBlock: bindingsBlock [
	
	db beginTransaction.
	1 to: aCount do: [ :i |
		db execute: anSQLText with: (bindingsBlock value: i) ].
	db commitTransaction.


]

{ #category : #processing }
UDBCSQLiteBenchmark >> runBlock: aBlock [
	
	db beginTransaction.
	aBlock value: db.
	db commitTransaction.


]
