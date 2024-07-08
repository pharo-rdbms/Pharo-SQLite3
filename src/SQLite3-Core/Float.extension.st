Extension { #name : 'Float' }

{ #category : '*SQLite3-Core' }
Float >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putFloat: self
]
