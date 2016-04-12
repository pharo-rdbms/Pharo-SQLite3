"
A connection to a PostgreSQL database
"
Class {
	#name : #UDBCPostgreSQLConnection,
	#superclass : #Object,
	#instVars : [
		'trace'
	],
	#classVars : [
		'DefaultTraceLevel'
	],
	#category : #'UDBC-PostgreSQL-Base-Connections'
}

{ #category : #'private - utilities' }
UDBCPostgreSQLConnection class >> chooseTraceLevel [
	|level|
	level := UIManager default chooseFrom: #(0 2 5 8 10) lines: #() title: 'Select Trace level'.
	level ifNotNil: [ self defaultTraceLevel: level ]
]

{ #category : #'tracing - accessing' }
UDBCPostgreSQLConnection class >> defaultTraceLevel [
	
	^DefaultTraceLevel ifNil: [ DefaultTraceLevel := 0 ]
]

{ #category : #'tracing - accessing' }
UDBCPostgreSQLConnection class >> defaultTraceLevel: anInteger [
	<script: 'self chooseTraceLevel'>
	
	DefaultTraceLevel := anInteger
]

{ #category : #initialization }
UDBCPostgreSQLConnection >> initialize [
	 
	super initialize.
	trace := self class defaultTraceLevel.
	
]
