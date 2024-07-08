Extension { #name : 'String' }

{ #category : '*SQLite3-Core' }
String >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putString: self
]
