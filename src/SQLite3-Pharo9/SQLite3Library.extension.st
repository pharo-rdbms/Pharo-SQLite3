Extension { #name : #SQLite3Library }

{ #category : #'*SQLite3-Pharo9' }
SQLite3Library >> stringFrom: aStatement at: aColumn [
	^ self apiColumnText: aStatement atColumn: aColumn
]
