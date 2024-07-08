Extension { #name : 'Integer' }

{ #category : '*SQLite3-Core' }
Integer >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putInteger: self
]
