Extension { #name : 'UUID' }

{ #category : '*SQLite3-Core' }
UUID >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putByteArray: uuidData
]
