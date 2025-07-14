Extension { #name : 'SQLite3Row' }

{ #category : '*SQLite3-Inspector-Extensions' }
SQLite3Row >> inspectionSQLite3Row: aBuilder [

	<inspectorPresentationOrder: 10 title: 'SQlite3 - Contents'>
	| presenter |
	presenter := aBuilder newTable.
	presenter
		items: (Array with: self);
		addColumns: (self columnNames collect: [ :columnName |
						 SpStringTableColumn
							 title: columnName
							 evaluated: [ :row | row atName: columnName ] ]).
	^ presenter
]
