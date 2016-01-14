"
I am the (unified) FFI interface to SQLite.
"
Class {
	#name : #UDBCSQLiteLibrary,
	#superclass : #Object,
	#pools : [
		'UDBCSQLiteConstants'
	],
	#category : #'UDBC-SQLite-Base-UFFI'
}

{ #category : #'private - accessing' }
UDBCSQLiteLibrary >> library [

	Smalltalk os isMacOS ifTrue: [ ^ #sqlite3 ].
	^ 'sqlite3'
]

{ #category : #'private - conversion' }
UDBCSQLiteLibrary >> pharoStringToUTF8: aPharoString [
	"Converts from Pharo Multibyte Characters to SQLite3 UTF-8 storage format"
	
	^ZnUTF8Encoder new encodeString: aPharoString
]
