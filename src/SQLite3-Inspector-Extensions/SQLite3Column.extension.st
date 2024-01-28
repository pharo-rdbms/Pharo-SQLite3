Extension { #name : #SQLite3Column }

{ #category : #'*SQLite3-Inspector-Extensions' }
SQLite3Column >> hasNotNullConstraintDisplayString [

	^ self hasNotNullConstraint
		  ifTrue: [ 'NOT NULL' ]
		  ifFalse: [ '' ]
]
