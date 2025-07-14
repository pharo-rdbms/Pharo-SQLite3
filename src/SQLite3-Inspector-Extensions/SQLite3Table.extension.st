Extension { #name : 'SQLite3Table' }

{ #category : '*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3Columns: aBuilder [

	<inspectorPresentationOrder: 13 title: 'SQLite3 - Columns'>
	^ aBuilder newTable
		  items: self columns;
		  beResizable;
		  alternateRowsColor;
		  addColumn:
			  (SpStringTableColumn
				   title: 'Index'
				   evaluated: [ :each | each index ]);
		  addColumn:
			  (SpStringTableColumn
				   title: 'Name'
				   evaluated: [ :each | each name ]);
		  addColumn:
			  (SpStringTableColumn
				   title: 'Type'
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
		             addColumn: (SpIndexTableColumn new
				              title: '#';
				              beNotExpandable;
				              yourself);
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
SQLite3Table >> inspectionSQLite3TableProperties: aBuilder [

	<inspectorPresentationOrder: 40 title: 'SQLite3 - Table Properties'>
	^ aBuilder newTable
		  items: self properties associations;
		  beResizable;
		  alternateRowsColor;
		  addColumn: (SpStringTableColumn
				   title: 'Property'
				   evaluated: [ :assoc | assoc key ]);
		  addColumn: (SpStringTableColumn
				   title: 'Value'
				   evaluated: [ :assoc | assoc value ]);
		  yourself
]
