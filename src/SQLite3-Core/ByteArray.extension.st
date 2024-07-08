Extension { #name : 'ByteArray' }

{ #category : '*SQLite3-Core' }
ByteArray >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putByteArray: self
]
