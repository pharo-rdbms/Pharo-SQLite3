Extension { #name : #SQLite3Table }

{ #category : #'*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3Columns [
	<inspectorPresentationOrder: 13 title: 'SQLite3 - Columns'>

	^ SpTablePresenter new
		items: self columns;
		addColumn: (SpStringTableColumn title: 'Column Name' evaluated: [ :each | each name ]);
		addColumn: (SpStringTableColumn title: 'Column Type' evaluated: [ :each | each type ]);
		addColumn: (SpStringTableColumn title: 'Non-empty values' evaluated: [ :each | each hasNotNullConstraintDisplayString ]);
		yourself
]

{ #category : #'*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3Data [

	<inspectorPresentationOrder: 11 title: 'SQLite3 - Data'>
	| presenter |
	presenter := SpTablePresenter new.
	presenter items: self rows.
	presenter addColumns: (self columnNames collect: [ :columnName |
			 SpStringTableColumn
				 title: columnName
				 evaluated: [ :each | each at: columnName ] ]).
	^ presenter
]

{ #category : #'*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3Schema [
	<inspectorPresentationOrder: 10 title: 'SQLite3 - Schema'>

	^ SpTextPresenter new
		text: self sql;
		yourself
]
