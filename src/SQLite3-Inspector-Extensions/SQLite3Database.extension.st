Extension { #name : 'SQLite3Database' }

{ #category : '*SQLite3-Inspector-Extensions' }
SQLite3Database >> inspectionSQLite3Tables: aBuilder [

	<inspectorPresentationOrder: 10 title: 'Sqlite3 - Tables'>
	^ aBuilder newTable
		  items: self tables;
		  beResizable;
		  alternateRowsColor;
		  addColumn:
			  (SpStringTableColumn
				   title: 'Name'
				   evaluated: [ :table | table name ]);
		  addColumn: (SpStringTableColumn
				   title: 'Number of rows'
				   evaluated: [ :table | table numberOfRows ]);
		  yourself
]
