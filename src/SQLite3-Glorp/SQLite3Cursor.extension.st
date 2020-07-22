Extension { #name : #SQLite3Cursor }

{ #category : #'*SQLite3-Glorp' }
SQLite3Cursor >> atEnd [

	^ moreRows not
]

{ #category : #'*SQLite3-Glorp' }
SQLite3Cursor >> rowCount [

	^ statement ifNil: [0] ifNotNil: [ statement changes ]
]

{ #category : #'*SQLite3-Glorp' }
SQLite3Cursor >> upToEnd [

	^ self rows
]
