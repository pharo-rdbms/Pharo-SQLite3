Extension { #name : 'Date' }

{ #category : '*SQLite3-Core' }
Date >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putDate: self
]
