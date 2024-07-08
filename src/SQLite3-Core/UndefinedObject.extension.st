Extension { #name : 'UndefinedObject' }

{ #category : '*SQLite3-Core' }
UndefinedObject >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putNil: self
]
