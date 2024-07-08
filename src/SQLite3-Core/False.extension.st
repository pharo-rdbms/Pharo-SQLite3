Extension { #name : 'False' }

{ #category : '*SQLite3-Core' }
False >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putInteger: 0
]
