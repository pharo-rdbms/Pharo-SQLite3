Extension { #name : 'ScaledDecimal' }

{ #category : '*SQLite3-Core' }
ScaledDecimal >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putScaledDecimal: self
]
