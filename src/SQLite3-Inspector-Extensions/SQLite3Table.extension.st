Extension { #name : 'SQLite3Table' }

{ #category : '*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3Columns [

	<inspectorPresentationOrder: 13 title: 'SQLite3 - Columns'>
	^ SpTablePresenter new
		  items: self columns;
		  beResizable;
		  addColumn: (SpStringTableColumn
				   title: 'Column Name'
				   evaluated: [ :each | each name ]);
		  addColumn: (SpStringTableColumn
				   title: 'Column Type'
				   evaluated: [ :each | each type ]);
		  addColumn:
			  (SpStringTableColumn
				   title: 'Non-empty values'
				   evaluated: [ :each |
					   each hasNotNullConstraint
						   ifTrue: [ 'NOT NULL' ]
						   ifFalse: [ '' ] ]);
		  yourself
]

{ #category : '*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3Data: aBuilder [

	<inspectorPresentationOrder: 11 title: 'SQLite3 - Data'>
	| presenter |
	presenter := aBuilder newTable
		             items: self rows;
		             beResizable;
		             alternateRowsColor;
		             yourself.
	presenter addColumns: (self columnNames collect: [ :name |
			 SpStringTableColumn
				 title: name
				 evaluated: [ :row | row atName: name ] ]).
	^ presenter
]

{ #category : '*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3Schema: aBuilder [

	<inspectorPresentationOrder: 10 title: 'SQLite3 - Schema'>
	^ aBuilder newText
		  text: self schema;
		  yourself
]

{ #category : '*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3TableProperties [

	<inspectorPresentationOrder: 40 title: 'SQLite3 - Table Properties'>
	^ SpTablePresenter new
		  items: self properties associations;
		  beResizable;
		  addColumn: (SpStringTableColumn
				   title: 'Property'
				   evaluated: [ :assoc | assoc key ]);
		  addColumn: (SpStringTableColumn
				   title: 'Value'
				   evaluated: [ :assoc | assoc value ]);
		  yourself
]
