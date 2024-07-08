Extension { #name : 'Object' }

{ #category : '*SQLite3-Core' }
Object >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putObject: self
]
