"
Abstract superclass for extended errors on shared memory access in SQlite3
"
Class {
	#name : 'SQLite3IOErrorSharedMemoryError',
	#superclass : 'SQLite3IOError',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'testing' }
SQLite3IOErrorSharedMemoryError class >> isAbstract [

	^self name = #SQLite3IOErrorSharedMemoryError
]
