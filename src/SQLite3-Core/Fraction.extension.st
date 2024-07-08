Extension { #name : 'Fraction' }

{ #category : '*SQLite3-Core' }
Fraction >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putFloat: self asFloat
]
