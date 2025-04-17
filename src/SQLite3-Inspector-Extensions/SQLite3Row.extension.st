Extension { #name : 'SQLite3Row' }

{ #category : '*SQLite3-Inspector-Extensions' }
SQLite3Row >> inspectionSQLite3Row [
	<inspectorPresentationOrder: 10 title: 'SQlite3 - Contents'>

	| presenter |
	presenter := SpTablePresenter new.
	presenter items: (Array with: self).
	self columnNames do: [:each |
		presenter addColumn: (SpStringTableColumn title: each evaluated: [ :assoc | self at: each ])

	].

	^presenter
]
