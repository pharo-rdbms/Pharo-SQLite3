"
I represent a connection to an SQLite database. I am a test bed for experimental features.

"
Class {
	#name : #UDBCSQLite3ConnectionX,
	#superclass : #UDBCSQLite3BaseConnection,
	#instVars : [
		'statements'
	],
	#category : #'UDBC-SQLite-Base-Connections'
}

{ #category : #initialization }
UDBCSQLite3ConnectionX >> initialize [

	super initialize.
	statements := WeakSet new
]
