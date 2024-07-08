Extension { #name : 'Time' }

{ #category : '*SQLite3-Core' }
Time >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putTime: self
]
