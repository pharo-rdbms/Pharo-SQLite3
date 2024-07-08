Extension { #name : 'DateAndTime' }

{ #category : '*SQLite3-Core' }
DateAndTime >> sqliteBindTo: aStatement at: anInteger [

	aStatement at: anInteger putDateTime: self
]
