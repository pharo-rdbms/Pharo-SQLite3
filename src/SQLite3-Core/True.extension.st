Extension { #name : 'True' }

{ #category : '*SQLite3-Core' }
True >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putInteger: 1
]
