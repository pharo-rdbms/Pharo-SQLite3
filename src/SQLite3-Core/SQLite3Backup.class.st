"
I represent a SQLite backup operation.

This is detailed at https://sqlite.org/c3ref/backup_finish.html#sqlite3backupinit
"
Class {
	#name : #SQLite3Backup,
	#superclass : #Object,
	#instVars : [
		'library',
		'srcConnection',
		'srcName',
		'dstConnection',
		'dstName',
		'isOpen',
		'handle'
	],
	#category : #'SQLite3-Core-Connections'
}

{ #category : #creating }
SQLite3Backup class >> to: dConnection named: dName from: sConnection named: sName [
	^(self new)
		dstConnection: dConnection;
		dstName: dName;
		srcConnection: sConnection;
		srcName: sName
]

{ #category : #accessing }
SQLite3Backup >> dstConnection [
	^ dstConnection
]

{ #category : #accessing }
SQLite3Backup >> dstConnection: anObject [
	dstConnection := anObject
]

{ #category : #accessing }
SQLite3Backup >> dstName [
	^ dstName
]

{ #category : #accessing }
SQLite3Backup >> dstName: anObject [
	dstName := anObject
]

{ #category : #finalization }
SQLite3Backup >> finalize [ 
	self finish
]

{ #category : #initialization }
SQLite3Backup >> finish [ 
	handle 
		ifNotNil: [
			library apiBackupFinish: handle.
			handle := nil]
]

{ #category : #accessing }
SQLite3Backup >> handle [
	^ handle
]

{ #category : #accessing }
SQLite3Backup >> handle: anObject [
	handle := anObject
]

{ #category : #initialization }
SQLite3Backup >> initialize [
	super initialize.
	isOpen := false.
	library := SQLite3Library current.
	handle := SQLite3DatabaseExternalObject new.
	handle autoRelease.
]

{ #category : #accessing }
SQLite3Backup >> isOpen [
	^ isOpen
]

{ #category : #accessing }
SQLite3Backup >> open [ 
	handle := (library backupTo: dstConnection named: dstName from: srcConnection named: srcName).
	isOpen := true
]

{ #category : #accessing }
SQLite3Backup >> srcConnection [
	^ srcConnection
]

{ #category : #accessing }
SQLite3Backup >> srcConnection: anObject [
	srcConnection := anObject
]

{ #category : #accessing }
SQLite3Backup >> srcName [
	^ srcName
]

{ #category : #accessing }
SQLite3Backup >> srcName: anObject [
	srcName := anObject
]

{ #category : #accessing }
SQLite3Backup >> step [ 
	"Passing negative number means run to completion"
	self step: -1
]

{ #category : #accessing }
SQLite3Backup >> step: nPages [

	library backup: handle step: nPages
]
